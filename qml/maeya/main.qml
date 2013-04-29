import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    property string api_key: "trnsl.1.1.20130429T131831Z.dd31273997625541.c6aec0cff6e47f112edbc062c4fdb167a145ad25";
    property string baseurl: "https://translate.yandex.net/api/v1.5/tr/";

    initialPage: mainPage

    MainPage {
        id: mainPage
    }

    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status === DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem { text: qsTr("Sample menu item") }
        }
    }
}
