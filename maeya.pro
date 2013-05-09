# Add files and directories to ship with the application
# by adapting the examples below.
#file1.source = myfile
dir1.source = qml
dir1.path   = /bin/qml
DEPLOYMENTFOLDERS = dir1 # file1

symbian:TARGET.UID3 = 0xE2D293D1

# Smart Installer package's UID
# This UID is from the protected range
# and therefore the package will fail to install if self-signed
# By default qmake uses the unprotected range value if unprotected UID is defined for the application
# and 0x2002CCCF value if protected UID is given to the application
#symbian:DEPLOYMENT.installer_header = 0x2002CCCF

# Allow network access on Symbian
symbian:TARGET.CAPABILITY += NetworkServices

# If your application uses the Qt Mobility libraries, uncomment
# the following lines and add the respective components to the
# MOBILITY variable.
CONFIG += mobility
MOBILITY += sensors

SOURCES += main.cpp mainwindow.cpp \
    loader.cpp \
    xmlParser.cpp \
    clipboard.cpp
HEADERS += mainwindow.h \
    loader.h \
    orientatationfilter.h \
    xmlParser.h \
    clipboard.h \
    customimageprovider.h
FORMS += mainwindow.ui
RESOURCES += flags/resource.qrc
QT += declarative core gui network
CONFIG += qdbus

# Please do not modify the following two lines. Required for deployment.
include(deployment.pri)
qtcAddDeployment()

OTHER_FILES += \
    qtc_packaging/debian_harmattan/rules \
    qtc_packaging/debian_harmattan/README \
    qtc_packaging/debian_harmattan/manifest.aegis \
    qtc_packaging/debian_harmattan/copyright \
    qtc_packaging/debian_harmattan/control \
    qtc_packaging/debian_harmattan/compat \
    qtc_packaging/debian_harmattan/changelog

contains(MEEGO_EDITION,harmattan) {
    icon.files = maeya.png
    icon.path = /usr/share/icons/hicolor/80x80/apps
    INSTALLS += icon
}
