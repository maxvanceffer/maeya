import Qt 4.7

Rectangle {
    id: appWindow

    property bool init: false;
    property bool proccessing: false;
    property int  orentation:  -1;

    // background
    Image {
        id: background
        anchors.fill: parent;
        source: "images/background.png"
    }

    LanguagePage {
        id: leftSideBar
        side: 1;
        color: "#303030";
        anchors.fill: parent;
        opacity: open ? 1 : 0;
        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

    }

    LanguagePage {
        id: rightSideBar;
        side: 2;
    }

    /* this is what moves the normal view aside */
    transform: Translate {
        id: game_translate_
        x: 0
        Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutQuad } }
    }

    /* this is the menu shadow */
    BorderImage {
        id: menu_shadow_
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: -10
        z: -1 /* this will place it below normal_view_ */
        visible: leftSideBar.open || rightSideBar.open;
        source: "images/shadow.png"
        border { left: 12; top: 12; right: 12; bottom: 12 }
    }

    /* put this last to "steal" touch on the normal window when menu is shown */
    MouseArea {
        anchors.fill: parent
        enabled: leftSideBar.open || rightSideBar.open;
        onClicked: appWindow.onLeftMenu();
    }

    /* this functions toggles the menu and starts the animation */
    function onLeftMenu()
    {
        game_translate_.x = leftSideBar.open ? 0 : appWindow.width * 0.9
        leftSideBar.open = !leftSideBar.open;
    }

    function layoutPortrait(){
        sourceTextRectangle.width  = width/2;
        sourceTextRectangle.height = height-bottomToolBar.height;
        sourceTextRectangle.x      = 0;
        sourceTextRectangle.y      = topToolBar.height;

        targetTextRectangle.width  = sourceTextRectangle.width;
        targetTextRectangle.height = sourceTextRectangle.height;
        targetTextRectangle.x      = sourceTextRectangle.width;
        targetTextRectangle.y      = sourceTextRectangle.y;

        leftSideBar.x = -(appWindow.width);
        leftSideBar.height = height;
        leftSideBar.width  = appWindow.width;
    }

    function layoutLandscape(){
        sourceTextRectangle.width  = width;
        sourceTextRectangle.height = (height - (bottomToolBar.height + topToolBar.height))/2;
        sourceTextRectangle.x      = 0;
        sourceTextRectangle.y      = topToolBar.height;

        targetTextRectangle.width  = sourceTextRectangle.width;
        targetTextRectangle.height = sourceTextRectangle.height;
        targetTextRectangle.x      = 0;
        targetTextRectangle.y      = topToolBar.height + sourceTextRectangle.height;

        leftSideBar.x = -(appWindow.width);
        leftSideBar.height = height;
        leftSideBar.width  = appWindow.width;
    }

    onWidthChanged: {

        console.log("width changed to "+width);
        console.log("height changed to "+height);

        if( orentation ===  1 ) layoutPortrait();
    }

    onHeightChanged: {
        console.log("height changed to "+height)

        if( orentation === 3 ) layoutLandscape();
    }

    Rectangle {
        id: body
        anchors.fill: parent;

        // Top tool bar
        Rectangle {
            id: topToolBar
            anchors.top: body.top; anchors.left: body.left; anchors.right: body.right;
            height: 64;
            z: 3000;
            Image {
                id: topToolBarBackground
                source: "images/toolbar.png"
                anchors.fill: parent;
            }

            Image {
                id: closeButton
                fillMode: Image.PreserveAspectCrop
                source: "images/close.png"
                anchors.right: topToolBar.right; anchors.margins: 6
                anchors.top: topToolBar.top; anchors.bottom: topToolBar.bottom;

                MouseArea {
                    anchors.fill: parent;
                    onClicked: window.close();
                }
            }

            Image {
                id: minimzeButton
                width: 64;
                fillMode: Image.PreserveAspectCrop
                anchors.left: topToolBar.left; anchors.margins: 4
                anchors.top:  topToolBar.top; anchors.bottom: topToolBar.bottom;
                source: "images/minimize.png"; smooth: true;
                MouseArea {
                    smooth: true
                    anchors.fill: parent;
                    onClicked: window.minimize();
                }
            }
        }

        // Bottom tool bar
        Rectangle {
            id: bottomToolBar
            anchors.bottom: body.bottom;
            anchors.left: body.left; anchors.right: body.right;
            height: 80;
            z: 3000;
            Image {
                id: bottomToolBarBackground
                source: "images/toolbar.png"
                anchors.fill: bottomToolBar;
            }

            // Left language button
            Rectangle {
                id: leftButton
                anchors.left: bottomToolBar.left;
                anchors.top: bottomToolBar.top; anchors.bottom: bottomToolBar.bottom;
                anchors.leftMargin: 10
                width: (bottomToolBar.width / 3);
                color: "transparent";

                Image {
                    id: leftButtonIcon
                    smooth: true; width: 64; height: 64;
                    fillMode: Image.PreserveAspectCrop
                    anchors.left: parent.left; anchors.margins: 4;
                    anchors.verticalCenter: parent.verticalCenter;
                    source: "image://flags/en";
                }

                Text {
                    id: leftButtonText;
                    anchors.left: leftButtonIcon.right; anchors.margins: 4;
                    anchors.verticalCenter: parent.verticalCenter;
                    text: leftSideBar.currentTitle ? leftSideBar.currentTitle : qsTr("Detect");
                    onTextChanged: {
                        leftButtonIcon.source = "image://flags/"+rightSideBar.currentKey;
                    }
                }

                MouseArea { id: ma_; anchors.fill: parent; onClicked: appWindow.onLeftMenu(); }
            }

            // Right language button
            Rectangle {
                id: rightButton
                anchors.right: bottomToolBar.right;
                anchors.top: bottomToolBar.top; anchors.bottom: bottomToolBar.bottom;
                anchors.rightMargin: 10
                width: (bottomToolBar.width/3);
                color: "transparent";

                Image {
                    id: rightButtonIcon
                    fillMode: Image.PreserveAspectCrop; width: 64; height: 64;
                    anchors.right: parent.right; anchors.margins: 4;
                    anchors.verticalCenter: parent.verticalCenter;
                    source: "image://flags/en";
                }

                Text {
                    id: rightButtonText;
                    anchors.right: rightButtonIcon.left; anchors.margins: 6;
                    anchors.verticalCenter: parent.verticalCenter;
                    text: rightSideBar.currentTitle ? rightSideBar.currentTitle : qsTr("Russian");
                    onTextChanged: {
                        rightButtonIcon.source = "image://flags/"+rightSideBar.currentKey;
                    }
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: rightSideBar.trigger();
                }

            }

            Image {
                id: translateButton
                source: "images/translate.png";
                width: 64; height: 64;
                fillMode: Image.PreserveAspectCrop
                anchors.centerIn: bottomToolBar;
                z: 100000;
                MouseArea {
                    clip: false
                    smooth: false
                    anchors.fill: parent;
                    onClicked: {
                        if( !sourceText.text.length ) return;
                        if( proccessing ) {
                            console.log("Proccessing translation, no request will be");
                            return;
                        }

                        loader.translate(leftSideBar.currentKey,rightSideBar.currentKey,sourceText.text);
                        sequentialOpacity.start();
                        proccessing = true;
                    }
                }

                SequentialAnimation {
                    id: sequentialOpacity
                    running: false

                    NumberAnimation {
                        id: animateOpacity
                        target: translateButton
                        properties: "opacity"
                        from: 1
                        to: 0
                        duration: 600
                        easing {type: Easing.InOutQuad; }
                    }
                    NumberAnimation {
                        id: animateOpacity2
                        target: translateButton
                        properties: "opacity"
                        to: 0
                        from: 1
                        duration: 600
                        easing {type: Easing.InOutQuad;}
                    }
                    ColorAnimation { from: "gray"; to: "white"; duration: 200 }
                    loops: Animation.Infinite
                }
            }
        }

        Rectangle {
            id: sourceTextRectangle;
            color: "gray"; opacity: 0.8;
            radius: 5;
            TextEdit {
                id: sourceText
                anchors.fill: parent; anchors.margins: 6;
                font.pointSize: 14
            }

            Behavior on y {
                   NumberAnimation {
                       easing.type: Easing.OutBounce
                       easing.amplitude: 100
                       duration: 200
                   }
            }

            Behavior on x {
                   NumberAnimation {
                       easing.type: Easing.OutBounce
                       easing.amplitude: 100
                       duration: 200
                   }
            }
        }

        Rectangle {
            id: targetTextRectangle;
            color: "gray"; opacity: 0.6;
            radius: 5;
            TextEdit {
                id: targetText
                anchors.fill: parent; anchors.margins: 6
                font.pointSize: 14;
                text: loader.translation;
                onTextChanged: {
                    proccessing = false;
                    sequentialOpacity.stop();
                }
            }
        }
    }

    function translationTimeout()
    {
        sequentialOpacity.stop();
        translateButton.opacity = 1;
        proccessing = false;
    }

    function orientationChanged(orientation) {

        if(orientation === 1) {
            console.log("or 1");
            if( orentation === 1 ) return;

            orentation = 1;
            leftButtonText.opacity = 1;
            rightButtonText.opacity = 1;

            if( !init ) {
                init = true;
                layoutPortrait();
            }
        }
        else if(orientation === 2) {
            console.log("or 2");
        }
        else if(orientation === 3) {
            console.log("or 3");
            if( orentation === 3 ) return;

            orentation = 3;
            leftButtonText.opacity = 0;
            rightButtonText.opacity = 0;

            if( !init ) {
                init = true;
                layoutLandscape();
            }
        }
        else if(orientation === 4) {
            console.log("or 4");
        }
    }
}