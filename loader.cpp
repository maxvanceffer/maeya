#include "loader.h"
#include <QLocale>
#include <QDebug>

#include <QtNetwork/QNetworkRequest>
#include <QtNetwork/QNetworkReply>

#include "xmlParser.h"

const QString& api_key       = "trnsl.1.1.20130429T131831Z.dd31273997625541.c6aec0cff6e47f112edbc062c4fdb167a145ad25";
const QString& api_host      = "https://translate.yandex.net";
const QString& api_path      = "/api/v1.5/tr";
const QString& api_lang      = "/getLangs";
const QString& api_translate = "/translate";

Loader::Loader(QObject *parent):QObject(parent)
{
    manager = new QNetworkAccessManager(this);
    locale  = QLocale::system().languageToString(QLocale::system().language()).left(2).toLower();

    qDebug()<<"System locale "<<locale;
    networkRequestTimeout.setSingleShot(true);
    connect(&networkRequestTimeout,SIGNAL(timeout()),SLOT(networkTimeout()));
}

void Loader::setLanguages(QString source )
{
    m_lang = source;

    XMLNode root = XMLNode::parseString(source.toLatin1(),"Langs");
    XMLNode dirs = root.getChildNode("dirs");
    if( !dirs.isEmpty() )
    {
        const int& count = dirs.nChildNode("string");
        for( int i = 0; i < count; i++ )
        {
            m_directions << dirs.getChildNode("string",i).getText();
        }
    }

    qDebug()<<"Directions updated "<<m_directions;

    emit languagesUpdated(m_lang);
}

void Loader::setTranslation(QString source)
{
    m_trans = source;
}

QString Loader::languages() const
{
    return m_lang;
}

QString Loader::translation() const
{
    return m_trans;
}

bool Loader::isTranslationDirectionAvailable(const QString &from, const QString &to) const
{
    QString direction = QString("%1-%2").arg(from,to);
    qDebug()<<"Checking if available translation "<<direction<<" = "<<m_directions.contains(direction);
    return m_directions.contains(direction);
}

void Loader::updateLanguages()
{
    QNetworkRequest req;
    QUrl url(api_host);
    url.setPath(api_path+api_lang);
    url.addQueryItem("key",api_key);
    url.addQueryItem("ui",locale);
    req.setUrl(url);

    qDebug()<<"Make request "<<req.url().toString();

    QNetworkReply * impl = manager->get(req);
    connect(impl,SIGNAL(finished()),this,SLOT(langsResponse()));
}

void Loader::translate(QString from, QString to, QString text )
{
    QNetworkRequest req;
    QUrl url(api_host);
    url.setPath(api_path+api_translate);
    url.addQueryItem("key",api_key);
    url.addQueryItem("lang",QString("%1-%2").arg(from,to));
    url.addQueryItem("text",text);
    req.setUrl(url);

    qDebug()<<"requesting "<<url.toString();

    QNetworkReply * impl = manager->get(req);
    connect(impl,SIGNAL(finished()),SLOT(transResponse()));

    networkRequestTimeout.start(10000);
}

void Loader::langsResponse()
{
    QNetworkReply * impl = qobject_cast<QNetworkReply*>(QObject::sender());
    if( !impl ) return;
    impl->deleteLater();
    setLanguages(impl->readAll());
}

void Loader::transResponse()
{
    QNetworkReply * impl = qobject_cast<QNetworkReply*>(QObject::sender());
    if( !impl ) return;
    impl->deleteLater();

    qDebug()<<"Response "<<m_trans;

    XMLResults res;
    XMLNode root = XMLNode::parseString(impl->readAll(),"Translation",&res);
    if( root.isEmpty() ||  res.error ) {
        qWarning()<<"XML response is empty";
        networkRequestTimeout.stop();
        emit timeoutTranslate();
        return;
    }

    XMLNode translationNode = root.getChildNode("text");
    m_trans = QString::fromUtf8(translationNode.getText());

    emit translationUpdated(m_trans);
}

void Loader::networkTimeout()
{
    networkRequestTimeout.stop();
    emit timeoutTranslate();
}

