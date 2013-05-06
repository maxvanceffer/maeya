#ifndef LOADER_H
#define LOADER_H

#include <QObject>
#include <QTimer>
#include <QStringList>
#include <QtNetwork/QNetworkAccessManager>

class Loader : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString languages READ languages WRITE setLanguages NOTIFY languagesUpdated )
    Q_PROPERTY( QString translation READ translation WRITE setTranslation NOTIFY translationUpdated )
public:
    explicit Loader(QObject *parent = 0);

    Q_INVOKABLE void setLanguages(QString);
    Q_INVOKABLE void setTranslation(QString);

    Q_INVOKABLE QString languages() const;
    Q_INVOKABLE QString translation() const;


signals:
    void languagesUpdated(QString);
    void translationUpdated(QString);
    void errorTranslate(QString);
    void timeoutTranslate();

public slots:
    Q_INVOKABLE bool isTranslationDirectionAvailable( const QString& from, const QString& to ) const;
    Q_INVOKABLE void updateLanguages();
    Q_INVOKABLE void translate( QString, QString, QString );

private slots:
    void langsResponse();
    void transResponse();
    void networkTimeout();

private:
    QNetworkAccessManager * manager;
    QTimer networkRequestTimeout;
    QString locale;
    QString m_lang;
    QString m_trans;
    QStringList m_directions;
};

#endif // LOADER_H
