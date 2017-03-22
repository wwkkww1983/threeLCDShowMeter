import QtQuick 2.3
import QtQuick.Window 2.2

Window {
    id:root
    width: 1920
    height: 720
    color: "black"
    visible: true
    property int speed: /*qstream.speed*/0
    property int rpm: 0
    property int dialNUm: qstream.dial
    property int modles: 0
    property bool once: true
    property int twoFlag: 0
    //    root.speed:qstream.speed
    Image {
        id: bgd
        x: 174
        y: 405
        source: "qrc:/image/image/bgd.png"
    }

    Timer {
        interval: 30000; running: {if(root.modles ===0)
                return false
            else
                return true
            /*root.modles === 1||root.modles===2 ||root.modles===3;*/}
        repeat: true
        onTriggered: {
            switch (root.modles){
            case 1 :root.modles=2
                break;
            case 2 :root.modles=3
                break;
            case 3 :root.modles=1
                break;
            default: break;
            }
        }
    }


    LeftPanel{
        id:leftPanel
        rpmL: rpm
        focus: true
        Keys.onPressed: {
            switch (event.key) {
            case Qt.Key_0:
                root.modles = 1
                console.log("111111111111111111")
                break;
            case Qt.Key_1:
                root.modles = 1
                console.log("111111111111111111")
                break;
            case Qt.Key_2:
                root.modles = 2
                console.log("222222222222222222")
                break;
            case Qt.Key_3:
                root.modles = 3
                console.log("33333333333333333")
            }
        }

        Item{
            id:mapItem
            visible: root.modles ===1 || root.modles === 2
            x:root.modles===1?-80:0
            width: 910
            height: /*480*/590
            Item {
                id:position  //用来辅助定位
                width: 800
                height: /*480*/520
            }

            /*地图的底图*/
            Image {
                id:screenImg
                cache: false       // important!
                x:root.modles === 2 ? 406 :0
                y:root.modles===1?65:0
                width: root.modles===1?910:mapItem.width
                height: root.modles===1?590:mapItem.height
                Item {
                    id: zhe
                    visible: root.modles===2 && qstream.strTurn != " "
                    x:-406
                    Image {
                        id: zheLeft
                        x: 336
                        y: 69
                        source: "qrc:/image/image/zheLeft.png"
                    }
                    Image {
                        id: zheRight
                        x: 1486
                        y: 69
                        source: "qrc:/image/image/zheRight.png"
                    }
                }
            }
            Connections {
                target:client  // the target in ServerMain.cpp : engine.rootContext()->setContextProperty("client", stream);
                onCallQmlRefeshImg: {   // update picture by the singal callQmlRefeshImg of class client
                    screenImg.source = ""
                    screenImg.source = "image://screen"  // 'image:' : the fixed prefix
                    // 'screen' : find in ServerMain.cpp
                    //        engine.addImageProvider(QLatin1String("screen"), stream->imgProvider);
                    indicatorBg.visible = true
                    if(root.modles === 0)
                    {
                        root.modles=1;
//                        once=false;
                    }
                    if(twoFlag<2)
                    {
                        twoFlag++
                    }
                }
            }
            /*转向图标*/
            Image {
                id: screenImgSmallTurn
                cache: false
                x:root.modles===1?80:580
                y:root.modles===1 ? 80 : 110
                //                width:90
                //                height: 90
                width: /*800*/mapItem.width/13
                height: /*480*//*600*/mapItem.height/8
            }
            Connections {
                target:clientSmallTurn
                onCallQmlRefeshImgSmallTurn: {
                    screenImgSmallTurn.source = ""
                    screenImgSmallTurn.source = "image://screenSmallTurn"
                    console.debug("@@@@@@@@ turn @@@@@@@@")
                }
            }
            /*车道图标*/
            Image {
                id: screenImgSmallChannel
                cache: false
                y:100
                anchors.horizontalCenter: screenImg.horizontalCenter
                anchors.top: indicatorBg.bottom
            }
            Connections {
                target:clientSmallChannel
                onCallQmlRefeshImgSmallChannel: {
                    screenImgSmallChannel.source = ""
                    screenImgSmallChannel.source = "image://screenSmallChannel"
                }
            }
            /*路口图*/
            Image {
                id: screenImgSmallCross
                cache: false
                anchors.left: screenImg.left
                anchors.top: screenImg.top
                y:80
                //                width: 800
                //                height: /*480*/520
                width: /*800*/mapItem.width
                height: /*480*//*600*/mapItem.height
            }
            Connections {
                target:clientSmallCross
                onCallQmlRefeshImgSmallCross: {
                    screenImgSmallCross.source = ""
                    screenImgSmallCross.source = "image://screenSmallCross"
                }
            }

            /*摄像头图标*/
            Image {
                id: screenImgSmallCamera
                cache: false
                x:450
                y:150
            }
            Connections {
                target:clientSmallCamera
                onCallQmlRefeshImgSmallCamera: {
                    screenImgSmallCamera.source = ""
                    screenImgSmallCamera.source = "image://screenSmallCamera"
                }
            }

            Image {
                id: screenImgSmallOther
                cache: false
                x:200
                y:300 + 80
            }
            Connections {
                target:clientSmallOther
                onCallQmlRefeshImgSmallOther: {
                    screenImgSmallOther.source = ""
                    screenImgSmallOther.source = "image://screenSmallOther"
                }
            }

            /*文字提示信息底框*/
            Image {
                id:indicatorBg
                opacity: 0.8
                y:115 -20
                visible: false
                anchors.horizontalCenter: screenImg.horizontalCenter
                source:"qrc:/bgimage/pics/indicatorBg.jpg"
            }

            /*语音提示图标*/
            Image {
                id: screenImgSmallLogo
                cache: false
                visible: {
                    console.log(qstream.navi_exit);
                    return !(qstream.navi_exit);
                }
                opacity: 1.0
                //                anchors.horizontalCenter: position.horizontalCenter
                x:{if (root.modles ===1)
                    {screenImgSmallLogo.opacity = 1.0;
                        return 300;
                    }
                    if (root.modles ===2)
                {screenImgSmallLogo.opacity = 1.0;
                        return 900;
                    }
                    if (root.modles ===3)
                        return screenImgSmallLogo.opacity = 0.0
                }
                anchors.top:position.top
                anchors.topMargin:100 + 50 -20
            }
            Connections {
                target:clientSmallLogo
                onCallQmlRefeshImgSmallLogo: {
                    screenImgSmallLogo.source = ""
                    screenImgSmallLogo.source = "image://screenSmallLogo"
                    //                    root.modles = 1
                    if(once)
                    {
                        root.modles=1;
                        once=false;
                    }
                }
            }

            /*转向提示文字信息*/
            Text {
                id:strturn
                font.family :FontName.fontCurrentMicroSoftYahei
                text: qstream.strTurn
                color:"white"
                font.pixelSize: 24
                //                    anchors.top: parent.top
                //                anchors.horizontalCenter: screenImg.horizontalCenter
                anchors.centerIn: indicatorBg
                //                y:115 -20
            }
            /*语音交互提示文字*/
            Text {
                id:strvoice
                text: qstream.strVoice
                color:"white"
                font.pixelSize: 24
                visible: true
                font.family :FontName.fontCurrentMicroSoftYahei
                anchors.horizontalCenter: position.horizontalCenter
                anchors.top: position.top
                anchors.topMargin: 200 +100 -20
            }


            Image {

                id: limt_speed_bg
                x:root.modles===1?80:580
                y:root.modles===1 ? 80 + mapItem.height/7 : 110+mapItem.height/7
                visible: twoFlag == 2 && qstream.strTurn != " "
                width: /*800*/mapItem.width/13
                height: /*480*//*600*/mapItem.height/8
                source: "qrc:/speed_limit.png"
                Text {
                    id: limt_speed
                    anchors.centerIn: limt_speed_bg
                    font.pixelSize: 40
                    scale: root.modles===1?1:1
                    color: "black"
                    font.family :FontName.fontCurrentMicroSoftYahei
                    text: qstream.limitSpeed
                }
            }
        }
    }

    CenterPanel{
        id:centerPanel
        speedC:speed
        dialNUmC: dialNUm
        rpmC: rpm
    }

    RightPanel{
        id:rightPanel
        speedR:speed
        dialNUmR: dialNUm
    }

    ScriptAction{
        running: root.modles === 1
        script: {
            qstream.setCtrlResolution( "1100*663" );
            mapItem.z = 0
            centerPanel.state = "modle1"
            rightPanel.state = "modle1"
            leftPanel.state = "modle1"
            console.log("########################")
        }
    }
    ScriptAction{
        running: root.modles === 2
        script: {
            //            qstream.setCtrlResolution( "1106*663" );
            mapItem.z = 0
            mapItem.width= 1106
            mapItem.height =663

            centerPanel.state = "modle2"
            rightPanel.state = "modle2"
            leftPanel.state = "modle2"

            console.log("**********************")
        }
    }

    ScriptAction{
        running: root.modles === 3
        script: {
            mapItem.z = 0

            centerPanel.state = ""
            rightPanel.state = ""
            leftPanel.state = ""

            console.log("**********************")
        }
    }

    ScriptAction{
        running: qstream.navi_exit === true
        script: {
            root.modles = 0
            mapItem.z = 0
            centerPanel.state = ""
            rightPanel.state = ""
            leftPanel.state = ""
            console.log("########################")
        }
    }

    SequentialAnimation{
        running: true
        ParallelAnimation{
            SequentialAnimation{
                NumberAnimation { target: root;property: "rpm";to:8000;duration: 800;easing.type: Easing.InOutQuad }
                NumberAnimation { target: root;property: "rpm";to:0;duration: 800;easing.type: Easing.InOutQuad }
            }
            SequentialAnimation{
                NumberAnimation { target: root;property: "speed";to:240;duration: 800;easing.type: Easing.InOutQuad }
                NumberAnimation { target: root;property: "speed";to:0;duration: 800;easing.type: Easing.InOutQuad }
            }
        }

        ScriptAction{script: {root.dialNUm = 1 }}
        PauseAnimation{duration: 1500}
        NumberAnimation { target: root;property: "rpm"; to:850;duration: 1500;easing.type: Easing.InOutQuad }
        SequentialAnimation{
            loops: Animation.Infinite
            NumberAnimation { target: root;property: "rpm"; to:850;duration: 1500;easing.type: Easing.InOutQuad }
            ScriptAction{script: {root.dialNUm = 4 ;}}
            ParallelAnimation{
                NumberAnimation { target: root;property: "rpm";to:2000;duration: 2000;easing.type: Easing.InOutQuad }
                NumberAnimation { target: root;property: "speed";to:40;duration: 2000;easing.type: Easing.InOutQuad }
            }
            ParallelAnimation{
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:2500;duration: 1000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:2600;duration: 1000;easing.type: Easing.InOutQuad }
                }
                NumberAnimation { target: root;property: "speed";to:80;duration: 1000;easing.type: Easing.InOutQuad }
            }
            ParallelAnimation{
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:2700;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:2800;duration: 2000;easing.type: Easing.InOutQuad }
                }
                NumberAnimation { target: root;property: "speed";to:120;duration: 2000;easing.type: Easing.InOutQuad }
            }
            ParallelAnimation{
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:2700;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:2900;duration: 2000;easing.type: Easing.InOutQuad }
                }
                SequentialAnimation{
                    NumberAnimation { target: root;property: "speed";to:118;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "speed";to:128;duration: 2000;easing.type: Easing.InOutQuad }
                }
            }
            ParallelAnimation{
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:2000;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:1600;duration: 2000;easing.type: Easing.InOutQuad }
                }
                SequentialAnimation{
                    NumberAnimation { target: root;property: "speed";to:100;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "speed";to:80;duration: 2000;easing.type: Easing.InOutQuad }
                }
            }
            ParallelAnimation{
                ScriptAction{script: {root.dialNUm = 3 }}
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:1000;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:850;duration: 2000;easing.type: Easing.InOutQuad }
                }
                SequentialAnimation{
                    NumberAnimation { target: root;property: "speed";to:30;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "speed";to:0;duration: 2000;easing.type: Easing.InOutQuad }
                }
            }
            ParallelAnimation{
                ScriptAction{script: {root.dialNUm = 4 }}
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:2600;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:2700;duration: 2000;easing.type: Easing.InOutQuad }
                }
                SequentialAnimation{
                    NumberAnimation { target: root;property: "speed";to:40;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "speed";to:80;duration: 2000;easing.type: Easing.InOutQuad }
                }
            }
            ParallelAnimation{
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:2600;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:2700;duration: 2000;easing.type: Easing.InOutQuad }
                }
                SequentialAnimation{
                    NumberAnimation { target: root;property: "speed";to:116;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "speed";to:120;duration: 2000;easing.type: Easing.InOutQuad }
                }
            }
            ParallelAnimation{
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:2200;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:1500;duration: 2000;easing.type: Easing.InOutQuad }
                }
                SequentialAnimation{
                    NumberAnimation { target: root;property: "speed";to:100;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "speed";to:80;duration: 2000;easing.type: Easing.InOutQuad }
                }
            }
            ParallelAnimation{
                ScriptAction{script: {root.dialNUm = 3; }}
                SequentialAnimation{
                    NumberAnimation { target: root;property: "rpm";to:1000;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "rpm";to:850;duration: 2000;easing.type: Easing.InOutQuad }
                }
                SequentialAnimation{
                    NumberAnimation { target: root;property: "speed";to:30;duration: 2000;easing.type: Easing.InOutQuad }
                    NumberAnimation { target: root;property: "speed";to:0;duration: 2000;easing.type: Easing.InOutQuad }
                }
            }
        }

    }
}

