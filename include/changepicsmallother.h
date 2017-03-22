#ifndef CHANGEPICSMALLOTHER
#define CHANGEPICSMALLOTHER

#include <QThread>
#include "screenimageprovider.h"

class ChangePicsSmallOther : public QThread {
    Q_OBJECT
public :
    virtual void run(QByteArray &data, ScreenImageProvider *imgProvider);
    ~ChangePicsSmallOther()
    {

    }
signals:
    void refeshImgSmallOther();// tell ServerStream to emit a callQmlRefeshImg
};

#endif // CHANGEPICSMALLOTHER

