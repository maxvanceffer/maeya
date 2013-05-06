#ifndef ORIENTATATIONFILTER_H
#define ORIENTATATIONFILTER_H

#include <QtSensors/QOrientationFilter>

QTM_USE_NAMESPACE

class OrientationFilter : public QObject, public QOrientationFilter
{
    Q_OBJECT
public:
    OrientationFilter( QObject * parent = 0 ):QObject(parent){}

    bool filter(QOrientationReading *reading) {
        emit orientationChanged(reading->orientation());

        // don't store the reading in the sensor
        return false;
    }

signals:
    void orientationChanged(const QVariant &orientation);
};

#endif // ORIENTATATIONFILTER_H
