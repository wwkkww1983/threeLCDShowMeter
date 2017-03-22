#ifndef CHANGEPICS
#define CHANGEPICS
#include <QThread>
#include "screenimageprovider.h"

class ChangePics : public QThread {
    Q_OBJECT
public :
    virtual void run(QByteArray &data, ScreenImageProvider *imgProvider);
    ~ChangePics()
    {

    }
signals:
    void refeshImg();// tell ServerStream to emit a callQmlRefeshImg
};

#endif // CHANGEPICS

