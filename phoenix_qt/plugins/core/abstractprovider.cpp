#include "abstractprovider.h"

AbstractProvider::AbstractProvider(QObject *parent)
    : QObject{parent}
{}

QString AbstractProvider::descript() const
{
    return {};
}
