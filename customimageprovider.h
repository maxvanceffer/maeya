#ifndef CUSTOMIMAGEPROVIDER_H
#define CUSTOMIMAGEPROVIDER_H

#include <QDeclarativeImageProvider>
#include <QLocale>
#include <QPixmap>
#include <QString>
#include <QDebug>

class ImageProvider: public QObject, public QDeclarativeImageProvider
{
    Q_OBJECT
public:
    ImageProvider(QObject * parent = 0):QObject(parent),
        QDeclarativeImageProvider(QDeclarativeImageProvider::Pixmap){}

    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
    {
        Q_UNUSED(size);
        QString sid = QString(id).remove("image://");
        QLocale loc(sid);
        QPixmap pix;
        if( pix.load(":/"+loc.name().split("_").first()+".png") )
        {
            if (requestedSize.isValid())
                return pix.scaled(requestedSize, Qt::KeepAspectRatio);
            else
                return pix.scaled(QSize(32,32));
        }

        if( requestedSize.isValid() )
            return QPixmap(":/unknown.png").scaled(requestedSize);

        return QPixmap(":/unknown.png").scaled(QSize(22,22));
    }
};

#endif // CUSTOMIMAGEPROVIDER_H
