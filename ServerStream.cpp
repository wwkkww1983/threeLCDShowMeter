#include "ServerStream.h"
#include <QTcpSocket>
#include <QUdpSocket>
#include <QtCore/QFile>
#include <QtCore/QByteArray>
#include <QTimer>
#include <QNetworkInterface>
#include <workmodel.h>
//#include "word.h"
//#include "sendwords.h"
#include <iostream>
#include <fstream>

char * buffer;
using namespace std;
ServerStream::ServerStream(QWidget *qw) : QWidget(qw)
{
    readAllFlag = false;
    readAllFlagSmallPic = false;
    readAllFlagSmallWord = false;
    readLen = 0;
    mapPicLeft = 0;
    smallPicLeft = 0;
    wordLeft = 0;
    infoModelPic = 0;
    infoModelWord = 0;
    flagLogo = true;
    netWorkStatusFlag = false;

//    FILE *imageBgFp;
//    imageBgFp =fopen("S1.png" , "rb");
    QFile imageBgFp("/home/ymk/桌面/showMeter/autorock_logo.png");
//    QFile imageBgFp("/usr/navi_map/autorock_logo.png");
    if(!imageBgFp.open(QIODevice::ReadOnly))
    {
        cout << "Open failed." << endl;
        return ;
    }

    imageLogoAutorock = imageBgFp.readAll();
    lenImageLogoAutorock =  imageBgFp.size();

    imageBgFp.close();

    qDebug()<<"imageLogoAutorock len:"<<lenImageLogoAutorock;

    speedNum = 0;
    timer_3s = 0;
    m_dial = 1;
    emit changeDial();
    m_limitSpeed = 0;
    emit limitSpeedChanged();
    m_navi_exit = false;
    emit navi_exitChanged();
    getLocalInfo();
    initNetWork();

    chg = new ChangePics();
    connect(chg,SIGNAL(refeshImg()),this,SLOT(emitRefresh()));

    chgSmallTurn = new ChangePicsSmallTurn();
    connect(chgSmallTurn, SIGNAL(refeshImgSmallTurn()), this, SLOT(emitRefreshSmallTurn()));

    chgSmallChannel = new ChangePicsSmallChannel();
    connect(chgSmallChannel, SIGNAL(refeshImgSmallChannel()), this, SLOT(emitRefreshSmallChannel()));

    chgSmallCross = new ChangePicsSmallCross();
    connect(chgSmallCross, SIGNAL(refeshImgSmallCross()), this, SLOT(emitRefreshSmallCross()));

    chgSmallCamera = new ChangePicsSmallCamera();
    connect(chgSmallCamera, SIGNAL(refeshImgSmallCamera()), this, SLOT(emitRefreshSmallCamera()));

    chgSmallLogo = new ChangePicsSmallLogo();
    connect(chgSmallLogo, SIGNAL(refeshImgSmallLogo()), this, SLOT(emitRefreshSmallLogo()));

    chgSmallOther = new ChangePicsSmallOther();
    connect(chgSmallOther, SIGNAL(refeshImgSmallOther()), this, SLOT(emitRefreshSmallOther()));

    imgProvider = new ScreenImageProvider;
    imgProviderSimpleTurn = new ScreenImageProvider;
    imgProviderSimpleChannel = new ScreenImageProvider;
    imgProviderSimpleCross = new ScreenImageProvider;
    imgProviderSimpleLogo = new ScreenImageProvider;
    imgProviderSimpleCamera = new ScreenImageProvider;

    chg->wait();
    chgSmallTurn->wait();
    chgSmallChannel->wait();
    chgSmallCross->wait();
    chgSmallCamera->wait();
    chgSmallOther->wait();

    QTimer *speed_timer = new QTimer;
    speed_timer->start(1000);
    connect(speed_timer,SIGNAL(timeout()),this,SLOT(timer1s()));
    speed_flag = false;

    semNetSend.release();
}


