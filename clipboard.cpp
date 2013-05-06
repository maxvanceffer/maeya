#include "clipboard.h"
#include <QApplication>
#include <QMimeData>

Clipboard::Clipboard(QObject *parent):QObject(parent)
{
    clipboard = qApp->clipboard();

    connect(clipboard,SIGNAL(dataChanged()),SLOT(dataChanged()));
}

QString Clipboard::text() const
{
    return clipboard->text();
}

void Clipboard::dataChanged()
{
    if( clipboard->mimeData()->hasText() || clipboard->mimeData()->hasHtml() )
    {
        emit textChanged();
    }
}

void Clipboard::setText(const QString &text)
{
    clipboard->setText(text);
}
