This is a plugin for MuseScore 1.2, 2.x, 3.x and 4.x to import ABC notation. The plugin calls a webservice to achieve ABC to MusicXML conversion.

For more info see 

   - The official project page https://musescore.org/en/project/abc-import
   - ABC2XML webservice https://musescore.jeetee.net/abc/abc2xml.py

This branch is for compatibility with Musescore 4.3 and up
For older versions, use the v1-3 branch

To use this plugin:
	- Download the code (compressed zip file)
	- Extract the file in ~/Documents/MuseScore4/Plugins/
	- The plugin should end up in the folder ~/Documents/MuseScore4/Plugins/abc_import

Note for this plugin version (4.1.0)
   - The open file dialog is disabled because Musescore 4 plugin api doesn't implement the open dialog function yet.
   - The api also lacks the file import function. Because of this, the converted xml file can't be opened (imported) automatically after the conversion. The workaround is: once the abc text is converted, a temporary file is saved and the link to that file is copied in the clipboard. Then, Musescore opens a file dialog and you have to paste (the shortcut is ctrl+v) right after the dialog is opened (do not click or move around, just immediately paste using ctrl+v). The file name and its location will show up in the dialog, then you can click open to view the score.