void ServerStream::timer1s()
{
    getLocalInfo();

    QByteArray hud_info_tmp;
    int hud_info_tmp_len = 0;

    timer_3s++;
    if(timer_3s % 4 == 0)
    {
        m_dial ++;
        if(m_dial >5)
            m_dial = 1;
        emit dialChanged();
        QString strd;
        strd = QString::number(m_dial);
        hud_info_tmp = strd.toLatin1();
        hud_info_tmp_len = strd.length();
        SendNaviInfo(client_hudCTL, DIAL_ID, hud_info_tmp, hud_info_tmp_len);
    }

    if(speedNum == 120)
    {
        speed_flag = true;
    }
    if(speedNum == 0)
    {
        speed_flag = false;
    }
    if(speed_flag ==false)
    {
        speedNum++;
        m_speed = speedNum;
    }
    else {
        speedNum--;
        m_speed = speedNum;
    }
    emit speedChanged();
    QString str;
    str = QString::number(speedNum);
    hud_info_tmp = str.toLatin1();
    emit speedChanged();
    //qDebug()<<"*********speedChanged*****"<<speedNum;
    hud_info_tmp_len = str.length();

    SendNaviInfo(client_hudCTL, SPEED_ID, hud_info_tmp, hud_info_tmp_len);
}

void ServerStream::changeDial()
{
    dialNum++;
    m_dial = dialNum;
    emit dialChanged();
}

ServerStream::~ServerStream(){

}

void ServerStream::SendNaviInfo(QTcpSocket *sockfd, int InfoType, QByteArray InfoBuffer, int lenBuf)
{
    semNetSend.acquire();
    sendBuf(sockfd, InfoBuffer, lenBuf, 0, InfoType);
//    qDebug() << "SendNaviInfo:" <<InfoBuffer;
    semNetSend.release();
}

void ServerStream::sendBuf(QTcpSocket *sockfd, QByteArray buf, int lenBuf, int flag1, int flag2)
{
     if( !(connHUDSuccessFlag && connHUDCTLSuccessFlag && connHUDSmallSuccessFlag) )
         return;

    int len = 4 + 4 + lenBuf;
    QString ctrlInfoSimple = QString("autorock-head") + QString::number(len).sprintf("%08x",len)
            +  QString::number(flag1).sprintf("%04x",flag1) +  QString::number(flag2).sprintf("%04x",flag2) ; //resolution
//    qDebug() << "buf:" <<buf;
    sockfd->write(ctrlInfoSimple.toLatin1());
    sockfd->write(buf);
    sockfd->flush();
    qDebug() << "send a message by socketCtrl:" << ctrlInfoSimple ;
}

