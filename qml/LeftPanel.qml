import QtQuick 2.0
import QtQuick 2.3
//import QtQuick.Window 2.1


Item {
    id:root
    width: 1920
    height: 720
    visible: true
    property string textTurn: "textTurn"
    property int speedL: 0
    property int rpmL: 0
    property int dialNUmC: 0


    Image {
        id: mapBig
        visible: false
        source: "qrc:/image/image/mapBig.png"

    }


    Item{
        id:info
        visible: true
        Item{
            Image {
                id: overInfo
                x: -8
                y: -2
                source: "qrc:/image/image/overInfo.png"
            }
            Image {
                id: bottomInfo
                x: -792
                y: 643
                source: "qrc:/image/image/bottom1.png"
            }

        }
    }
    Item {
        id: leftItem
        x:0
        opacity: 1.0
        Image {
            id: leftMeter
            x: -12
            y: -20
            source: "qrc:/image1/image1/leftMeterG.png"
            Image {
                id: leftIol
                source: "qrc:/image1/image1/leftIol.png"
            }
            Item{
                id:rpmNUm
                DigitValue{
                    id:rpm1
                    spacing: 1
                    anchors.top: parent.top
                    anchors.topMargin: 360 - 13
                    anchors.left: parent.left
                    anchors.leftMargin: 570 - 40 -225 -20
                    icon0: "qrc:/image1/image1/n0.png"
                    icon1: "qrc:/image1/image1/n1.png"
                    icon2: "qrc:/image1/image1/n2.png"
                    icon3: "qrc:/image1/image1/n3.png"
                    icon4: "qrc:/image1/image1/n4.png"
                    icon5: "qrc:/image1/image1/n5.png"
                    icon6: "qrc:/image1/image1/n6.png"
                    icon7: "qrc:/image1/image1/n7.png"
                    icon8: "qrc:/image1/image1/n8.png"
                    icon9: "qrc:/image1/image1/n9.png"
                    fromScale: 1.0
                    value: Math.floor(root.rpmL/1000);
                }
                Rectangle {
                    id: dot
                    x:348 +12
                    y:380 +20
                    width: 11
                    height: 11
                    color: "white"
                }
                DigitValue{
                    id:rpmDot
                    spacing: 1
                    anchors.top: parent.top
                    anchors.topMargin: 360 -13
                    anchors.left: parent.left
                    anchors.leftMargin: 570+35 -225 - 10
                    icon0: "qrc:/image1/image1/n0.png"
                    icon1: "qrc:/image1/image1/n1.png"
                    icon2: "qrc:/image1/image1/n2.png"
                    icon3: "qrc:/image1/image1/n3.png"
                    icon4: "qrc:/image1/image1/n4.png"
                    icon5: "qrc:/image1/image1/n5.png"
                    icon6: "qrc:/image1/image1/n6.png"
                    icon7: "qrc:/image1/image1/n7.png"
                    icon8: "qrc:/image1/image1/n8.png"
                    icon9: "qrc:/image1/image1/n9.png"
                    fromScale: 1.0
                    //                        value: (root.rpm%1000)/100
                    value: Math.floor(root.rpmL%1000/100);
                }
            }

            Item {
                id: leftRpm
                x:12
                y:20
                Image {
                    id: leftRpm0
                    x: 195
                    y: 538
                    opacity: root.rpm<=1000 ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm0.png"
                }
                Image {
                    id: leftRpm1
                    x: 111
                    y: 420
                    opacity: root.rpmL<=2000 ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm1.png"
                }
                Image {
                    id: leftRpm2
                    x: 110
                    y: 267
                    opacity: (root.rpmL>=1000 && root.rpmL <= 3000) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm2.png"
                }
                Image {
                    id: leftRpm3
                    x: 194
                    y: 151
                    opacity: (root.rpmL>=2000 && root.rpmL <= 4000) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm3.png"
                }
                Image {
                    id: leftRpm4
                    x: 338
                    y: 99
                    opacity: (root.rpmL>=3000 && root.rpmL <= 5000) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm4.png"
                }
                Image {
                    id: leftRpm5
                    x: 478
                    y: 151
                    opacity: (root.rpmL>=4000 && root.rpmL <= 6000) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm5.png"
                }
                Image {
                    id: leftRpm6
                    x: 566
                    y: 267
                    opacity: (root.rpmL>=5000 && root.rpmL <= 7000) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm6.png"
                }
                Image {
                    id: leftRpm7
                    x: 570
                    y: 420
                    opacity: (root.rpmL>=6000 && root.rpmL <= 8000) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm7.png"
                }
                Image {
                    id: leftRpm8
                    x: 487
                    y: 538
                    opacity: (root.rpmL>=7000 && root.rpmL <= 8000) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/leftRpm8.png"
                }
            }

            Image {
                id: leftLineLight
                x: 202 + 12
                y: 65 + 20
                source: "qrc:/image1/image1/leftLineLight.png"
                transform: Rotation{
                    origin.x:355.5 - 202 ; origin.y:359.5 - 65
                    angle: root.rpmL/1000*36-144
                }
            }
            Image {
                id: leftLine
                x: 347 + 12
                y: 72 + 20
                source: "qrc:/image1/image1/leftLine.png"
                transform: Rotation{
                    origin.x:355.5 - 347 ; origin.y:359.5 - 72
                    angle: root.rpmL/1000*36-144
                }
            }
        }
    }


    Image {
        id: iolWater
        x: 300
        y: 668
        z:5
        visible: false
        source: "qrc:/image/image/iolWater.png"
    }
    Image {
        id: small_1000rpm
        x: /*288*/940
        y: /*422*/408
        z:5
        visible: false
        source: "qrc:/image1/image1/small_1000rpm.png"
    }

    states: [
        State {
            name: ""
            PropertyChanges {
                target: small_1000rpm
                visible:false
            }
        },
        State {
            name: "modle1"
            PropertyChanges {
                target: iolWater
                visible: true
            }
        },
        State {
            name: "modle2"
            PropertyChanges {
                target: small_1000rpm
                visible:true
            }
            PropertyChanges {
                target: leftMeter
                scale:0.83
            }
            PropertyChanges {
                target: iolWater
                visible: true
            }
        }
    ]
    transitions: [
        Transition {
            from: ""
            to: "modle1"
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {target: leftItem;property: "x"; to:605;duration: 1500}
                    NumberAnimation {target: rpmNUm;property: "opacity";to:0.0;duration: 1500}
                    NumberAnimation {target: leftIol;property: "opacity";to:0.0;duration: 1500}
                }
                NumberAnimation {target: leftItem;property: "z";to:2;duration: 0}
                NumberAnimation {target: info;property: "z";to:1;duration: 0}

                PauseAnimation {
                    duration: 1000
                }
            }
        },
        Transition {
            from: "modle1"
            to: "modle2"
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {target: leftItem;property: "x"; to:0;duration: 1500}

                    NumberAnimation {target: leftMeter;property: "x";to:12 /*- 605 */- 60; duration: 1500}
                    NumberAnimation {target: leftMeter;property: "y";to:-15; duration: 1500}
                    NumberAnimation {target: small_1000rpm;property: "x";to:149 + 100; duration: 1500}
                    NumberAnimation {target: small_1000rpm;property: "y";to:390 + 25; duration: 1500}
                    NumberAnimation {target: leftMeter;property: "scale"; duration: 1500}
                    NumberAnimation {target: leftIol;property: "opacity";to:0.0;duration: 500}
                    NumberAnimation {target: leftRpm;property: "opacity";to:0.0;duration: 1200}
                    NumberAnimation {target: small_1000rpm;property: "scale";to:0.9;duration: 1500}
                    NumberAnimation {target: rpmNUm;property: "opacity";to:1.0;duration: 1500}
                }
                NumberAnimation {target: info;property: "z";to:1;duration: 0}
                PauseAnimation {
                    duration: 1000
                }
            }
        },

        Transition {
            from: "modle2"
            to: ""
            SequentialAnimation{
                ParallelAnimation{
                    ScriptAction{script: {leftMeter.z = 5}}
                    NumberAnimation {target: leftMeter;property: "x";to:12 /*- 605*/ - 20; duration: 1500}
                    NumberAnimation {target: leftMeter;property: "y";to:-15; duration: 1500}
                    NumberAnimation {target: small_1000rpm;property: "x";to:149 + 100; duration: 1500}
                    NumberAnimation {target: small_1000rpm;property: "y";to:390; duration: 1500}
                    NumberAnimation {target: leftMeter;property: "scale"; duration: 1500}
                    NumberAnimation {target: leftIol;property: "opacity"; to:1.0 ;duration: 500}
                    NumberAnimation {target: leftRpm;property: "opacity";to:1.0;duration: 1200}
                    NumberAnimation {target: small_1000rpm;property: "scale";to:1.0; duration: 1500}
                    ScriptAction{script: {small_1000rpm.visible = true }}
                    NumberAnimation {target: rpmNUm;property: "opacity"; to:1.0; duration: 1500}
                }
                NumberAnimation {target: info;property: "z";to:1;duration: 0}
                PauseAnimation {
                    duration: 1000
                }
            }
        },

        Transition {
            from: "modle1"
            to: ""

            SequentialAnimation{
                SequentialAnimation{
                    ParallelAnimation{
                        NumberAnimation {target: leftItem;property: "x"; to:0;duration: 150}

                        NumberAnimation {target: leftMeter;property: "x";to:12 /*- 605 */- 60; duration: 150}
                        NumberAnimation {target: leftMeter;property: "y";to:-15; duration: 150}
                        NumberAnimation {target: small_1000rpm;property: "x";to:149 + 100; duration: 150}
                        NumberAnimation {target: small_1000rpm;property: "y";to:390 + 25; duration: 150}
                        NumberAnimation {target: leftMeter;property: "scale";to:0.83; duration: 150}
                        NumberAnimation {target: leftIol;property: "opacity";to:0.0;duration: 50}
                        NumberAnimation {target: leftRpm;property: "opacity";to:0.0;duration: 120}
                        NumberAnimation {target: small_1000rpm;property: "scale";to:0.9;duration: 150}
                        NumberAnimation {target: rpmNUm;property: "opacity";to:1.0;duration: 150}
                    }
                    NumberAnimation {target: info;property: "z";to:1;duration: 0}
                    PauseAnimation {
                        duration: 10
                    }
                }

                ParallelAnimation{
                    ScriptAction{script: {leftMeter.z = 5}}
                    NumberAnimation {target: leftMeter;property: "x";to:12 /*- 605*/ - 20; duration: 1500}
                    NumberAnimation {target: leftMeter;property: "y";to:-15; duration: 1500}
                    NumberAnimation {target: small_1000rpm;property: "x";to:149 + 100; duration: 1500}
                    NumberAnimation {target: small_1000rpm;property: "y";to:390; duration: 1500}
                    NumberAnimation {target: leftMeter;property: "scale"; to:1.0;duration: 1500}
                    NumberAnimation {target: leftIol;property: "opacity"; to:1.0 ;duration: 500}
                    NumberAnimation {target: leftRpm;property: "opacity";to:1.0;duration: 1200}
                    NumberAnimation {target: small_1000rpm;property: "scale";to:1.0; duration: 1500}
                    ScriptAction{script: {small_1000rpm.visible = false }}
                    NumberAnimation {target: rpmNUm;property: "opacity"; to:1.0; duration: 1500}
                }
                NumberAnimation {target: info;property: "z";to:1;duration: 0}
                PauseAnimation {
                    duration: 1000
                }
            }
        }
    ]

}
