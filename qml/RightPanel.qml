import QtQuick 2.0

Item {
    id:rightRoot
    x:0
    property int speedR: 0
    property int rpmR: 0
    property int dialNUmR: 0
    property int indicationID1: 0
    state: ""

    Item {
        id: rightItem
        x:0
        y:0
        visible: {
            console.log("d*****************")
            return true
        }

        Image {
            id: rightMeter
            x: 1200
            y: -20
            source: "qrc:/image1/image1/rightMeterG.png"
            DigitValue{
                id:speed1
                spacing: 2
                anchors.centerIn: rightMeter
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
                value: rightRoot.speedR
            }
            Image {
                id: waterT
                opacity: 1.0
                source: "qrc:/image1/image1/waterT.png"
            }

            Item {
                id: rightSpeedNum
                x: -1200
                y: 20
                Image {
                    id: speedNum0
                    x: 1411
                    y: 544
                    opacity: rightRoot.speedR<=30 ? 1.0 : 0.5
                    source: "qrc:/image1/image1/0.png"
                }
                Image {
                    id: speedNum30
                    x: 1322
                    y: 425
                    opacity: rightRoot.speedR<=60 ? 1.0 : 0.5
                    source: "qrc:/image1/image1/30.png"
                }
                Image {
                    id: speedNum60
                    x: 1323
                    y: 273
                    opacity: (rightRoot.speedR>=30 && rightRoot.speedR<=90) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/60.png"
                }
                Image {
                    id: speedNum90
                    x: 1394
                    y: 157
                    opacity: (rightRoot.speedR>=60 && rightRoot.speedR<=120) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/90.png"
                }
                Image {
                    id: speedNum120
                    x: 1532
                    y: 105
                    opacity: (rightRoot.speedR>=90 && rightRoot.speedR<=150) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/120.png"
                }
                Image {
                    id: speedNum150
                    x: 1671
                    y: 157
                    opacity: (rightRoot.speedR>=120 && rightRoot.speedR<=180) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/150.png"
                }
                Image {
                    id: speedNum180
                    x: 1739
                    y: 273
                    opacity: (rightRoot.speedR>=150 && rightRoot.speedR<=210) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/180.png"
                }
                Image {
                    id: speedNum210
                    x: 1740
                    y: 425
                    opacity: (rightRoot.speedR>=180 && rightRoot.speedR<=240) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/210.png"
                }
                Image {
                    id: speedNum240
                    x: 1666
                    y: 544
                    opacity: (rightRoot.speedR>=210 && rightRoot.speedR<=240) ? 1.0 : 0.5
                    source: "qrc:/image1/image1/240.png"
                }
            }

            Image {
                id: rightLight
                x: 1412 - 1200
                y: 65 + 20
                source: "qrc:/image1/image1/rightLight.png"
                transform: Rotation{
                    origin.x:1567.5 - 1412 ;origin.y :360.5 - 65
                    angle: rightRoot.speedR/30*36 - 144
                }
            }
            Image {
                id: rightLine
                x: 1559 - 1200
                y: 72 + 20
                source: "qrc:/image1/image1/rightLine.png"
                transform: Rotation{
                    origin.x:1567.5 - 1559 ;origin.y :360.5 - 72
                    angle: rightRoot.speedR/30*36 - 144
                }
            }

        }

        Image {
            id: right_km_h
            x: 1538 + 5
            y: 425
            source: "qrc:/image1/image1/kmh.png"
        }
    }


    Image {
        id: ring
        x: 1241
        y: 34
        scale: 1.0
        opacity: 0.0
        source: "qrc:/image1/image1/ringBg.png"
    }

//    Item {
//        id: bigDial
//        opacity: 0.0
//        Image {
//            id: p1
//            x: 826
//            y: 633
//            opacity:dialNUmR == 1 ? 1 : 0.2
//            source: "qrc:/image1/image1/P1.png"
//        }
//        Image {
//            id: r1
//            x: 868
//            y: 633
//            opacity: dialNUmR == 2 ? 1 : 0.2
//            source: "qrc:/image1/image1/R1.png"
//        }
//        Image {
//            id: n1
//            x: 912
//            y: 633
//            opacity: dialNUmR == 3 ? 1 : 0.2
//            source: "qrc:/image1/image1/N1.png"
//        }

//        Image {
//            id: d1
//            x: 959
//            y: 633
//            opacity: dialNUmR == 4 ? 1 : 0.2
//            source: "qrc:/image1/image1/D1.png"
//        }
//        Image {
//            id: s1
//            x: 1004
//            y: 633
//            opacity: dialNUmR == 5 ? 1 : 0.2
//            source: "qrc:/image1/image1/S1.png"
//        }
//    }


    Item{
        id:speedNum
        width: 1920
        height: 720
        opacity: 0.0
        DigitValue{
            id:speed2
            spacing: 3
            anchors.horizontalCenter: parent.horizontalCenter
            y: 350 - 20 -10
            z:5
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
            value: rightRoot.speedR
        }
        Image{
            id:signalInfo
            x: 791
            y: 160
            source: "qrc:/image1/image1/signalInfo.png"
        }
    }

    states: [
        State {
            name: ""
            PropertyChanges {
                target: rightItem
                x:0
                y:0
            }
        },
        State {
            name: "modle1"
            PropertyChanges {
                target: rightItem
                x:595 - 1200 + 4
            }
            PropertyChanges {
                target: ring
                scale:0.5
            }
        },
        State {
            name: "modle2"
            PropertyChanges {
                target: ring
                visible:false
            }
            PropertyChanges {
                target: rightItem
                x:40
                y:5
            }
        }
    ]
    transitions: [
        Transition {
            from: ""
            to: "modle1"
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {target: rightItem;property: "x"; duration: 1500}
                    NumberAnimation {target: rightSpeedNum;property: "opacity";to:0.0;duration: 1500}
                    NumberAnimation {target: ring;property: "x";to:657-20;duration: 0}
                }
                NumberAnimation {target: ring;property: "opacity";to:1.0;duration: 0}
                NumberAnimation {target: rightItem;property: "opacity";to:0.0; duration: 0}
                NumberAnimation {target: ring;property: "scale";duration: 1000}
                NumberAnimation {target: speedNum;property: "opacity";to:1.0;duration: 1500}

            }
        },
        Transition {
            from: "modle1"
            to: "modle2"
            SequentialAnimation{
                ParallelAnimation{
                    NumberAnimation {target: rightItem;property: "x"; to:40;duration: 1500}
                    NumberAnimation {target: rightItem;property: "y"; to:5 ;duration: 1500}
                    NumberAnimation {target: right_km_h;property: "y"; to:400;duration: 1500}
                    NumberAnimation {target: rightItem;property: "opacity"; to:1.0;duration: 100}
                    NumberAnimation {target: waterT;property: "opacity";to:0.0;duration: 1500}
                    NumberAnimation {target: rightMeter;property: "scale";to:0.83;duration: 1500}
                    NumberAnimation {target: speedNum;property: "opacity";to:0.0;duration: 100}
                }
            }
        },
        Transition {
            from: "modle2"
            to: ""
            SequentialAnimation{
                ParallelAnimation{
                     NumberAnimation {target: ring;property: "opacity";to:0;duration: 0}
                     NumberAnimation {target: rightSpeedNum;property: "opacity";to:1.0;duration: 1500}
                     NumberAnimation {target: rightMeter;property: "scale";to:1.0;duration: 1500}
                     NumberAnimation {target: right_km_h;property: "y"; to:420;duration: 1500}
                     NumberAnimation {target: waterT;property: "opacity";to:1.0;duration: 1500}
                }
            }
        },
        Transition {
            from: "modle1"
            to: ""
            SequentialAnimation{
                SequentialAnimation{
                    ParallelAnimation{
                        NumberAnimation {target: rightItem;property: "x"; to:40;duration: 150}
                        NumberAnimation {target: rightItem;property: "y"; to:5 ;duration: 150}
                        NumberAnimation {target: right_km_h;property: "y"; to:400;duration: 150}
                        NumberAnimation {target: rightItem;property: "opacity"; to:1.0;duration: 150}
                        NumberAnimation {target: waterT;property: "opacity";to:0.0;duration: 150}
                        NumberAnimation {target: rightMeter;property: "scale";to:0.83;duration: 150}
                        NumberAnimation {target: speedNum;property: "opacity";to:0.0;duration: 150}
                    }

                }

                ParallelAnimation{
                    NumberAnimation {target: rightItem;property: "x"; to:0;duration: 1500}
                    NumberAnimation {target: rightItem;property: "y"; to:0 ;duration: 1500}
                     NumberAnimation {target: ring;property: "opacity";to:0;duration: 0}
                     NumberAnimation {target: rightSpeedNum;property: "opacity";to:1.0;duration: 1500}
                     NumberAnimation {target: rightMeter;property: "scale";to:1.0;duration: 1500}
                     NumberAnimation {target: right_km_h;property: "y"; to:420;duration: 1500}
                     NumberAnimation {target: waterT;property: "opacity";to:1.0;duration: 1500}
                }
            }
        }
    ]
}