/*从socket获取图片的数据：
1.首先判断标志位readAllFlag：true:表示上一张图片还没有读完整，接着上次的读,即执行步骤4.
false:上一张图片已经读取完整，开始读下一张图片，执行步骤2,3。
2.首先读取数据的前13个字节，并比较标志位是否正确，如果标志位正确，则继续往下执行；
3.读取后面的8个字节，转换成int型的数，即获取图片的大小mapPicLeft；
4.读取有效数据，首先读取mapPicLeft个字节，并重新计算mapPicLeft。如果mapPicLeft=0，
则该张图片接收完毕，调用显示函数。如果mapPicLeft != 0，则下次调用该函数时继续接收该张图片的数据。*/
void ServerStream::getSocketImage() //map pics
{
    imageDataMapTmp.clear();
    imageDataMapTmp = socketData->readAll();
    imageDataMapAll.append(imageDataMapTmp);
    if(imageDataMapAll.length() > 0) {
        while(imageDataMapAll.length() > 0) {
            if(!readAllFlag){
                imageData.clear();
                QString dataHead = imageDataMapAll.left(13);
                imageDataMapAll.remove(0, 13);
                if("autorock-head" == dataHead) {
                    QString dataSize = imageDataMapAll.left(8);
                    imageDataMapAll.remove(0, 8);
                    bool ok;
                    mapPicLeft = dataSize.toInt(&ok,16);
                    readAllFlag = true;
                }
            } else {
                QByteArray dataTemp;
                dataTemp.clear();
                dataTemp = imageDataMapAll.left(mapPicLeft);
                imageDataMapAll.remove(0, mapPicLeft);
                imageData.append(dataTemp);
                mapPicLeft = mapPicLeft - dataTemp.length();
                //                if((0 == mapPicLeft) && flagLogo) {
                //                    chg->run(imageData,imgProvider);//启动线程，显示图片
                //                    readAllFlag = false;
                //                }
                if(0 == mapPicLeft) {
                    //                     qDebug() << "*******  map  **********" ;
                    if(flagLogo) {
                        chg->run(imageData,imgProvider);//启动线程，显示图片
                        readAllFlag = false;
                    } else {
                        imageDataMapTmp.clear();
                        imageDataMapAll.clear();
                    }
                }
            }
        }
        imageDataMapAll.clear();
    }
}
/*接收小图标，转向，车道，路口的图片。*/
void ServerStream::getSimpleInfoPic() //small pics
{
    imageDataPicTmp.clear();
    imageDataPicTmp = socketDataSmall->readAll();
    //client_hudSmall->write(imageDataPicTmp);
    //client_hudSmall->flush();
    imageDataPicAll.append(imageDataPicTmp);
    if(imageDataPicAll.length() > 0) {
        while(imageDataPicAll.length() > 0) {
            if(!readAllFlagSmallPic){
                imageDataSmallPic.clear();
                QString dataHead = imageDataPicAll.left(13);
                imageDataPicAll.remove(0, 13);
                if("autorock-head" == dataHead) {
                    QString dataLen = imageDataPicAll.left(8);
                    imageDataPicAll.remove(0, 8);
                    bool ok;
                    smallPicLeft = dataLen.toInt(&ok, 16) - 8;
                    smallPicLeft_back = smallPicLeft;
                    dataLen.clear();
                    dataLen = imageDataPicAll.left(4);
                    imageDataPicAll.remove(0, 4);
                    infoTypePic = dataLen.toInt(&ok, 16);
                    dataLen.clear();
                    dataLen = imageDataPicAll.left(4);
                    imageDataPicAll.remove(0, 4);
                    infoModelPic = dataLen.toInt(&ok, 16);
                    qDebug() << "******* infoModelPic=  **********" << infoModelPic;
                    readAllFlagSmallPic = true;
                }
            } else {
                QByteArray dataTemp;
                dataTemp.clear();
                dataTemp = imageDataPicAll.left(smallPicLeft);
                imageDataPicAll.remove(0, smallPicLeft);
                //                std::cout << "dataTempreadLen=" << dataTemp.length() << std::endl << std::endl;
                imageDataSmallPic.append(dataTemp);
                QString temp1 = imageDataSmallPic;
                qDebug() << temp1;
                smallPicLeft = smallPicLeft - dataTemp.length();
                if(0 == smallPicLeft) {
                    qDebug() << "***** infoModelPic  *****" << infoModelPic ;
//     SendNaviInfo() ------------infoModelPic
                    if(NAVI_ROAD == infoModelPic && imageDataSmallPic == "NULL")
                        SendNaviInfo(client_hudSmall, infoModelPic, imageLogoAutorock, lenImageLogoAutorock);
                    else
                        SendNaviInfo(client_hudSmall, infoModelPic, imageDataSmallPic, smallPicLeft_back);

                    if((infoModelPic <= DIR_MAX) && flagLogo) { //28
                        qDebug() << "******* turn pic appear  **********";
                        chgSmallTurn->run(imageDataSmallPic, imgProviderSimpleTurn);
                    } else if ((infoModelPic <= ROAD_MAX) && flagLogo) { //29
                        chgSmallChannel->run(imageDataSmallPic, imgProviderSimpleChannel);
                    } else if ((infoModelPic <= CROSS_MAX) && flagLogo) { //30
                        chgSmallCross->run(imageDataSmallPic, imgProviderSimpleCross);
                    } else if ((infoModelPic <= CAMERA_MAX) && flagLogo) { //31
                        chgSmallCamera->run(imageDataSmallPic, imgProviderSimpleCamera);
                    } else if(LOGO == infoModelPic) { //32
                        chgSmallLogo->run(imageDataSmallPic, imgProviderSimpleLogo);
                        if(imageDataSmallPic != "NULL") { //当logo出现时
                            flagLogo = false;
                            imageData = NULL;
                            chg->run(imageData,imgProvider); //让底图消失
                            m_strTurn = " ";
                            emit strTurnChanged(); //让距离提示文字消失
                            //                            imageDataSmallPic = NULL;
                            imageDataSmallPic = "";
                            chgSmallChannel->run(imageDataSmallPic, imgProviderSimpleChannel);//让车道图标消失
                            chgSmallTurn->run(imageDataSmallPic, imgProviderSimpleTurn);//让转向图标消失
                            //                            imageDataPicTmp.clear();//清空残留的数据
                            //                            imageDataPicAll.clear();
                        } else if (imageDataSmallPic == "NULL") { //当logo消失之后
                            flagLogo = true;
                        }
                    } else if (TYPE_OTHER == infoModelPic) { //33
                          chgSmallOther->run(imageDataSmallPic, imgProviderSimpleOther);
                    }else if (infoModelWord == NAVI_EXIT) {
                        m_navi_exit = true;
                        qDebug() << "@@@@@@@@@@@@@NAVI_EXIT99999@@@@@@@@@@@@@" ;
                        emit navi_exitChanged();
                    }
                    readAllFlagSmallPic = false;
                }
            }
        }
        imageDataPicAll.clear();
    }
}
/*改进及说明，2017.2.17
要解决的问题：当语音提示logo出现时，让底图，车道图和转向提示文字消失。
遇到的问题：logo出现时，底图有时候可以消失，有时候消失之后，很快又会被一张底图覆盖。
可能的原因：logo消失之后，imageDataPicTmp里面还有残留的数据，所以，增加一个标志位，
当logo出现之后，flagLogo＝false，如果有数据要处理，先判断一下flagLogo的值，不满足条件，不再显示相应的信息，并把
imageDataPicTmp里面的数据舍弃。
当logo消失之后，flagLogo＝true，即可正常的显示所有的信息。*/

