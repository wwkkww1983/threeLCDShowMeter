#ifndef SCREENIMAGEPROVIDER
#define SCREENIMAGEPROVIDER

#include <QQuickImageProvider>
#include <QImage>
#include <QSize>
#include <QColor>

class ScreenImageProvider : public QQuickImageProvider
{
public:
    ScreenImageProvider()
        : QQuickImageProvider(QQuickImageProvider::Image)
    {
    }

    QImage requestImage(const QString &, QSize *, const QSize &)
    {
        return this->img;
    }

    QImage img;
};

#endif // SCREENIMAGEPROVIDER

