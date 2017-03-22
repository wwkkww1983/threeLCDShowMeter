#ifndef IMAGESTREAM_H_
#define IMAGESTREAM_H_
#define HOSTPORT 3333

#define CONNECT_HUD_SERVERS_ADDR "127.0.0.1"
#define CONNECT_HUD_SERVERS_PORT 4333

#define LINE_LENGTH 20 //语音提示文字信息单行的长度，超过此长度及换行

#include <QWidget>
#include <iostream>
#include <QtGui/QPalette>
#include <QtNetwork/QHostAddress>
#include <QtNetwork/QTcpSocket>
#include <QtNetwork/QTcpServer>
#include <QtNetwork>
#include <QUdpSocket>
#include <QHostInfo>
#include "screenimageprovider.h"
#include "changepics.h"
#include "changepicsmallturn.h"
#include "changepicsmallchannel.h"
#include "changepicsmallcross.h"
#include "changepicsmallcamera.h"
#include "changepicsmallother.h"
#include "changepicsmalllogo.h"
//#include"workmodel.h"
#include<QString>
#include <QQmlContext>
#include<QObject>
#include <QSemaphore>
#include<semaphore.h>

class ServerStream : public QWidget{
    Q_OBJECT
    Q_PROPERTY(QString strTurn MEMBER m_strTurn NOTIFY strTurnChanged)
    Q_PROPERTY(QString strVoice MEMBER m_strVoice NOTIFY strVoiceChanged)

    Q_PROPERTY(QString distanceTurn MEMBER m_distanceTurn NOTIFY distanceTurnChanged)
    Q_PROPERTY(QString roadTurn MEMBER m_roadTurn NOTIFY roadTurnChanged)
    Q_PROPERTY(QString distancDest MEMBER m_distancDest NOTIFY distancDestChanged)
    Q_PROPERTY(QString timeDest MEMBER m_timeDest NOTIFY timeDestChanged)
    Q_PROPERTY(int limitSpeed MEMBER m_limitSpeed NOTIFY limitSpeedChanged)
    Q_PROPERTY(bool navi_exit MEMBER m_navi_exit NOTIFY navi_exitChanged)


    Q_PROPERTY(int speed MEMBER m_speed NOTIFY speedChanged)
    Q_PROPERTY(int dial MEMBER m_dial NOTIFY dialChanged)
private:
    QTcpServer server;//for socketData
    QTcpServer serverCTL; //for socketCtrl
    QTcpServer serverSmall; //for socketDataSmall
    QTcpSocket *socketData, *socketCtrl, *socketDataSmall;  //for map pictures,for control information and words,for small pics
    QByteArray imageData;   //storage data for map pics
    QByteArray imageDataSmallPic;//storage data for small pics
    QByteArray imageDataSmallWord;//storage data for words and control information

    QByteArray imageDataSmallTmp;
    QByteArray imageDataPicTmp;
    QByteArray imageDataMapTmp;

    QByteArray imageDataSmallAll;
    QByteArray imageDataPicAll;
    QByteArray imageDataMapAll;

    QTcpSocket *client_hud;            // socket对象
    QTcpSocket *client_hudCTL;            // socket对象
    QTcpSocket *client_hudSmall;            // socket对象

    bool connHUDSuccessFlag;
    bool connHUDCTLSuccessFlag;
    bool connHUDSmallSuccessFlag;

    bool readAllFlag;   //readAllFlag为false时，从头开始接收一幅新的图片，为true时，继续接收上一幅图片的数据。
    bool readAllFlagSmallPic;
    bool readAllFlagSmallWord;
    bool flagLogo;//当语音logo出现时，该标志位置为false

    QByteArray datagram; //datagram to broadcast by instrument
    QUdpSocket *socketBroadCast;
    void initNetWork(); //初始化网络
    void getLocalInfo(); //获取本机IP
    bool netWorkStatusFlag;
    int mapPicLeft;//一张图片的长度(即字节数)
    int smallPicLeft;
    int smallPicLeft_back;
    int wordLeft;
    int wordLeft_back;

