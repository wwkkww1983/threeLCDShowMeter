TEMPLATE = app

QT +=qml quick serialport network widgets gui core
CONFIG += c++11

SOURCES += main.cpp \
    carstatus.cpp \
    protocol.cpp \
    serial.cpp \
    ServerStream.cpp

RESOURCES += qml.qrc

QML_FOLDER = qml
OTHER_FILES += \
    $$QML_FOLDER/*.qml

HEADER_FOLDER = include
INCLUDEPATH += $$HEADER_FOLDER
HEADERS += $$HEADER_FOLDER/ServerStream.h \
    $$HEADER_FOLDER/screenimageprovider.h \
    $$HEADER_FOLDER/changepics.h \
    $$HEADER_FOLDER/workmodel.h \
    $$HEADER_FOLDER/changepicsmallchannel.h \
    $$HEADER_FOLDER/changepicsmallturn.h \
    $$HEADER_FOLDER/changepicsmallcross.h \
    $$HEADER_FOLDER/changepicsmallcamera.h \
    $$HEADER_FOLDER/changepicsmallother.h \
    $$HEADER_FOLDER/changepicsmalllogo.h \
    include/fontName.h \
    include/protocol.h
# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES += \
    qml/infoPanel.qml \
    qml/leftPanelTest.qml \
    qml/CenterPanel.qml \
    qml/RightPanel.qml \
    qml/LeftPanel.qml