/*接收并解析转向提示信息和语音交互信息*/
void ServerStream::getSimpleInfoWord() //word(indicator information)
{
    /*过程中遇到的问题：文字提示信息显示不及时。
        在此处并没有及时的显示，缓冲了一下，文字提示信息的及时性有所提高.*/
    imageDataSmallTmp.clear();
    imageDataSmallTmp = socketCtrl->readAll();
    imageDataSmallAll.append(imageDataSmallTmp);
    if(imageDataSmallAll.length() > 0) {
        while(imageDataSmallAll.length() > 0) {
            if(!readAllFlagSmallWord){
                imageDataSmallWord.clear();
                QString dataHead = imageDataSmallAll.left(13);
                imageDataSmallAll.remove(0, 13);
                if("autorock-head" == dataHead) {
                    QString dataLen = imageDataSmallAll.left(8);
                    imageDataSmallAll.remove(0, 8);
                    bool ok;
                    wordLeft = dataLen.toInt(&ok, 16) - 8;
                    wordLeft_back = wordLeft;
                    dataLen.clear();
                    dataLen = imageDataSmallAll.left(4);
                    imageDataSmallAll.remove(0, 4);
                    infoTypeWord = dataLen.toInt(&ok, 16);
                    dataLen.clear();
                    dataLen = imageDataSmallAll.left(4);
                    imageDataSmallAll.remove(0, 4);
                    infoModelWord = dataLen.toInt(&ok, 16);
                    readAllFlagSmallWord = true;
                }
            } else {
                QByteArray dataTemp;
                dataTemp.clear();
                dataTemp = imageDataSmallAll.left(wordLeft);
                imageDataSmallAll.remove(0, wordLeft);
                imageDataSmallWord.append(dataTemp);
                wordLeft = wordLeft - dataTemp.length();
                if (0 == wordLeft) {
//--------------infoModelWord
                    SendNaviInfo(client_hudCTL, infoModelWord, imageDataSmallWord, wordLeft_back);

                    QString s = imageDataSmallWord;
                    if (infoModelWord == NAVI_WORD_VOICE) {
                        if(s == "NULL") {
                            s = " ";
                        }
                        //                        m_strVoice = s;
                        //                        QString m_strVoiceTemp;
                        qDebug() << "m_strVoice***********"  << m_strVoice;

                        if (s.length() > LINE_LENGTH) {
                            while (s.length() > LINE_LENGTH) {
                                m_strVoice = s.left(LINE_LENGTH);
                                s.remove(0,LINE_LENGTH);
                                m_strVoice.append('\n');
                                m_strVoice.append(s.left(LINE_LENGTH));
                            }
                        } else {
                            m_strVoice = s;
                        }
                        SendNaviInfo(client_hudCTL, infoModelWord, imageDataSmallWord, wordLeft_back);
                        emit strVoiceChanged();
                    }else if (infoModelWord == NAVI_WORD_DISTANCE_TURN) {
                        m_distanceTurn = s;
                       qDebug() << "NAVI_WORD_DISTANCE_TURN***********"  << s;
                       emit distanceTurnChanged();
                    }else if (infoModelWord == NAVI_WORD_ROAD_TURN) {
                        m_roadTurn = s;
                        qDebug() << "NAVI_WORD_ROAD_TURN***********"  << s;
                        emit roadTurnChanged();
                     }else if (infoModelWord == NAVI_WORD_DISTANCE_DEST) {
                        m_distancDest = s;
                        qDebug() << "NAVI_WORD_DISTANCE_DEST***********"  << s;
                        emit distancDestChanged();
                     }else if (infoModelWord == NAVI_WORD_TIME_DEST) {
                        m_timeDest = s ;
                        qDebug() << "NAVI_WORD_TIME_DEST***********"  << s;
                        emit timeDestChanged();
                     }else if (infoModelWord == NAVI_SPEED_LIMITE) {
                        qDebug() << "******************NAVI_SPEED_LIMITE***********"  << s;
                        m_limitSpeed = s.toInt();
//                        SendNaviInfo(client_hudCTL, infoModelWord, imageDataSmallWord, wordLeft_back);
                        emit limitSpeedChanged();
                     } else if (infoModelWord == NAVI_EXIT) {

                        qDebug() << "@@@@@@@@@@@@@NAVI_EXIT@@@@@@@@@@@@@"  << s;
                        m_navi_exit = true;
                        emit navi_exitChanged();
                    }
                    else {
                        m_strTurn = s;
                        qDebug() << "m_strTurn***********"  << m_strTurn;
//                        SendNaviInfo(client_hudCTL, infoModelWord, imageDataSmallWord, wordLeft_back);
                        //SendNaviInfo(infoModelPic, m_strTurn);
                        emit strTurnChanged();
                    }
                    readAllFlagSmallWord = false;
                }
            }
        }
        imageDataSmallAll.clear();
    }
}


