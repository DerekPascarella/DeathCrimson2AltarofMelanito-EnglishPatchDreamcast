#!/usr/bin/perl

use utf8;
use strict;
use Encode qw(decode encode);
use Spreadsheet::WriteExcel;
use HTTP::Tiny;
use JSON;
use URI::Encode qw(uri_encode uri_decode);
use HTML::Entities;

# Set STDOUT encoding to UTF-8.
binmode(STDOUT, "encoding(UTF-8)");

my $dlg = &read_bytes("/mnt/z/dc/gdi/new/death_crimson_2/custom_tools/DIAL_JP.BIN");
my $dlg_pos = 349912;
my @dlg_arry = ($dlg =~ m/../g);

my $bin = &read_bytes("/mnt/z/dc/gdi/new/death_crimson_2/gdi_extracted/00DEA.BIN");
my @bin_arr = ($bin =~ m/......../g);

my %strings;
my $rolling_pos = 349912;
my $chunk_hex;
my $last_chunk_hex;

for(my $i = 0; $i < scalar(@dlg_arry); $i ++)
{
	my $byte = $dlg_arry[$i];

	if($byte ne "00")
	{
		if($chunk_hex eq "" && $i > 0)
		{
			$rolling_pos = $dlg_pos + $i;
		}

		$chunk_hex .= $byte;
	}
	elsif($byte eq "00")
	{
		if($chunk_hex ne "")
		{
			my $text = Encode::decode("shiftjis", pack "H*", $chunk_hex);

			# store text in hash
			$strings{$rolling_pos}{"text"} = $text;

			# special handling of control code data at 367244 [59A8Ch]
			if(uc($chunk_hex) eq "50323130312E415258")
			{
				my $custom_pos;

				$custom_pos = $rolling_pos + 12;
				$strings{$custom_pos}{"text"} = "CC:40010000F00000000200FFFF";
				$custom_pos += 12;
				$strings{$custom_pos}{"text"} = "CC:40010000600100000300FFFF";

				$i += 26;
			}
			# special handling of control code data at 404492 [62C0Ch]
			elsif(uc($chunk_hex) eq "91E582AB82C882A890A2986282B3")
			{
				my $custom_pos;

				$custom_pos = $rolling_pos + 16;
				$strings{$custom_pos}{"text"} = "CC:0100FFFF010064003A11000065003B11060066003C11040067003D11020068003E11030069003F110500C800441101002C014E110100900158110100F4016211010058026C110100";
				
				$i += 73;
			}
		}

		$chunk_hex = "";
	}
}

my $unfound_pointer_locs = 0;

# iterate through each pointer key in numeric order
foreach my $pos ( sort { $a <=> $b } keys %strings )
{
	my $found = 0;

	for(my $j = 0; $j < scalar(@bin_arr); $j ++)
	{
		my $pos_dc = &endian_swap(&decimal_to_hex($pos + 2348875776));

		if(uc($pos_dc) eq uc($bin_arr[$j]))
		{
			if($strings{$pos}{"location"} ne "")
			{
				$found = 1;
				$strings{$pos}{"location"} .= "," . $j * 4;
				print "found additional location dec. " . ($j * 4) . " for ptr " . $pos . "\n";
			}
			else
			{
				$found = 1;
				$strings{$pos}{"location"} = $j * 4;
				print "found location dec. " . ($j * 4) . " for ptr " . $pos . "\n";
			}
		}
	}

	if(!$found)
	{
		$unfound_pointer_locs ++;
	}
}

if($unfound_pointer_locs > 0)
{
	print "\nWARNING: Total unfound pointer locations -> $unfound_pointer_locs\n\n";
}

# Create spreadsheet.
my $workbook = Spreadsheet::WriteExcel->new("00DEA_DIALOGUE_NEW.xls");
my $worksheet = $workbook->add_worksheet();

# Define spreadsheet header row.
my $header_bg_color = $workbook->set_custom_color(40, 191, 191, 191);
my $header_format = $workbook->add_format();
$header_format->set_bold();
$header_format->set_border();
$header_format->set_bg_color(40);

