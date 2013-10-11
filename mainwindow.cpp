#include "mainwindow.h"
#include "ui_mainwindow.h"

#include <QApplication>
#include <QtCore/QDir>
#include <QtCore/QDebug>
#include <QDBusConnection>
#include <QDBusMessage>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeContext>
#include <QtDBus/QtDBus>
#include <QtSensors/QOrientationSensor>

#include "orientatationfilter.h"
#include "customimageprovider.h"
#include "clipboard.h"

using namespace QtMobility;


MainWindow::MainWindow(QWidget *parent) : QMainWindow(parent), ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    loader = new Loader(this);

    QDeclarativeView * view = new QDeclarativeView(this);
    ui->gridLayout->addWidget(view);

    QDir dir(qApp->applicationDirPath());

    ImageProvider * provider = new ImageProvider(this);
    view->engine()->addImageProvider(QLatin1String("flags"),provider);

    Clipboard * clipboard = new Clipboard(this);
    view->rootContext()->setContextProperty("clipboard",clipboard);

    QOrientationSensor * sensor = new QOrientationSensor(this);
    OrientationFilter * filter = new OrientationFilter(this);
    sensor->addFilter(filter);

    if( dir.cd("../qml") )
    {
        view->rootContext()->setContextProperty("loader",loader);
        view->rootContext()->setContextProperty("window",this);
        view->setResizeMode(QDeclarativeView::SizeRootObjectToView);
        view->setSource(QUrl::fromLocalFile(dir.absoluteFilePath("main.qml")));

        loader->updateLanguages();
    }
    else
    {
        if( dir.cd("qml") )
        {
            view->rootContext()->setContextProperty("loader",loader);
            view->rootContext()->setContextProperty("window",this);
            view->setResizeMode(QDeclarativeView::SizeRootObjectToView);
            view->setSource(QUrl::fromLocalFile(dir.absoluteFilePath("main.qml")));

            loader->updateLanguages();
        }
        else
        qWarning()<<"Cannot find qml folder to load";
    }

    // Connect the Qt signal to QML function
    connect(filter,SIGNAL(orientationChanged(const QVariant&)),(QObject*)view->rootObject(), SLOT(orientationChanged(const QVariant&)));
    connect(loader,SIGNAL(timeoutTranslate()),(QObject*)view->rootObject(), SLOT(translationTimeout()));
    sensor->start();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::setOrientation(ScreenOrientation orientation)
{
#if defined(Q_OS_SYMBIAN)
    // If the version of Qt on the device is < 4.7.2, that attribute won't work
    if (orientation != ScreenOrientationAuto) {
        const QStringList v = QString::fromAscii(qVersion()).split(QLatin1Char('.'));
        if (v.count() == 3 && (v.at(0).toInt() << 16 | v.at(1).toInt() << 8 | v.at(2).toInt()) < 0x040702) {
            qWarning("Screen orientation locking only supported with Qt 4.7.2 and above");
            return;
        }
    }
#endif // Q_OS_SYMBIAN

    Qt::WidgetAttribute attribute;
    switch (orientation) {
#if QT_VERSION < 0x040702
    // Qt < 4.7.2 does not yet have the Qt::WA_*Orientation attributes
    case ScreenOrientationLockPortrait:
        attribute = static_cast<Qt::WidgetAttribute>(128);
        break;
    case ScreenOrientationLockLandscape:
        attribute = static_cast<Qt::WidgetAttribute>(129);
        break;
    default:
    case ScreenOrientationAuto:
        attribute = static_cast<Qt::WidgetAttribute>(130);
        break;
#else // QT_VERSION < 0x040702
    case ScreenOrientationLockPortrait:
        attribute = Qt::WA_LockPortraitOrientation;
        break;
    case ScreenOrientationLockLandscape:
        attribute = Qt::WA_LockLandscapeOrientation;
        break;
    default:
    case ScreenOrientationAuto:
        attribute = Qt::WA_AutoOrientation;
        break;
#endif // QT_VERSION < 0x040702
    };
    setAttribute(attribute, true);
}

void MainWindow::showExpanded()
{
#if defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    showFullScreen();
#elif defined(Q_WS_MAEMO_5)
    showMaximized();
#else
    show();
#endif
}

void MainWindow::minimize()
{
    qDebug()<<"Minimize";
    QDBusConnection connection = QDBusConnection::sessionBus();
    QDBusMessage message = QDBusMessage::createSignal("/","com.nokia.hildon_desktop","exit_app_view");
    connection.send(message);
}

void MainWindow::changeEvent(QEvent *event)
{
    if(event->type()==QEvent::ActivationChange) {
        if(!isActiveWindow()) {
            qDebug()<<"Window minimized";
        }
    }
}