//处理连接请求，获取一个连接，其功能类似于accept()函数。
void ServerStream::proConnectRequest()
{
    std::cout << "a new connect request for socketData......" << std::endl;
    readAllFlag = false;
    socketData = server.nextPendingConnection();//socket for data
    connect(socketData,SIGNAL(readyRead()),this,SLOT(getSocketImage()));
}

void ServerStream::proConnectRequestCTL()
{
    std::cout << "a new connect request for socketCtrl......" << std::endl;
    readAllFlagSmallWord = false;
    socketCtrl = serverCTL.nextPendingConnection();//socket for control signal
    connect(socketCtrl, SIGNAL(readyRead()), this, SLOT(getSimpleInfoWord()));
//    setCtrlResolution( "960*663" );
}

void ServerStream::proConnectRequestSmall()
{
    std::cout << "a new connect request for socketDataSmall......" << std::endl;
    readAllFlagSmallPic = false;
    socketDataSmall = serverSmall.nextPendingConnection();//socket for control signal
    std::cout << "socketDataSmall established" << std::endl;
    m_navi_exit = false;
    emit navi_exitChanged();
    connect(socketDataSmall, SIGNAL(readyRead()), this, SLOT(getSimpleInfoPic()));
}

//广播本地IP及端口号
void ServerStream::broadcastLocalInfo()
{
     if( ! netWorkStatusFlag )
         return;
    socketBroadCast->writeDatagram(datagram.data(),datagram.size(),QHostAddress::Broadcast,HOSTPORT);
    qDebug() << " bytes data have been broadcasted:" << datagram.data();
}