    int timer_3s;

    int infoTypePic;
    int infoTypeWord;
    int infoModelPic;
    int infoModelWord;
    int readLen;//实际读取到的字节的长度
    /*to display pics on QML*/
    ChangePics *chg;
    ChangePicsSmallTurn *chgSmallTurn;//转向
    ChangePicsSmallChannel *chgSmallChannel;//车道
    ChangePicsSmallCross *chgSmallCross;//路口放大图
    ChangePicsSmallCamera *chgSmallCamera;//摄像头
    ChangePicsSmallLogo *chgSmallLogo;//Sogou Logo
    ChangePicsSmallOther *chgSmallOther;

    int connectNum;//num of connect request
//    QString m_str;//words for distance info
    QString m_strTurn;
    QString m_strVoice;


    QString m_distanceTurn;
    QString m_roadTurn;
    QString m_distancDest;
    QString m_timeDest;
    int m_limitSpeed;
    bool m_navi_exit;

    int speedNum;
    int m_speed;
    int dialNum;
    int  m_dial;
    bool speed_flag;

//    sem_t semNetSend;
    QSemaphore semNetSend;
    QByteArray imageLogoAutorock;
    int lenImageLogoAutorock;

public:

    ServerStream(QWidget *qw=0);
    ~ServerStream();
    ScreenImageProvider *imgProvider;
    ScreenImageProvider *imgProviderSimpleTurn;
    ScreenImageProvider *imgProviderSimpleChannel;
    ScreenImageProvider *imgProviderSimpleCross;
    ScreenImageProvider *imgProviderSimpleCamera;
    ScreenImageProvider *imgProviderSimpleLogo;
    ScreenImageProvider *imgProviderSimpleOther;

    void sendBuf(QTcpSocket *sockfd, QByteArray buf, int lenBuf, int flag1, int flag2);
    void SendNaviInfo(QTcpSocket *sockfd, int InfoType, QByteArray InfoBuffer, int lenBuf);
    void sendCtrlInfo(int type, /*const char **/QString data);

    Q_INVOKABLE void setCtrlResolution(/*const char **/QString data);

signals:
    void callQmlRefeshImg();//通知QML刷新显示界面
    void callQmlRefeshImgSmallTurn();
    void callQmlRefeshImgSmallChannel();
    void callQmlRefeshImgSmallCross();
    void callQmlRefeshImgSmallCamera();
    void callQmlRefeshImgSmallLogo();
    void callQmlRefeshImgSmallOther();
    void strTurnChanged();
    void strVoiceChanged();

    void distanceTurnChanged();
    void roadTurnChanged();
    void distancDestChanged();
    void timeDestChanged();
    void limitSpeedChanged();
    void navi_exitChanged();

    void speedChanged();
    void dialChanged();

public slots:
    void  timer1s();
    void  changeDial();

    void getSocketImage();  //获取从服务器端传来的图片数据
    void getSimpleInfoPic();//get and display  small pics from client
    void getSimpleInfoWord();//get and display words(indicator information) from client
    void proEstablished();//连接建立之后调用的方法
    void proConnectRequest();//处理连接请求
    void proConnectRequestCTL();
    void proConnectRequestSmall();
    void broadcastLocalInfo(); //广播本机IP及端口号
    void emitRefresh();//更新图片,normal
    void emitRefreshSmallTurn();//small pics
    void emitRefreshSmallChannel();
    void emitRefreshSmallCross();
    void emitRefreshSmallCamera();
    void emitRefreshSmallLogo();
    void emitRefreshSmallOther();
    void proDisconnected();//when client disconnected,allow a new connect request


    void connHUDSuccess();
    void connHUDCTLSuccess();
    void connHUDSmallSuccess();
};

#endif

