import Qt 4.7 // to target S60 5th Edition or Maemo 5


Rectangle {
    id: languageSideBar
    property string currentTitle: "English";
    property string currentKey: "en";
    property bool open: false
    property int side: 1;
    property bool enableExtraRow: false;
    color: "#303030";

    LangModel {
        id: langModel
        xml: loader.languages
        onStatusChanged: { if( status === XmlListModel.Ready ) listView.currentIndex = 0; }
    }

    // Define a delegate component.  A component will be
    // instantiated for each visible item in the list.
    Component {
        id: languageDelegate
        Item {
            id: wrapper
            width: listView.width; height: 80;
            MouseArea {
                anchors.fill:  parent;
                onClicked: {
                    console.log("item clicked")
                    listView.currentIndex = index;
                    currentKey = key;
                    currentTitle = title;
                }
            }
            Item {
                Text {
                    anchors { left: parent.left; leftMargin: 12; verticalCenter: parent.verticalCenter }
                    color: "white"; font.pixelSize: 32
                    text: title; font.bold: true;
                }
                Rectangle { height: 2; width: parent.width * 0.7; color: "gray"; anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom } }
            }
            // indent the item if it is the current item
            states: State {
                name: "Current"
                when: wrapper.ListView.isCurrentItem
                PropertyChanges { target: wrapper; x: 20 }
            }
            transitions: Transition {
                NumberAnimation { properties: "x"; duration: 200 }
            }
        }
    }

    ListView {
        id: listView
        anchors { fill: parent; margins: 22; }
        model: langModel
        delegate: languageDelegate
        focus: true
    }
 }