void ServerStream::emitRefresh()
{
    emit callQmlRefeshImg();
}

void ServerStream::emitRefreshSmallTurn()
{
    emit callQmlRefeshImgSmallTurn();
}

void ServerStream::emitRefreshSmallChannel()
{
    emit callQmlRefeshImgSmallChannel();
}

void ServerStream::emitRefreshSmallCross()
{
    emit callQmlRefeshImgSmallCross();
}

void ServerStream::emitRefreshSmallCamera()
{
    emit callQmlRefeshImgSmallCamera();
}

void ServerStream::emitRefreshSmallOther()
{
    emit callQmlRefeshImgSmallOther();
}

void ServerStream::emitRefreshSmallLogo()
{
    emit callQmlRefeshImgSmallLogo();
}

void ServerStream::proEstablished()
{
    std::cout << "********** connect established! **************" << std::endl;
}

//初始化网络:相当于c语言中的 socket，bind，listen，并绑定相关的信号和槽函数
void ServerStream::initNetWork(){
    std::cout << "flagLogo=" << flagLogo << std::endl;
    std::cout << "initing network" << std::endl;
    socketData = new QTcpSocket(this);
    socketCtrl = new QTcpSocket(this);
    socketDataSmall = new QTcpSocket(this);

    server.setParent(this);
    server.listen(QHostAddress::Any,HOSTPORT);
    serverCTL.setParent(this);
    serverCTL.listen(QHostAddress::Any,HOSTPORT+1);
    serverSmall.setParent(this);
    serverSmall.listen(QHostAddress::Any,HOSTPORT+2);

    //connect(socketData,SIGNAL(connected()),this,SLOT(proEstablished()));
    connect(&server,SIGNAL(newConnection()),this,SLOT(proConnectRequest()));
    connect(&serverCTL,SIGNAL(newConnection()),this,SLOT(proConnectRequestCTL()));
    connect(&serverSmall,SIGNAL(newConnection()),this,SLOT(proConnectRequestSmall()));
    //    connect(socketData,SIGNAL(disconnected()),this,SLOT(proDisconnected()));
    std::cout << "network inited!" << std::endl;
    socketData->setReadBufferSize(1024*1024);//设置接收端缓冲区大小
    socketCtrl->setReadBufferSize(1024);
    socketDataSmall->setReadBufferSize(1024);
    qDebug() << "the size of socketDataSmall readBuffer is " << socketDataSmall->readBufferSize();

//HUD    client_hud
        client_hud = new QTcpSocket();
        client_hud->setParent(this);
        client_hud->connectToHost(CONNECT_HUD_SERVERS_ADDR, CONNECT_HUD_SERVERS_PORT);    // local
        connect(client_hud, SIGNAL(connected()), this, SLOT(connHUDSuccess()));
        //connect(client_hud, SIGNAL(disconnected()), this, SLOT(disConnected()));

        client_hudCTL = new QTcpSocket();
        client_hudCTL->setParent(this);
        client_hudCTL->connectToHost(CONNECT_HUD_SERVERS_ADDR, CONNECT_HUD_SERVERS_PORT+1);    // local
        connect(client_hudCTL, SIGNAL(connected()), this, SLOT(connHUDCTLSuccess()));

        client_hudSmall = new QTcpSocket();
        client_hudSmall->setParent(this);
        client_hudSmall->connectToHost(CONNECT_HUD_SERVERS_ADDR, CONNECT_HUD_SERVERS_PORT+2);    // local
        connect(client_hudSmall, SIGNAL(connected()), this, SLOT(connHUDSmallSuccess()));

        QTimer *timerBroadcast = new QTimer(this);
        connect(timerBroadcast,SIGNAL(timeout()),this,SLOT(broadcastLocalInfo()) );
        timerBroadcast->start(2000);//每隔2秒广播一次
        qDebug() << "************timeBroadcast ************";
}

