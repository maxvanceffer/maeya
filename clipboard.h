#ifndef CLIPBOARD_H
#define CLIPBOARD_H

#include <QObject>
#include <QClipboard>

class Clipboard : public QObject
{
    Q_OBJECT
    Q_PROPERTY( QString text READ text WRITE setText NOTIFY textChanged )
public:
    explicit Clipboard(QObject *parent = 0);

    Q_INVOKABLE QString text() const;

signals:
    void textChanged();

public slots:
    Q_INVOKABLE void setText( const QString& text );
    void dataChanged();

private:
    QClipboard * clipboard;
};

#endif // CLIPBOARD_H
