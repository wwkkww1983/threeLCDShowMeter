#ifndef CHANGEPICSMALL
#define CHANGEPICSMALL
#include <QThread>
#include "screenimageprovider.h"

class ChangePicsSmallTurn : public QThread {
    Q_OBJECT
public :
    virtual void run(QByteArray &data, ScreenImageProvider *imgProvider);
    ~ChangePicsSmallTurn()
    {

    }
signals:
    void refeshImgSmallTurn();// tell ServerStream to emit a callQmlRefeshImg
};

#endif // CHANGEPICSMALL

