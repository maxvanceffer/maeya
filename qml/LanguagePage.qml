import Qt 4.7 // to target S60 5th Edition or Maemo 5


Rectangle {
    id: languageSideBar
    property string currentTitle: "English";
    property string currentKey: "en";
    property bool open: false
    property int side: 1;
    property string otherPart: "en"
    color: "#303030";

    LangModel {
        id: langModel
        xml: loader.languages
        onStatusChanged: { if( status === XmlListModel.Ready ) listView.currentIndex = 0; }
    }

    function dropIndex()
    {
        listView.currentIndex = 0;
    }

    // Define a delegate component.  A component will be
    // instantiated for each visible item in the list.
    Component {
        id: languageDelegate
        Item {
            id: wrapper
            width: listView.width; height: 60;
            visible: side === 2 ? loader.isTranslationDirectionAvailable(otherPart,key) : true;
            Image {
                id: directionIcon
                width: 24; height: 24;
                anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter;
                anchors.leftMargin: 95;
                source: "image://flags/"+key;
            }
            Text {
                id: directionTitle
                anchors { verticalCenter: parent.verticalCenter; horizontalCenter: parent.horizontalCenter }
                color: "white"; font.pixelSize: 30
                text: title; font.bold: true;
            }
            Rectangle { height: 2; width: parent.width * 0.6; color: "grey";
                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom; margins: 2; }
            }
            MouseArea {
                anchors.fill:  parent;
                onClicked: {
                    listView.currentIndex = index;
                    currentKey = key;
                    currentTitle = title;
                    console.log("Current title " + currentTitle)
                    console.log("Current title " + currentKey)
                    console.log("item clicked")
                }
            }
        }
    }

    ListView {
        id: listView
        anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom;
        model: langModel
        delegate: languageDelegate
        focus: true
    }
 }

