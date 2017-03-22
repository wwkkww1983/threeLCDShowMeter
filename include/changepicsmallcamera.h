#ifndef CHANGEPICSMALLCAMERA
#define CHANGEPICSMALLCAMERA

#include <QThread>
#include "screenimageprovider.h"

class ChangePicsSmallCamera : public QThread {
    Q_OBJECT
public :
    virtual void run(QByteArray &data, ScreenImageProvider *imgProvider);
    ~ChangePicsSmallCamera()
    {

    }
signals:
    void refeshImgSmallCamera();// tell ServerStream to emit a callQmlRefeshImg
};

#endif // CHANGEPICSMALLCAMERA

