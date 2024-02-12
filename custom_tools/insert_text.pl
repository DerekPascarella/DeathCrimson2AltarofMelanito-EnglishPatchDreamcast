#!/usr/bin/perl
#
# note:
# of all the game tools i've written, this is one of the sloppiest and worst.
# honestly, i've been too busy to optimize or thoroughly comment this code
# whatsoever. that said, it does work. i promise the patch still works
# excellently, though.

use utf8;
use strict;
use File::Copy;
use Text::Wrap;
use File::Copy;
use HTML::Entities;
use POSIX qw(strftime);
use Spreadsheet::ParseXLSX;
use String::HexConvert ':all';
use Spreadsheet::Read qw(ReadData);

# Set STDOUT encoding to UTF-8.
binmode(STDOUT, "encoding(UTF-8)");

my $mode = $ARGV[0];

my $executable_path = "/mnt/z/dc/gdi/new/death_crimson_2/gdi_extracted/00DEA.BIN";

my @names = ("ALGA", "ASSIM", "DANNY", "GREG", "KOU", "LILY", "MARK",
			 "MARTHA", "MASURA", "MacNELLY", "MELANITO", "NURSE", "PAT",
			 "ECHIZEN", "YURI", "ZAZA");

my $spreadsheet = ReadData("00DEA_DIALOGUE_NEW.xlsx");
my @spreadsheet_rows = Spreadsheet::Read::rows($spreadsheet->[1]);

unlink("warning.log");

my $rolling_hex;
my %pointers;
my $rolling_size = 0;
my $rolling_pointer = 349912;
my $processed_count = 0;

my $patch_section = 1;
my $patch_space = 73444;
my $patch_loc = 349912;

my %patch_data;

