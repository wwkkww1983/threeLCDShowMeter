#ifndef CHANGEPICSMALLLOGO_H
#define CHANGEPICSMALLLOGO_H

#include <QThread>
#include "screenimageprovider.h"

class ChangePicsSmallLogo : public QThread {
    Q_OBJECT
public :
    virtual void run(QByteArray &data, ScreenImageProvider *imgProvider);
    ~ChangePicsSmallLogo()
    {

    }
signals:
    void refeshImgSmallLogo();// tell ServerStream to emit a callQmlRefeshImg
};

#endif // CHANGEPICSMALLLOGO_H

