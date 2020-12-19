#include "settingsmanager.h"

SettingsManager::SettingsManager(QObject *parent) : QObject(parent)
{

}

QVariant SettingsManager::loadSettings(const QString &key)
{
    // .ini format example
    QSettings settings(thing(), QSettings::NativeFormat);
    return settings.value(key,0);
}

 void SettingsManager::writeSettings(const QString &key, const QVariant &variant)
{
    QSettings settings (thing(), QSettings::NativeFormat);
    settings.setValue(key, variant);
}

QString SettingsManager::thing(){
    QSettings settings;
    return settings.fileName();
}
