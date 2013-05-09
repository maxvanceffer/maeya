import Qt 4.7

Rectangle {
    id: appWindow

    property bool init: false;
    property bool proccessing: false;
    property int  orentation:  -1;


    LanguagePage {
        id: leftSideBar
        side: 1;
        color: "#303030";
        anchors.fill: parent;
        opacity: open ? 1 : 0;

        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

        onCurrentTitleChanged: {
            console.log("Left icon change");
            if( !open ) return;

            rightSideBar.otherPart = currentKey;

            onLeftMenu();
        }
    }

    LanguagePage {
        id: rightSideBar;
        side: 2;
        color: "#303030";
        anchors.fill: parent;
        opacity: open ? 1 : 0;
        Behavior on opacity {
            NumberAnimation { duration: 300 }
        }

        onCurrentTitleChanged: {
            console.log("Right icon change")
            if( !open ) return;

            onRightMenu();
        }
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

    /* this is the menu shadow */
    BorderImage {
        id: menu_shadow_right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right;
        anchors.margins: 10
        z: -1 /* this will place it below normal_view_ */
        visible: leftSideBar.open || rightSideBar.open;
        source: "images/shadow.png"
        border { left: 12; top: 12; right: 12; bottom: 12 }
    }

    /* this functions toggles the menu and starts the animation */
    function onLeftMenu()
    {
        game_translate_.x = leftSideBar.open ? 0 : appWindow.width * 0.9
        leftSideBar.open  = !leftSideBar.open;
    }

    /* this functions toggles the menu and starts the animation */
    function onRightMenu()
    {
        game_translate_.x = -( rightSideBar.open ? 0 : appWindow.width * 0.9 )
        rightSideBar.open  = !rightSideBar.open;
    }

    function layoutPortrait(){

        sourceTextRectangle.width  = (width/2) - 8;

        sourceTextRectangle.anchors.margins = 4;
        sourceTextRectangle.anchors.left    = body.left;
        sourceTextRectangle.anchors.top     = topToolBar.bottom;
        sourceTextRectangle.anchors.bottom  = bottomToolBar.top;

        targetTextRectangle.anchors.margins = 4;
        targetTextRectangle.width  = sourceTextRectangle.width;
        targetTextRectangle.height = sourceTextRectangle.height;
        targetTextRectangle.anchors.left = sourceTextRectangle.right;
        targetTextRectangle.anchors.top = topToolBar.bottom;

        leftSideBar.x = -(appWindow.width);
        leftSideBar.height = height;
        leftSideBar.width  = appWindow.width;

        change.rotation = 270;
        change.anchors.right = targetTextRectangle.left;
        change.anchors.rightMargin = -( change.width / 2 );
    }

    function layoutLandscape(){
        sourceTextRectangle.anchors.margins = 4;
        sourceTextRectangle.anchors.left  = body.left;
        sourceTextRectangle.height = ((height - (bottomToolBar.height + topToolBar.height))/2) - 8;
        sourceTextRectangle.anchors.top   = topToolBar.bottom;
        sourceTextRectangle.anchors.right = body.right;

        targetTextRectangle.anchors.margins = 4;
        targetTextRectangle.anchors.left    = body.left;
        targetTextRectangle.anchors.right   = body.right;
        targetTextRectangle.anchors.top     = sourceTextRectangle.bottom;
        targetTextRectangle.anchors.bottom  = bottomToolBar.top;

        leftSideBar.x = -(appWindow.width);
        leftSideBar.height = height;
        leftSideBar.width  = appWindow.width;

        change.anchors.bottomMargin = -( change.width / 2 );
        change.anchors.bottom       = sourceTextRectangle.bottom;
        change.anchors.left         = sourceTextRectangle.left;
        change.rotation = 0;
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
        anchors.top: appWindow.top; anchors.bottom: appWindow.bottom;
        anchors.left: appWindow.left; anchors.right: appWindow.right;

        // background
        Image {
            id: background
            anchors.fill: parent;
            source: "images/background.png"
        }

        /* put this last to "steal" touch on the normal window when menu is shown */
        MouseArea {
            anchors.fill: parent
            enabled: leftSideBar.open || rightSideBar.open;
            z: 3000;
            onClicked: {
                if( rightSideBar.open ) appWindow.onRightMenu();
                if( leftSideBar.open )  appWindow.onLeftMenu();
            }
        }

        /* this is what moves the normal view aside */
        transform: Translate {
            id: game_translate_
            x: 0
            Behavior on x { NumberAnimation { duration: 400; easing.type: Easing.OutQuad } }
        }

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

            Row {
                id: topToolBarLayout
                anchors.fill: parent;
                spacing: 4;
                Image {
                    id: minimzeButton
                    width: 64;
                    fillMode: Image.PreserveAspectCrop
                    source: "images/minimize.png"; smooth: true;
                    MouseArea {
                        smooth: true
                        anchors.fill: parent;
                        onClicked: window.minimize();
                    }
                }

                Image {
                    id: bookmarksButton
                    source: "images/bookmarks.png"
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: { console.log("not implemented") }
                    }
                }

                Image {
                    id: aboutButton
                    width: 64; height: 64;
                    fillMode: Image.PreserveAspectFit
//                    fillMode: Image.
                    source: "images/about.png"
                    MouseArea {
                        anchors.fill: parent;
                        onClicked: {
                            console.log("not implemented")
                        }
                    }
                }

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
                    anchors.left: parent.left; anchors.margins: 4;
                    anchors.verticalCenter: parent.verticalCenter;
                    source: "image://flags/"+leftSideBar.currentKey;
                }

                Text {
                    id: leftButtonText;
                    anchors.left: leftButtonIcon.right; anchors.margins: 4;
                    anchors.verticalCenter: parent.verticalCenter;
                    text: leftSideBar.currentTitle;
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
                    width: 64; height: 64;
                    anchors.right: parent.right; anchors.margins: 4;
                    anchors.verticalCenter: parent.verticalCenter;
                    source: "image://flags/" + rightSideBar.currentKey;
                }

                Text {
                    id: rightButtonText;
                    anchors.right: rightButtonIcon.left; anchors.margins: 6;
                    anchors.verticalCenter: parent.verticalCenter;
                    text: rightSideBar.currentTitle;
                }

                MouseArea {
                    anchors.fill: parent;
                    onClicked: appWindow.onRightMenu();
                }

            }

            Image {
                id: translateButton
                source: "images/translate.png";
                width: 64; height: 64;
                fillMode: Image.PreserveAspectCrop
                anchors.centerIn: bottomToolBar;
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
                    running: false;
                    alwaysRunToEnd: true;
                    PropertyAnimation {
                        id: hardBeatAnimation1
                        target: translateButton; easing.type: Easing.InOutQuad; properties: "width,height";
                        from: 64; to: 120; duration: 800;
                    }
                    PropertyAnimation {
                        id: hardBeatAnimation2
                        target: translateButton; easing.type: Easing.InOutQuad; properties: "width,height";
                        from: 120; to: 64; duration: 800;
                    }

                    loops: Animation.Infinite
                }
            }
        }

        Rectangle {
            id: sourceTextRectangle;
            color: "white"; opacity: 0.6;
            radius: 5;
            TextEdit {
                id: sourceText
                cursorVisible: true
                wrapMode: TextEdit.WordWrap
                anchors.fill: parent; anchors.margins: 6;
                font.pointSize: 18
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

        Image {
            id: change
            width: 64; height: 64;
            fillMode: Image.PreserveAspectFit
            anchors.bottom: sourceTextRectangle.bottom;
            source: "images/change.png"; z: 999
            MouseArea {
                z: 1000
                rotation: 0
                anchors.fill: parent;
                onClicked: {
                    if( targetText.text.length ) {

                        var sKey   = leftSideBar.currentKey;
                        var sTitle = leftSideBar.currentTitle;
                        var sText  = sourceText.text;

                        sourceText.text = targetText.text;
                        targetText.text = sText;

                        leftSideBar.currentKey   = rightSideBar.currentKey;
                        leftSideBar.currentTitle = rightSideBar.currentTitle;

                        rightSideBar.currentKey   = sKey;
                        rightSideBar.currentTitle = sTitle;

                        rightSideBar.dropIndex();
                    }
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
                font.pointSize: 18
                text: loader.translation; readOnly: true;
                onTextChanged: {
                    proccessing = false;
                    sequentialOpacity.stop();
                    translateButton.opacity = 1;
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