for(my $i = 1; $i < scalar(@spreadsheet_rows); $i ++)
{
	my $ptr_orig = int($spreadsheet_rows[$i][0]);
	my $ptr_loc = $spreadsheet_rows[$i][1];
	my $type = $spreadsheet_rows[$i][2];
	my $text = decode_entities($spreadsheet_rows[$i][4]);

	$text =~ s/\P{IsPrint}//g;
	$text =~ s/[^[:ascii:]]+//g;

	$ptr_loc =~ s/'//g;

	if($ptr_loc !~ /,/)
	{
		$ptr_loc = int($ptr_loc);
	}

	my $ignore = 1;

	my $hex;

	if($text ne "")
	{
		my $row_number = $i+1;

		print "row: $row_number\n";
		print "ptr_loc: $ptr_loc\n";
		print "type: $type\n";
		print "text: $text\n";

		if($type eq "")
		{
			print "WARNING: Missing text type!\n";
			system "echo \"ROW $row_number - missing text type\" >> warning.log";
		}

		# dialogue with speaker name
		if(grep(/$type/i, @names) || $type eq "SPEAKER")
		{
			$ignore = 0;

			$Text::Wrap::columns = 33;

			if($type ne "SPEAKER")
			{
				$text = "  " . $type . ": " . $text;
			}
			else
			{
				$text =~ s/^\s+//; # remove leading whitespace
			}

			my $text_wrapped = wrap("", "", $text);
			my @text_array = split("\n", $text_wrapped);

			# add two leading spaces back to first row of text if SPEAKER type
			if($type eq "SPEAKER")
			{
				$text_array[0] = "  " . $text_array[0];
			}

			for(my $j = 0; $j < scalar(@text_array); $j ++)
			{
				if($j > 2)
				{
					print "WARNING: Text exceeds 3 lines!\n";
					system "echo \"ROW $row_number - dialogue text exceeds 3 lines\" >> warning.log";
				}
				else
				{
					my $line = $text_array[$j];

					print "[$line]\n";

					if($j == 0)
					{
						$line =~ s/  $type\: //g;
					}

					$hex .= ascii_to_hex($line);

					# break newline if not last line of dialogue text
					if($j < scalar(@text_array) - 1)
					{
						$hex .= "81A18140";
					}
				}
			}

			print "hex: $hex\n";
		}
		# text overlaid on cutscenes
		elsif($type eq "CINEMATIC")
		{
			$ignore = 0;

			$text =~ s/^\s+|\s+$//g;

			$Text::Wrap::columns = 33;

			my $text_wrapped = wrap("", "", $text);
			my @text_array = split("\n", $text_wrapped);

			for(my $j = 0; $j < scalar(@text_array); $j ++)
			{
				if($j > 1)
				{
					print "WARNING: Cinematic text exceeds 2 lines!\n";
					system "echo \"ROW $row_number - cutscene text exceeds 2 lines\" >> warning.log";
				}
				else
				{
					my $line = $text_array[$j];

					print "[$line]\n";

					# processing first line of text
					if($j == 0)
					{
						# prepend and append two empty spaces for first line of multi-line text if there's
						# more than one line of text
						if(scalar(@text_array) > 1)
						{
							$line = "  " . $line . "  ";
						}
					}
					# append two empty spaces for any line after first (8140 already prepends after break)
					elsif($j > 0)
					{
						$line .= "  ";
					}

					$hex .= ascii_to_hex($line);

					# break newline if not last line of dialogue text
					if($j < scalar(@text_array) - 1)
					{
						$hex .= "81A18140";
					}
				}
			}

			print "hex: $hex\n";
		}
		# sound effects
		elsif($type eq "SFX")
		{
			$ignore = 0;

			$text =~ s/^\s+|\s+$//g;

			$Text::Wrap::columns = 33;

			my $text_wrapped = wrap("", "", $text);
			my @text_array = split("\n", $text_wrapped);

			for(my $j = 0; $j < scalar(@text_array); $j ++)
			{
				if($j > 2)
				{
					print "WARNING: Sound effect exceeds 3 lines!\n";
					system "echo \"ROW $row_number - sound effect text exceeds 3 lines\" >> warning.log";
				}
				else
				{
					my $line = $text_array[$j];

					print "[$line]\n";

					# prepend and append two empty spaces for first line of multi-line text
					if($j == 0)
					{
						$line = "  " . $line . "  ";
					}
					# append two empty spaces for any line after first (8140 already prepends after break)
					elsif($j > 0)
					{
						$line .= "  ";
					}

					$hex .= ascii_to_hex($line);

					# break newline if not last line of dialogue text
					if($j < scalar(@text_array) - 1)
					{
						$hex .= "81A18140";
					}
				}
			}

			print "hex: $hex\n";
		}
		# player choices
		elsif($type eq "CHOICE")
		{
			$ignore = 0;

			$text =~ s/^\s+|\s+$//g;
			$hex = ascii_to_hex($text);

			print "hex: $hex\n";

			if(length($text) > 36)
			{
				print "WARNING: Choice answer exceeds 36 characters!\n";
				system "echo \"ROW $row_number - choice text exceeds 36 characters\" >> warning.log";
			}
		}
		# system messages
		elsif($type eq "SYSMSG")
		{
			$ignore = 0;

			$text =~ s/^\s+|\s+$//g;
			$hex = ascii_to_hex($text);
			$hex =~ s/^ff//g;

			print "hex: $hex\n";
		}
		# control codes
		elsif($type eq "CTRLCD")
		{
			$ignore = 0;

			$text =~ s/^\s+|\s+$//g;
			$hex = $text;
			$hex =~ s/CC\://g;

			print "hex: $hex\n";
		}
		# just test data
		else
		{
			$ignore = 0;

			$hex = ascii_to_hex($text);
			$hex =~ s/^ff//g;

			print "hex: $hex\n";
		}
	}

	if(!$ignore)
	{
		if($type ne "CTRLCD")
		{
			# pad hex
			$hex .= "00";

			while((length($hex) / 2) % 4 != 0)
			{
				$hex .= "00";
			}
		}

		# shift patch location based on size of data
		if($rolling_size + (length($hex) / 2) > $patch_space)
		{
			if($patch_section == 1)
			{
				print "INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\nINFO: last line will be processed again\n\n";
				system "echo \"INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\" >> warning.log";

				$patch_section = 2;
				$patch_space = 13456;
				$patch_loc = 1140096;
				$rolling_size = 0;
				$rolling_hex = "";
				$rolling_pointer = 1140096;

				$i --;
			}
			elsif($patch_section == 2)
			{
				print "INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\nINFO: last line will be processed again\n\n";
				system "echo \"INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\" >> warning.log";

				$patch_section = 3;
				$patch_space = 15408;
				$patch_loc = 1203616;
				$rolling_size = 0;
				$rolling_hex = "";
				$rolling_pointer = 1203616;

				$i --;
			}
			elsif($patch_section == 3)
			{
				print "INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\nINFO: last line will be processed again\n\n";
				system "echo \"INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\" >> warning.log";

				$patch_section = 4;
				$patch_space = 9248;
				$patch_loc = 1315376;
				$rolling_size = 0;
				$rolling_hex = "";
				$rolling_pointer = 1315376;

				$i --;
			}
			elsif($patch_section == 4)
			{
				print "INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\nINFO: last line will be processed again\n\n";
				system "echo \"INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\" >> warning.log";

				$patch_section = 5;
				$patch_space = 7264;
				$patch_loc = 1325136;
				$rolling_size = 0;
				$rolling_hex = "";
				$rolling_pointer = 1325136;

				$i --;
			}
			elsif($patch_section == 5)
			{
				print "CRITICAL: no more space left in executable for text!\n";
				system "echo \"CRITICAL: no more space left in executable for text\" >> warning.log";
			}
			# elsif($patch_section == 5)
			# {
			# 	print "INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\n";
			# 	system "echo \"INFO: $patch_space byte limit for section $patch_section reached (loc $patch_loc)\" >> warning.log";

			# 	$patch_section = 6;
			# 	$patch_space = 5392;
			# 	$patch_loc = 1334496;
			# 	$rolling_size = 0;
			# 	$rolling_hex = "";
			# 	$rolling_pointer = 1334496;
			# }
			# elsif($patch_section == 6)
			# {
			# 	print "CRITICAL: no more space left in executable for text!\n";
			# 	system "echo \"CRITICAL: no more space left in executable for text\" >> warning.log";
			# }
		}
		# room left in primary section
		else
		{
			$processed_count ++;

			# don't add key for empty pointer locations, as they don't need updating
			if($ptr_loc ne "0")
			{
				$pointers{$ptr_loc} = $rolling_pointer;
			}
			
			$rolling_pointer += (length($hex) / 2);

			$rolling_hex .= $hex;

			$rolling_size = length($rolling_hex) / 2;

			$patch_data{$patch_loc} = $rolling_hex;

			if($ptr_loc ne "0")
			{
				print "new ptr: " . $pointers{$ptr_loc} . " (was $ptr_orig)\n";
			}
			else
			{
				print "pointer skipped ($ptr_orig)\n";
			}

			print "\n";
		}
	}
}

