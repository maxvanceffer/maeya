#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QtGui/QMainWindow>

#include "loader.h"

namespace Ui {
    class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    enum ScreenOrientation {
        ScreenOrientationLockPortrait,
        ScreenOrientationLockLandscape,
        ScreenOrientationAuto
    };

    explicit MainWindow(QWidget *parent = 0);
    virtual ~MainWindow();

    // Note that this will only have an effect on Symbian and Fremantle.
    void setOrientation(ScreenOrientation orientation);

    void showExpanded();

public slots:
    void minimize();

protected:
    virtual void changeEvent(QEvent *);

private:
    Ui::MainWindow *ui;
    Loader * loader;
};

#endif // MAINWINDOW_H
