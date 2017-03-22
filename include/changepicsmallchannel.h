#ifndef CHANGEPICSMALLCHANNEL
#define CHANGEPICSMALLCHANNEL

#include <QThread>
#include "screenimageprovider.h"

class ChangePicsSmallChannel : public QThread {
    Q_OBJECT
public :
    virtual void run(QByteArray &data, ScreenImageProvider *imgProvider);
    ~ChangePicsSmallChannel()
    {

    }
signals:
    void refeshImgSmallChannel();// tell ServerStream to emit a callQmlRefeshImg
};

#endif // CHANGEPICSMALLCHANNEL

