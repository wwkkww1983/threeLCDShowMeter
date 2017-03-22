import QtQuick 2.0
import QtQuick 2.3
import QtQuick.Window 2.1

Window{
    visible: true
    width: 1920
    height: 720
    color: "black"

    Item {
        Component{
            id:mapCom
            Image {
                id: mapS
                x: -237
                y: 18
                source: "qrc:/image/image/mapS.png"
            }
        }
        Component{
            id:leftCom
            Item {
                id: leftItem
                Image {
                    id: leftMeter
                    x: -237
                    y: -20
                    source: "qrc:/image1/image1/leftMeter.png"

                }
                Item {
                    id: leftRpm
                    Image {
                        id: leftRpm0
                        x: 195
                        y: 538
                        source: "qrc:/image1/image1/leftRpm0.png"
                    }
                    Image {
                        id: leftRpm1
                        x: 111
                        y: 420
                        source: "qrc:/image1/image1/leftRpm1.png"
                    }
                    Image {
                        id: leftRpm2
                        x: 110
                        y: 267
                        source: "qrc:/image1/image1/leftRpm2.png"
                    }
                    Image {
                        id: leftRpm3
                        x: 194
                        y: 151
                        source: "qrc:/image1/image1/leftRpm3.png"
                    }
                    Image {
                        id: leftRpm4
                        x: 338
                        y: 99
                        source: "qrc:/image1/image1/leftRpm4.png"
                    }
                    Image {
                        id: leftRpm5
                        x: 478
                        y: 151
                        source: "qrc:/image1/image1/leftRpm5.png"
                    }
                    Image {
                        id: leftRpm6
                        x: 566
                        y: 267
                        source: "qrc:/image1/image1/leftRpm6.png"
                    }
                    Image {
                        id: leftRpm7
                        x: 570
                        y: 420
                        source: "qrc:/image1/image1/leftRpm7.png"
                    }
                    Image {
                        id: leftRpm8
                        x: 487
                        y: 538
                        source: "qrc:/image1/image1/leftRpm8.png"
                    }
                }
                Image {
                    id: leftLineLight
                    x: 202
                    y: 65
                    source: "qrc:/image1/image1/leftLineLight.png"
                    transform: Rotation{
                        origin.x:222 ; origin.y:222
                        angle: 30
                    }
                }
                Image {
                    id: leftLine
                    x: 347
                    y: 72
                    source: "qrc:/image1/image1/leftLine.png"
                    transform: Rotation{
                        origin.x:222 -347 ; origin.y:222
                        angle: 30
                    }
                }
            }
        }

        Loader{
            active: false
            sourceComponent: mapCom
        }
        Loader{
            active: true
            sourceComponent: leftCom
        }

        Loader{
            id:mainView
            active: true
            source: "qrc:/qml/qml/main.qml"
        }
    }
}