# Define spreadsheet formatting.
my $cell_format = $workbook->add_format();
$cell_format->set_border();
$cell_format->set_align('left');
$cell_format->set_text_wrap();

my @types = ("ARUGA", "ASSYM", "DANNY", "GREG", "KOU", "LILY", "MACK",
			 "MARTHA", "MASURA", "MELANITO", "NURSE", "PAT", "ECHIZEN",
			 "YURI", "ZAZA", "SFX", "CHOICE", "CINEMATIC", "SPEAKER",
			 "SYSMSG", "CTRLCD");

$worksheet->data_validation('C2:C' . (keys(%strings) + 1), { validate => 'list', value => [@types] });

# Define spreadsheet column widths.
$worksheet->set_column('A:A', 7);
$worksheet->set_column('B:B', 7);
$worksheet->set_column('C:C', 14);
$worksheet->set_column('D:D', 55);
$worksheet->set_column('E:E', 55);
$worksheet->set_column('F:F', 30);
$worksheet->set_column('G:G', 55);

# Define spreadsheet header row's labels.
$worksheet->write(0, 0, "Pointer", $header_format);
$worksheet->write(0, 1, "Ptr. Loc.", $header_format);
$worksheet->write(0, 2, "Type", $header_format);
$worksheet->write(0, 3, "Japanese Original", $header_format);
$worksheet->write(0, 4, "English Translation", $header_format);
$worksheet->write(0, 5, "Notes", $header_format);
$worksheet->write(0, 6, "Machine Translation", $header_format);

my $count = 0;

# iterate through each pointer key in numeric order
foreach my $pos ( sort { $a <=> $b } keys %strings )
{
	# Write each element to a column in current spreadsheet row.
	$worksheet->write($count + 1, 0, $pos, $cell_format);

	if($strings{$pos}{"location"} =~ /,/)
	{
		$worksheet->write($count + 1, 1, "'" . $strings{$pos}{"location"}, $cell_format);
	}
	else
	{
		$worksheet->write($count + 1, 1, $strings{$pos}{"location"}, $cell_format);
	}

	my $jap_text = $strings{$pos}{"text"};

	if($jap_text =~ /^CC\:/)
	{
		$worksheet->write($count + 1, 2, "CTRLCD", $cell_format);
	}
	elsif($jap_text =~ /^[A-Z|a-z]/)
	{
		$worksheet->write($count + 1, 2, "SYSMSG", $cell_format);
	}
	else
	{
		$worksheet->write($count + 1, 2, "", $cell_format);
	}

	$worksheet->write_utf16be_string($count + 1, 3, Encode::encode("utf-16", $jap_text), $cell_format);

	$worksheet->write($count + 1, 4, "", $cell_format);
	$worksheet->write($count + 1, 5, "", $cell_format);

	my $machine_translation = "";
	my $api_call_success = 0;
	my $deepl_api_key = "xxxxxxxxxxxxx";
	
	$jap_text =~ s/■/\r\n/g;

	print "---[$jap_text]---\n";

	my $api_call_success = 0;

	while(!$api_call_success)
	{
		my $http = HTTP::Tiny->new;
		my $post_data = uri_encode("auth_key=" . $deepl_api_key . "&target_lang=EN-US&source_lang=JA&text=" . $jap_text);
		my $response = $http->get("https://api.deepl.com/v2/translate?" . $post_data);
		$machine_translation = decode_json($response->{'content'})->{'translations'}->[0]->{'text'};

		if($response->{'status'} eq "200")
		{
			$api_call_success = 1;
		}
	}

	if($machine_translation =~ /^=/)
	{
		$worksheet->write($count + 1, 6, " $machine_translation ", $cell_format);
	}
	else
	{
		$worksheet->write($count + 1, 6, $machine_translation, $cell_format);
	}

	$count ++;
}

# Close spreadsheet.
$workbook->close();




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