print "processed " . $processed_count . " rows\n\n";
print "updating pointers:\n";

# backup existing game executable
my $timestamp = strftime("%Y-%m-%d-%H-%M-%S", localtime);
copy($executable_path, "executable_backups/$timestamp - 00DEA.BIN");

# iterate through each pointer key in numeric order
foreach my $ptr_loc ( sort { $a <=> $b } keys %pointers )
{
	my @ptr_locs = split(/,/, $ptr_loc);

	foreach(@ptr_locs)
	{
		$_ = int($_);

		# store LE hex representation of new pointer, adding 0x8c010000 for DC base address
		my $ptr_new = &endian_swap(&decimal_to_hex($pointers{$ptr_loc} + 2348875776));

		if($mode ne "test")
		{
			&patch_bytes($executable_path, $ptr_new, $_);
		}

		print " -> at $ptr_loc updated to $ptr_new";

		if(scalar(@ptr_locs) > 1)
		{
			print " - $_\n";
		}
		else
		{
			print "\n";
		}
	}
}

print "\n";
print "processed " . (keys %pointers) . " pointers\n\n";

if($mode ne "test")
{
	# restore original japanese dialogue data before patching
	my $diag_jp = &read_bytes("DIAL_JP.BIN");
	&patch_bytes($executable_path, $diag_jp, 349912);

	# restore original null data for section 1
	my $dummy_hex;
	my $dummy_length = 13456;
	my $dummy_location = 1140096;

	for(1 .. $dummy_length)
	{
		$dummy_hex .= "00";
	}

	&patch_bytes($executable_path, $dummy_hex, $dummy_location);

	# restore original null data for section 2
	$dummy_hex = "";
	$dummy_length = 13456;
	$dummy_location = 1140096;

	for(1 .. $dummy_length)
	{
		$dummy_hex .= "00";
	}

	&patch_bytes($executable_path, $dummy_hex, $dummy_location);

	# restore original null data for section 3
	$dummy_hex = "";
	$dummy_length = 15408;
	$dummy_location = 1203616;

	for(1 .. $dummy_length)
	{
		$dummy_hex .= "00";
	}

	&patch_bytes($executable_path, $dummy_hex, $dummy_location);

	# restore original null data for section 4
	$dummy_hex = "";
	$dummy_length = 9248;
	$dummy_location = 1315376;

	for(1 .. $dummy_length)
	{
		$dummy_hex .= "00";
	}

	&patch_bytes($executable_path, $dummy_hex, $dummy_location);

	# restore original null data for section 5
	$dummy_hex = "";
	$dummy_length = 7264;
	$dummy_location = 1325136;

	for(1 .. $dummy_length)
	{
		$dummy_hex .= "00";
	}

	&patch_bytes($executable_path, $dummy_hex, $dummy_location);

	# # restore original null data for section 6
	# $dummy_hex = "";
	# $dummy_length = 5392;
	# $dummy_location = 1334496;

	# for(1 .. $dummy_length)
	# {
	# 	$dummy_hex .= "00";
	# }

	# &patch_bytes($executable_path, $dummy_hex, $dummy_location);

	# iterate through each patch data key in numeric order
	foreach my $location ( sort { $a <=> $b } keys %patch_data )
	{
		&patch_bytes($executable_path, $patch_data{$location}, $location);
		
		print "patched game executable at location $location (" . (length($patch_data{$location}) / 2) . " bytes)\n\n";
	}
}

