//=============================================================================
//
//  ABC Import Plugin
//  Based on ABC Import by Nicolas Froment (lasconic)
//  Copyright (2013) Stephane Groleau (vgstef)
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//=============================================================================

import QtQuick
import QtQuick.Dialogs
import QtQuick.Controls
import QtQuick.Window
import MuseScore
import FileIO

MuseScore {
    menuPath: "Plugins.ABC Import"
    title: "ABC Import"
    version: "4.1.0"
    description: qsTr("This plugin imports ABC text from a file or the clipboard. Internet connection is required.")
    thumbnailName: "abc-import.png"
    categoryCode: "import"
    requiresScore: false
    pluginType: "dialog"

    id: pluginDialog
    width: 800; height: 600;

    onRun: {}

    FileIO {
        id: myFileAbc
        onError: console.log(msg + "  Filename = " + myFileAbc.source)
        }

    FileIO {
        id: myFile
        source: tempPath() + "/my_file.xml"
        onError: console.log(msg)
        }

    FileDialog {
        id: importFileDialog
        title: qsTr("Please choose a file")
        onAccepted: {
            var filename = fileDialog.fileUrl
            //console.log("You chose: " + filename)

            if(filename){
                myFileAbc.source = filename
                //read abc file and put it in the TextArea
                abcText.text = myFileAbc.read()
                }
            }
        }

    Label {
        id: textLabel
        wrapMode: Text.WordWrap
        text: qsTr("Paste your ABC tune here (or click button to load a file)\nYou need to be connected to internet for this plugin to work")
        font.pointSize:12
        anchors.left: pluginDialog.left
        anchors.top: pluginDialog.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        }

    // Where people can paste their ABC tune or where an ABC file is put when opened
    TextArea {
        id:abcText
        anchors.top: textLabel.bottom
        anchors.left: pluginDialog.left
        anchors.right: pluginDialog.right
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        wrapMode: TextEdit.WrapAnywhere
        textFormat: TextEdit.PlainText
        }

	Label {
        id: textNote
        wrapMode: Text.WordWrap
        text: qsTr("The open file dialog is disabled because of Musescore 4 plugin api limitations. The api also lacks the file import function. Because of this, the converted xml file can't be opened (imported) automatically after the conversion. The workaround is: once the abc text is converted, a temporary file is saved and the link to that file is copied in the clipboard. Then, Musescore opens a file dialog and you have to paste (the shortcut is ctrl+v) right after the dialog is opened.")
        font.pointSize:10
        anchors.left: pluginDialog.left
        anchors.right: pluginDialog.right
        anchors.bottom: convertedStorageLocationLabel.top
        anchors.leftMargin: 10
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        }
        
	TextEdit {
        id: convertedStorageLocationLabel
        text: ""
        //font.pointSize:12
        //anchors.top: textNote.bottom
        anchors.left: pluginDialog.left
        anchors.right: pluginDialog.right
        anchors.bottom: buttonOpenFile.top
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        readOnly: true
        //selectByKeyboard: true
        //selectByMouse: true
        }

    Button {
        id : buttonOpenFile
        text: qsTr("Open file")
        anchors.bottom: pluginDialog.bottom
        anchors.left: pluginDialog.left
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.leftMargin: 10
        enabled: false
        onClicked: {
            importFileDialog.visible();
            }
        }

    Button {
        id : buttonConvert
        text: qsTr("Import")
        anchors.bottom: pluginDialog.bottom
        anchors.right: pluginDialog.right
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.rightMargin: 10
        onClicked: {
            var content = "content=" + encodeURIComponent(abcText.text)
            //console.log("content : " + content)

            var request = new XMLHttpRequest()
            request.onreadystatechange = function() {
                if (request.readyState == XMLHttpRequest.DONE) {
                    var response = request.responseText
                    //console.log("responseText : " + response)
                    myFile.source = myFile.tempPath() + "/" + (Date.now()) + ".xml";
                    myFile.write(response);
                    //readScore(myFile.source) // Not yet supported in 4.0.0
                    convertedStorageLocationLabel.text = myFile.source;
                    convertedStorageLocationLabel.selectAll();
                    convertedStorageLocationLabel.copy();
                    convertedStorageLocationLabel.deselect();
                    cmd("file-open");
                    pluginDialog.parent.Window.window.close();
                    }
                }
            request.open("POST", "https://musescore.jeetee.net/abc/abc2xml.py", true)
            request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
            request.send(content)
            }
        }

    Button {
        id : buttonCancel
        text: qsTr("Cancel")
        anchors.bottom: pluginDialog.bottom
        anchors.right: buttonConvert.left
        anchors.topMargin: 10
        anchors.bottomMargin: 10
        anchors.rightMargin: 10
        onClicked: {
                pluginDialog.parent.Window.window.close();
            }
        }
    }
