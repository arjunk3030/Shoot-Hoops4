#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H
#include <QSettings>
#include <QObject>

class SettingsManager : public QObject
{
    Q_OBJECT
public:
    explicit SettingsManager(QObject *parent = nullptr);
    static QVariant loadSettings(const QString &key);
    Q_INVOKABLE void writeSettings(const QString &key, const QVariant &variant);
    static QString thing();
signals:

};

#endif // SETTINGSMANAGER_H