print "patched game executable with translated text\n\n";

# update CDI's executable
copy($executable_path, "/mnt/z/dc/gdi/new/death_crimson_2/cdi/cdi_builder/data/00DEA.BIN");
copy($executable_path, "/mnt/z/dc/gdi/new/death_crimson_2/cdi/cdi_builder/data_testing/00DEA.BIN");

sub read_bytes
{
	my $input_file = $_[0];
	my $byte_count = $_[1];

	if($byte_count eq "")
	{
		$byte_count = (stat $input_file)[7];
	}

	open my $filehandle, '<:raw', $input_file or die $!;
	read $filehandle, my $bytes, $byte_count;
	close $filehandle;
	
	return unpack 'H*', $bytes;
}

sub patch_bytes
{
	my $output_file = $_[0];
	(my $hex_data = $_[1]) =~ s/\s+//g;
	my @hex_data_array = split(//, $hex_data);
	my $patch_offset = $_[2];

	if((stat $output_file)[7] < $patch_offset + (scalar(@hex_data_array) / 2))
	{
		die "Offset for patch_bytes is outside of valid range ($patch_offset).\n";
	}

	open my $filehandle, '+<:raw', $output_file or die $!;
	binmode $filehandle;
	seek $filehandle, $patch_offset, 0;

	for(my $i = 0; $i < scalar(@hex_data_array); $i += 2)
	{
		my($high, $low) = @hex_data_array[$i, $i + 1];
		print $filehandle pack "H*", $high . $low;
	}

	close $filehandle;
}

sub decimal_to_hex
{
	if($_[1] eq "")
	{
		$_[1] = 0;
	}

	return sprintf("%0" . $_[1] * 2 . "X", $_[0]);
}

sub endian_swap
{
	(my $hex_data = $_[0]) =~ s/\s+//g;
	my @hex_data_array = ($hex_data =~ m/../g);

	return join("", reverse(@hex_data_array));
}