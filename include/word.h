
#include<QObject>
#include <QString>

class Word : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString str MEMBER m_str NOTIFY strChanged)
signals:
    void strChanged();
public:
    QString m_str;
};




