#ifndef CHANGEPICSMALLCROSS
#define CHANGEPICSMALLCROSS

#include <QThread>
#include "screenimageprovider.h"

class ChangePicsSmallCross : public QThread {
    Q_OBJECT
public :
    virtual void run(QByteArray &data, ScreenImageProvider *imgProvider);
    ~ChangePicsSmallCross()
    {

    }
signals:
    void refeshImgSmallCross();// tell ServerStream to emit a callQmlRefeshImg
};

#endif // CHANGEPICSMALLCROSS

