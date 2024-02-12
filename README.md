<h1>Death Crimson 2: Altar of Melanito</h1>
<img width="165" height="165" align="right" src="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/blob/main/images/case.png?raw=true">Download the English translation patch (more information in the <a href="#patching-instructions">Patching Instructions</a> section).
<br><br>
<ul>
 <li><b>GDI Format (Users of ODEs or Emulators)</b><br>Download <a href="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/releases/download/1.0/xxxx">Death Crimson 2 - Altar of Melanito (English v1.0).dcp</a> for use with <a href="https://github.com/DerekPascarella/UniversalDreamcastPatcher">Universal Dreamcast Patcher</a> v1.3 or newer.</li>
 <br>
 <li><b>CDI Format (Users Burning to CD-R)</b><br>Download <a href="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/releases/download/1.0/xxxx">Death Crimson 2 - Altar of Melanito (English v1.0)</a> for use with <a href="https://www.romhacking.net/utilities/704/">Delta Patcher</a> (or equivalent tools).</li>
</ul>

<h2>Table of Contents</h2>

1. [Patching Instructions](#patching-instructions)
2. [Credits](#credits)
3. [Release Changelog](#release-changelog)
4. [Reporting Bugs and Typos](#reporting-bugs-and-typos)
5. [What's Changed](#whats-changed)
6. [About the Game](#about-the-game)
7. [Bonus Content](#bonus-content)
8. [Cheat Function](#cheat-function)
9. [Original Soundtrack](#original-soundtrack)
10. [Voice Recording Feature](#voice-recording)
11. [A Note for CD-R Users](#a-note-for-cd-r-users)
12. [A Note on Light Gun Compatibility](#a-note-on-light-gun-compatibility)

<h2>Patching Instructions</h2>
<ul>
 <li><b>GDI Format (Users of ODEs or Emulators)</b><br><img align="right" width="250" src="https://github.com/DerekPascarella/UniversalDreamcastPatcher/blob/main/screenshots/screenshot.png?raw=true">The DCP patch file shipped with this release is designed for use with <a href="https://github.com/DerekPascarella/UniversalDreamcastPatcher">Universal Dreamcast Patcher</a> v1.3 or newer.  Note that Universal Dreamcast Patcher supports both TOSEC-style GDI and Redump-style CUE disc images as source input.<br><br><ol type="1"><li>Click "Select GDI or CUE" to open the source disc image.</li><li>Click "Select Patch" to open the DCP patch file.</li><li>Click "Apply Patch" to generate the patched GDI, which will be saved in the folder from which the application is launched.</li><li>Click "Quit" to exit the application.</li></ol></li>
 <br>
 <li><b>CDI Format (Users Burning to CD-R)</b><br><img align="right" width="250" src="https://i.imgur.com/r4b04e7.png">The XDelta patch file shipped with this release can be used with any number of Delta utilities, such as <a href="https://www.romhacking.net/utilities/704/">Delta Patcher</a>. Ensure the source CDI has an MD5 checksum of <tt>ABA9C3600EBDD4FBE292ABA87B43630B</tt>.<br><br><ol type="1"><li>Click the settings icon (appears as a gear) and enable "Backup original file" and "Checksum validation".</li><li>Click the "Original file" browse icon and select the unmodified CDI.</li><li>Click the "XDelta patch" browse icon and select the XDelta patch.</li><li>Click "Apply patch" to generate the patched CDI in the same folder containing the original CDI.</li><li>Verify that the patched CDI has an MD5 checksum of <tt>6A2C77A36EA8E07960BE3B12C93CAF21</tt>.</ol></li>
</ul>

<h2>Credits</h2>
<ul>
 <li><b>Programming / Hacking</b></li>
  <ul>
   <li>Derek Pascarella (ateam)</li>
  </ul>
  <br>
  <li><b>Translation</b></li>
  <ul>
   <li>Walnut</li>
   <li>Filler</li>
   <li>wiredcrackpot</li>
  </ul>
  <br>
  <li><b>Graphics</b></li>
  <ul>
   <li>Derek Pascarella (ateam)</li>
  </ul>
  <br>
  <li><b>Video</b></li>
  <ul>
   <li>Derek Pascarella (ateam)</li>
  </ul>
  <br>
  <li><b>Special Thanks</b></li>
  <ul>
   <li>Light Gun Testers</li>
   <ul>
    <li>ItsMuchMore</li>
    <li>Peter Bray</li>
    <li>Steve Wells</li>
    <li>Roger Braunstein (partlyhuman)</li>
    <li>megavolt85</li>
    <li>amerika</li>
   </ul>
   <li>CDI Optimization Assistance.</li>
   <uL>
    <li>Pitito</li>
  </ul>
</ul>

<h2>Release Changelog</h2>
<ul>
 <li>Version 1.0 (2024-XX-XX)</li>
 <ul>
  <li>Initial release.</li>
 </ul>
</ul>

<h2>Reporting Bugs and Typos</h2>
Even after extensive testing on both real hardware and on emulators, the presence of bugs or typos may be possible. Should a player encounter any such issue, it's kindly requested that they <a href="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/issues/new">submit a new issue</a> to this project page, including as much detailed information as possible.

<h2>What's Changed</h2>
<img align="right" width="267" height="200" src="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/blob/main/images/screenshot.png?raw=true">Below is a high-level list of changes implemented for this English translation patch.
<br><br>
<ul>
 <li>A new ASCII font has been implemented.</li>
 <li>All textures/graphics have been translated into English, in addition to correction of misspelled English place names (e.g., street signs) in order to align with official Western release of "Death Crimson OX".</li>
 <li>All in-game dialogue/menu/message text has been translated into English.</li>
 <li>All in-game cutscene videos have been translated and subtitled in English, with special optimizations made for CDI version of the patch (see <a href="#a-note-for-cd-r-users">A Note for CD-R Users</a>).</li>
 <li>New code for VMU icon supported has been added to the game (read more in <a href="https://www.dreamcast-talk.com/forum/viewtopic.php?f=52&t=17030&start=10#p182850">this Dreamcast-Talk.com forum post</a> and <a href="https://twitter.com/DerekPascarella/status/1750506678728933458">this Twitter post</a>).
 <li>A bug has been fixed that prevented a certain piece of dialogue text from being rendered.</li>
 <li>Title screen graphics have been improved and re-rendered.</li>
 <li>All unlockable "Mission Mode" stages are enabled by default.</li>
 <li>VMU save file metadata has been translated into English.</li>
 <li>Missing disc art PVR has been added for GDmenu users.</li>
 <li>A brand-new cheat function has been implemented (see <a href="#cheat-function">Cheat Function</a> section).</li>
 <li>The built-in web browser has been replaced with special bonus content (see <a href="#bonus-content">Bonus Content</a> section).</li>
  <ul>
   <li>Previously this portion of the game was inaccessible to those who've never configured ISP settings on their Dreamcast, but this requirement has been removed.</li>
  </ul>
</ul>

<h2>About the Game</h2>
<img align="right" width="180" height="320" src="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/blob/main/images/vmu.gif?raw=true">
<table>
<tr>
<td><b>Title</b></td>
<td>Death Crimson 2: Altar of Melanito (デスクリムゾン２ −メラニートの祭壇−)</td>
</tr>
<tr>
<td><b>Developer</b></td>
<td>Ecole</td>
</tr>
<tr>
<td><b>Publisher</b></td>
<td>Ecole</td>
</tr>
<tr>
<td><b>Release Date</b></td>
<td>1999-11-25</td>
</tr>
<tr>
<td><b>Supported Peripherals</b></td>
<td>VGA Box, Jump Pack, Controller, Light Gun, VMU, Microphone</td>
</table>
"Death Crimson 2: Altar of Melanito" (デスクリムゾン２ −メラニートの祭壇−) is a sequel to the original "Death Crimson" game on the SEGA Saturn. Unlike its predecessor, the sequel features a full story mode, fleshing out the backstory behind the game's numerous characters, while also introducing new ones.
<br><br>
Players can use either the standard Dreamcast controller or light gun during the shooting sections of the game.

<h2>Bonus Content</h2>
<img align="right" width="267" src="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/blob/main/images/bonus.gif?raw=true">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris dapibus nisi vel massa interdum sollicitudin. Nam vel sollicitudin nibh. Donec sagittis mauris vel finibus bibendum. Proin vehicula sodales tellus quis interdum. Curabitur pretium nulla ut diam gravida, nec venenatis mauris eleifend. Maecenas eu magna ut ipsum dictum elementum. In hac habitasse platea dictumst. Morbi enim sem, dapibus eget cursus nec, tempus ut massa. Praesent id magna vel sapien luctus efficitur. In et interdum justo. Sed faucibus egestas nisi in bibendum. Donec non elit sollicitudin, porta nisl eu, vulputate turpis.

<h2>Cheat Function</h2>
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris dapibus nisi vel massa interdum sollicitudin. Nam vel sollicitudin nibh. Donec sagittis mauris vel finibus bibendum. Proin vehicula sodales tellus quis interdum. Curabitur pretium nulla ut diam gravida, nec venenatis mauris eleifend. Maecenas eu magna ut ipsum dictum elementum. In hac habitasse platea dictumst. Morbi enim sem, dapibus eget cursus nec, tempus ut massa. Praesent id magna vel sapien luctus efficitur. In et interdum justo. Sed faucibus egestas nisi in bibendum. Donec non elit sollicitudin, porta nisl eu, vulputate turpis.

<h2>Original Soundtrack</h2>
<img align="right" width="168" height="165" src="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/blob/main/images/ost.jpg?raw=true">Along with the game's release on November 25th, 1999, an original soundtrack was sold under the title "Death Crimson 2 - Yuri Rosenberg". The soundtrack features 15 individual tracks, all of which can be heard throughout the Dreamcast game itself.
<br><br>
To learn more about the soundtrack, including credits for songwriters, music arrangers, and vocalists, visit its entry on <a href="https://vgmdb.net/album/9438">VGMdb</a>.
<br><br>
To coincide with the release of this English translation patch, this soundtrack was procured from Japan (read more in <a href="https://twitter.com/DerekPascarella/status/1752792117070504093">this Twitter post</a>) and is available for <a href="https://mega.nz/folder/CM1lRA6S#S3TsOjU2tMOdYOEQrgfClA">download</a> in FLAC, MP3, and OGG formats.

<h2>Voice Recording Feature</h2>
<img align="right" width="240" height="320" src="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/blob/main/images/microphone.jpg?raw=true">
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris dapibus nisi vel massa interdum sollicitudin. Nam vel sollicitudin nibh. Donec sagittis mauris vel finibus bibendum. Proin vehicula sodales tellus quis interdum. Curabitur pretium nulla ut diam gravida, nec venenatis mauris eleifend. Maecenas eu magna ut ipsum dictum elementum. In hac habitasse platea dictumst. Morbi enim sem, dapibus eget cursus nec, tempus ut massa. Praesent id magna vel sapien luctus efficitur. In et interdum justo. Sed faucibus egestas nisi in bibendum. Donec non elit sollicitudin, porta nisl eu, vulputate turpis.

<h2>A Note for CD-R Users</h2>
<img align="right" width="267" height="200" src="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/blob/main/images/cdi.jpg?raw=true">A tremendous amount of additional modification and testing was done for this patch in order to provide those burning to disc (and not using an ODE or emulator) the smoothest possible gaming experience.
<br><br>
"Death Crimson 2: Altar of Melanito" is very read-heavy in terms of how it seeks and streams data from the disc. This becomes particularly aggressive during FMV playback, especially when dual FMV and audio streaming occurs (as is the case in several cutscenes).
<br><br>
Previous CDI releases of the game handled this horribly, with no optimizations in place in order to mitigate out-of-sync audio/video. For this English translation patch, great care has gone into encoding audio/video so that a moderately healthy GD-ROM drive will be able to read and stream this data without excessive synchronization issues.
<br><br>
However, players must bare in mind that despite said optimizations, experiencing this game via CD-R will still be suboptimal. Players will notice a moment or two where on-screen subtitles do not perfectly align with spoken dialogue. Please recognize that this is not a bug, but in fact a limitation of the Dreamcast's CD-ROM reading speed.

<h2>A Note on Light Gun Compatibility</h2>
<img align="right" width="200" height="200" src="https://github.com/DerekPascarella/DeathCrimson2AltarofMelanito-EnglishPatchDreamcast/blob/main/images/lightgun.jpg?raw=true">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris dapibus nisi vel massa interdum sollicitudin. Nam vel sollicitudin nibh. Donec sagittis mauris vel finibus bibendum. Proin vehicula sodales tellus quis interdum. Curabitur pretium nulla ut diam gravida, nec venenatis mauris eleifend. Maecenas eu magna ut ipsum dictum elementum. In hac habitasse platea dictumst. Morbi enim sem, dapibus eget cursus nec, tempus ut massa. Praesent id magna vel sapien luctus efficitur. In et interdum justo. Sed faucibus egestas nisi in bibendum. Donec non elit sollicitudin, porta nisl eu, vulputate turpis.