/*获取本机IP，封装需要广播的数据报。
   绑定定时器和广播，每隔2秒广播一次。*/
void ServerStream::getLocalInfo()
{
#if 0
    if( netWorkStatusFlag || QNetworkInterface::allAddresses().at(2).isNull() )
        return;

    QString hostName = QHostInfo::localHostName();
    qDebug() << "hostName:" << hostName;

    QString hostIP = QNetworkInterface::allAddresses().at(2).toString();//共有四个IP，第三个是我们需要的
    qDebug() << "hostIP:" << hostIP;
    socketBroadCast = new QUdpSocket(this);
    QString datagramStr = QString("autorock-alive") + ":" + hostIP + ":" +QString::number(HOSTPORT);
    datagram = datagramStr.toLatin1();//类型要正确，类型，类型，类型！

    netWorkStatusFlag = true;

#else
    if( netWorkStatusFlag )
        return;

    QList<QNetworkInterface> list = QNetworkInterface::allInterfaces();
    foreach (QNetworkInterface netInterface, list)
    {
        if (!netInterface.isValid())
            continue;

        qDebug() << "********************";

        QNetworkInterface::InterfaceFlags flags = netInterface.flags();
        if (flags.testFlag(QNetworkInterface::IsRunning)
                    && !flags.testFlag(QNetworkInterface::IsLoopBack))
        {  // 网络接口处于活动状态
            //qDebug() << "Device : " << netInterface.name();  // 设备名
            //qDebug() << "HardwareAddress : " << netInterface.hardwareAddress();  // 硬件地址
            //qDebug() << "Human Readable Name : " << netInterface.humanReadableName();  // 人类可读的名字
            if ("eth0" == netInterface.name() )
//            if ("wlan0" == netInterface.name() )
            {
                QList<QNetworkAddressEntry> entryList = netInterface.addressEntries();
                if ( !entryList.at(0).ip().isNull() )
                {
                    QString hostIP = entryList.at(0).ip().toString();
                    qDebug() << "IP Address:" << entryList.at(0).ip().toString();
                    socketBroadCast = new QUdpSocket(this);
                    QString datagramStr = QString("autorock-alive") + ":" + hostIP + ":" +QString::number(HOSTPORT);
                    datagram = datagramStr.toLatin1();//类型要正确，类型，类型，类型！

                    netWorkStatusFlag = true;
                }
                /*foreach(QNetworkAddressEntry entry, entryList)
                { // 遍历每一个IP地址
                     qDebug() << "IP Address:" << entry.ip().toString();  // IP地址
                     //qDebug() << "Netmask:" << entry.netmask().toString();  // 子网掩码
                     //qDebug() << "Broadcast:" << entry.broadcast().toString();  // 广播地址
                }*/
            }
        }
    }
#endif
}

