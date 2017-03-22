import QtQuick 2.0

Item {
    id:root
    x:0
    property int speedC: 0
    property int rpmC: 0
    property int dialNUmC: 0
    property int indicationID: 0



    Image {
        id: driverInfoImage
        x: 727
        y: 215
        opacity: 1.0
        source: "qrc:/image/image/driverInfo.png"
    }

    Item{
        id:signalMeter
        opacity: 0.0
        Image {
            id: signal1
            x: 595
            y: -24
            source: "qrc:/image/image/signal.png"

        }
        Item {
            id: rpmNum
            Image {
                id: rpm0
                x: 804
                y: 538
                opacity: rpm<=1000 ? 1.0 : 0.5
                source: "qrc:/image/image/rpm0.png"
            }
            Image {
                id: rpm1
                x: 720
                y: 420
                opacity: rpm<=2000 ? 1.0 : 0.5
                source: "qrc:/image/image/rpm1.png"
            }
            Image {
                id: rpm2
                x: 719
                y: 267
                opacity: (rpm>=1000 && rpm <= 3000) ? 1.0 : 0.5
                source: "qrc:/image/image/rpm2.png"
            }
            Image {
                id: rpm3
                x: 803
                y: 151
                opacity: (rpm>=2000 && rpm <= 4000) ? 1.0 : 0.5
                source: "qrc:/image/image/rpm3.png"
            }
            Image {
                id: rpm4
                x: 946
                y: 99
                opacity: (rpm>=3000 && rpm <= 5000) ? 1.0 : 0.5
                source: "qrc:/image/image/rpm4.png"
            }
            Image {
                id: rpm5
                x: 1087
                y: 151
                opacity: (rpm>=4000 && rpm <= 6000) ? 1.0 : 0.5
                source: "qrc:/image/image/rpm5.png"
            }
            Image {
                id: rpm6
                x: 1175
                y: 267
                opacity: (rpm>=5000 && rpm <= 7000) ? 1.0 : 0.5
                source: "qrc:/image/image/rpm6.png"
            }
            Image {
                id: rpm7
                x: 1179
                y: 420
                opacity: (rpm>=6000 && rpm <= 8000) ? 1.0 : 0.5
                source: "qrc:/image/image/rpm7.png"
            }
            Image {
                id: rpm8
                x: 1096
                y: 538
                opacity: (rpm>=7000 && rpm <= 8000) ? 1.0 : 0.5
                source: "qrc:/image/image/rpm8.png"
            }
        }

        Image {
            id: lineLight
            x: 811
            y: 65
            source: "qrc:/image/image/lineLight.png"
            transform: Rotation {
                origin.x: 964.5 - 811; origin.y: 360 - 65;  angle: root.rpmC/1000*36-144 }
        }

        Image {
            id: line
            x: 956
            y: 72
            source: "qrc:/image/image/line.png"
            transform: Rotation {
                origin.x: 964.5 - 956; origin.y: 360 - 72;  angle: root.rpmC/1000*36-144 }
        }
        Image {
            id: smallRing
            x: 595
            y: -24
            source: "qrc:/image/image/smallRing.png"

        }


    }

    Item {
        id: dial
        opacity: 0.0
        Image {
            id: dialp
            x: 859
            y: 547
            opacity:dialNUmC == 1 ? 1 : 0.2
            source: "qrc:/image/image/p.png"
        }
        Image {
            id: dialr
            x: 891
            y: 547
            opacity:dialNUmC == 2 ? 1 : 0.2
            source: "qrc:/image/image/r.png"
        }
        Image {
            id: dialn
            x: 925
            y: 547
            opacity:dialNUmC == 3 ? 1 : 0.2
            source: "qrc:/image/image/N.png"
        }
        Image {
            id: diald
            x: 962
            y: 547
            opacity:dialNUmC == 4 ? 1 : 0.2
            source: "qrc:/image/image/D.png"
        }
        Image {
            id: dials
            x: 996
            y: 547
            opacity:dialNUmC == 5 ? 1 : 0.2
            source: "qrc:/image/image/S.png"
        }

    }

    Item {
        id: bigDial
        visible: true
        Image {
            id: p1
            x: 826
            y: 633
            opacity:dialNUmC == 1 ? 1 : 0.2
            source: "qrc:/image1/image1/P1.png"
        }
        Image {
            id: r1
            x: 868
            y: 633
            opacity: dialNUmC == 2 ? 1 : 0.2
            source: "qrc:/image1/image1/R1.png"
        }
        Image {
            id: n1
            x: 912
            y: 633
            opacity: dialNUmC == 3 ? 1 : 0.2
            source: "qrc:/image1/image1/N1.png"
        }

        Image {
            id: d1
            x: 959
            y: 633
            opacity: dialNUmC == 4 ? 1 : 0.2
            source: "qrc:/image1/image1/D1.png"
        }
        Image {
            id: s1
            x: 1004
            y: 633
            opacity: dialNUmC == 5 ? 1 : 0.2
            source: "qrc:/image1/image1/S1.png"
        }
    }


    states: [
        State {
            name: "modle1"
            PropertyChanges {
                target: driverInfoImage
                opacity:0.0
                x:727 + 620
            }
        },
        State {
            name: "modle2"
            PropertyChanges {
                target: driverInfoImage
                opacity:0.0
            }
        }
    ]

    transitions: [
        Transition {
            from:""
            to: "modle1"
            SequentialAnimation{
//                ScriptAction{script: {zhe.visible = false}}
                NumberAnimation {target: driverInfoImage;property: "opacity";duration: 100}
                ParallelAnimation{
                    NumberAnimation {target: driverInfoImage;property: "opacity";to:1.0;duration: 2000}
                    NumberAnimation {target: driverInfoImage;property: "x";duration: 2000}
                    NumberAnimation {target: bigDial;property: "opacity";to:0.0;duration: 1000}
                }
                PauseAnimation {
                    duration: 500
                }
                NumberAnimation {target: dial;property: "opacity";to:1.0;duration: 0}

            }
        },
        Transition {
            from:"modle1"
            to: "modle2"
            ParallelAnimation{
//                ScriptAction{script: {zhe.visible = true}}
//                  ScriptAction{script: {zhe.z = 1}}
                NumberAnimation {target: signalMeter;property: "opacity";to:0.0;duration: 500}
                NumberAnimation {target: dial;property: "opacity";to:0.0;duration: 500}
                NumberAnimation {target: bigDial;property: "opacity";to:1.0;duration: 500}
                NumberAnimation {target: driverInfoImage;property: "opacity";to:0.0;duration: 500}
            }
        },
        Transition {
            from:"modle2"
            to: ""
            ParallelAnimation{
//                ScriptAction{script: {zhe.visible = false}}
                NumberAnimation {target: bigDial;property: "opacity";to:1.0;duration: 500}
                NumberAnimation {target: driverInfoImage;property: "opacity";to:1.0;duration: 500}
            }
        }
    ]


    //    SequentialAnimation{
    //        running: true
    //        ParallelAnimation{
    //            SequentialAnimation{
    //                NumberAnimation { target: root;property: "rpm";to:8000;duration: 800;easing.type: Easing.InOutQuad }
    //                NumberAnimation { target: root;property: "rpm";to:0;duration: 800;easing.type: Easing.InOutQuad }
    //            }
    //            SequentialAnimation{
    //                NumberAnimation { target: root;property: "speed";to:240;duration: 800;easing.type: Easing.InOutQuad }
    //                NumberAnimation { target: root;property: "speed";to:0;duration: 800;easing.type: Easing.InOutQuad }
    //            }
    //        }
    //        ScriptAction{script: {root.dialNUm = 1 }}
    //        PauseAnimation{duration: 1500}
    //        NumberAnimation { target: root;property: "rpm"; to:850;duration: 1500;easing.type: Easing.InOutQuad }
    //        SequentialAnimation{
    //            loops: Animation.Infinite
    //            NumberAnimation { target: root;property: "rpm"; to:850;duration: 1500;easing.type: Easing.InOutQuad }
    //            ScriptAction{script: {root.dialNUm = 5 ;}}
    //            ParallelAnimation{
    //                NumberAnimation { target: root;property: "rpm";to:2000;duration: 2000;easing.type: Easing.InOutQuad }
    //                NumberAnimation { target: root;property: "speed";to:40;duration: 2000;easing.type: Easing.InOutQuad }
    //            }
    //            ParallelAnimation{
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:2500;duration: 1000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:2600;duration: 1000;easing.type: Easing.InOutQuad }
    //                }
    //                NumberAnimation { target: root;property: "speed";to:80;duration: 1000;easing.type: Easing.InOutQuad }
    //            }
    //            ParallelAnimation{
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:2700;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:2800;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //                NumberAnimation { target: root;property: "speed";to:120;duration: 2000;easing.type: Easing.InOutQuad }
    //            }
    //            ParallelAnimation{
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:2700;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:2900;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "speed";to:118;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "speed";to:128;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //            }
    //            ParallelAnimation{
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:2000;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:1600;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "speed";to:100;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "speed";to:80;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //            }
    //            ParallelAnimation{
    //                ScriptAction{script: {root.dialNUm = 3 }}
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:1000;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:850;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "speed";to:30;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "speed";to:0;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //            }
    //            ParallelAnimation{
    //                ScriptAction{script: {root.dialNUm = 5 }}
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:2600;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:2700;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "speed";to:40;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "speed";to:80;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //            }
    //            ParallelAnimation{
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:2600;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:2700;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "speed";to:116;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "speed";to:120;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //            }
    //            ParallelAnimation{
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:2200;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:1500;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "speed";to:100;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "speed";to:80;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //            }
    //            ParallelAnimation{
    //                ScriptAction{script: {root.dialNUm = 3; s1.opacity = 0.1; }}
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "rpm";to:1000;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "rpm";to:850;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //                SequentialAnimation{
    //                    NumberAnimation { target: root;property: "speed";to:30;duration: 2000;easing.type: Easing.InOutQuad }
    //                    NumberAnimation { target: root;property: "speed";to:0;duration: 2000;easing.type: Easing.InOutQuad }
    //                }
    //            }
    //        }
    //    }
}