//send control information,eg,resolution,day/night
/*void ServerStream::sendCtrlInfo()
{
    QString ctrlInfoSimple = QString("autorock-head") + ":" + QString::number(RESOLUTION)
            + ":" + "800*480"; //resolution
    socketCtrl->write(ctrlInfoSimple.toLatin1());
    socketCtrl->flush();
    qDebug() << "send a message by socketCtrl  sendCtrlInfo :" << ctrlInfoSimple.toLatin1();
}*/

/*2017.2.27为了演示方便，增加以下内容
 * 仪表，向导航程序发送控制信息，比如，白天/黑夜模式，或分辨率，分辨率的格式："800*480"
正常工作时，仪表通过按键来设置并发送控制信息。车展演示时，在小屏和全屏模式下各自运行
一段时间，所以，要隔一段时间发送一次分辨率的设置信息。此处使用定时器，只是为了演示时用*/
void ServerStream::sendCtrlInfo(int type, /*const char **/QString data)
{
    QString ctrlInfoSimple = QString("autorock-alive") + ":" + QString::number(type)
            + ":" + data; //resolution
    socketCtrl->write(ctrlInfoSimple.toLatin1());
    socketCtrl->flush();
    qDebug() << "send a message by socketCtrl:" << ctrlInfoSimple.toLatin1();
}
//模拟全屏/小屏导航的切换
void ServerStream::setCtrlResolution(/*const char **/ QString data)
{
        //sendCtrlInfo(RESOLUTION, "1920*720");
        //sendCtrlInfo(RESOLUTION, "800*480");
        //sendCtrlInfo(RESOLUTION, "1106*663");
        //sendCtrlInfo(RESOLUTION, "960*663");
        sendCtrlInfo(RESOLUTION, data);
}


void ServerStream::proDisconnected()
{
    qDebug() << "**************** connection break. *******************";
    socketData->close();
    socketCtrl->close();
    connectNum = 1;
}

void ServerStream::connHUDSuccess()
{
    connHUDSuccessFlag = true;
}

void ServerStream::connHUDCTLSuccess()
{
    connHUDCTLSuccessFlag = true;
}

void ServerStream::connHUDSmallSuccess()
{
    connHUDSmallSuccessFlag = true;
    SendNaviInfo(client_hudSmall, NAVI_ROAD, imageLogoAutorock, lenImageLogoAutorock);
}

void ChangePics::run(QByteArray &data, ScreenImageProvider *imgProvider)
{
    imgProvider->img.QImage::loadFromData(data);
    emit refeshImg();
}

void ChangePicsSmallTurn::run(QByteArray &data, ScreenImageProvider *imgProvider)
{
    imgProvider->img.QImage::loadFromData(data);
    emit refeshImgSmallTurn();
}


void ChangePicsSmallChannel::run(QByteArray &data, ScreenImageProvider *imgProvider)
{
    imgProvider->img.QImage::loadFromData(data);
    emit refeshImgSmallChannel();
}

void ChangePicsSmallCross::run(QByteArray &data, ScreenImageProvider *imgProvider)
{
    imgProvider->img.QImage::loadFromData(data);
    emit refeshImgSmallCross();
}

void ChangePicsSmallCamera::run(QByteArray &data, ScreenImageProvider *imgProvider)
{
    imgProvider->img.QImage::loadFromData(data);
    emit refeshImgSmallCamera();
}

void ChangePicsSmallLogo::run(QByteArray &data, ScreenImageProvider *imgProvider)
{
    imgProvider->img.QImage::loadFromData(data);
    emit refeshImgSmallLogo();
}

void ChangePicsSmallOther::run(QByteArray &data, ScreenImageProvider *imgProvider)
{
    imgProvider->img.QImage::loadFromData(data);
    emit refeshImgSmallOther();
}


