#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include <QIcon>
#include <QQmlContext>
#include "extras.h"
#include <QQuickView>
#include "settingsmanager.h"
#include <QTime>
#include <QDateTime>
#include <array>
#include "flashingtimer.h"
#include <string>
#include "mytimer.h"
#include <FelgoApplication>
#include <QApplication>
//#include <FelgoLiveClient>
//FlashingTimer allTheTimeStuff();

//int main(int argc, char *argv[])
//{
//    //Prob only need this or...
//    QGuiApplication::setApplicationName("Shoot Hoops");
//    QGuiApplication::setOrganizationName("shootHoops");
//    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

//    QGuiApplication appy(argc, argv);

//    //App information
//    appy.setOrganizationName("shootHoops");
//    appy.setOrganizationDomain("shootHoops.com");
//    appy.setApplicationName("Shoot Hoops");

//    QApplication app(argc, argv);
//    //App information
//    app.setOrganizationName("shootHoops");
//    app.setOrganizationDomain("shootHoops.com");
//    app.setApplicationName("Shoot Hoops");
//    FelgoApplication felgo;
//    felgo.setPreservePlatformFonts(true);
//    QQmlApplicationEngine engine;
//    felgo.initialize(&engine);
//    felgo.setLicenseKey(PRODUCT_LICENSE_KEY);

//    FlashingTimer joe = allTheTimeStuff();
//    Extras extra;
//    SettingsManager dude;
//    qmlRegisterType<MyTimer>("otherArjun2", 1, 2, "MyTimer");
//    qmlRegisterType<SettingsManager>("Lebron2", 1,0, "SettingsManager");
//    //one thing to note is that is you want to change something in c++ (say with a timer) and want to automatically have it update in QML use setContextObject with the object instead of setObjectProperty
//    engine.rootContext()->setContextObject(&joe);
//    engine.rootContext()->setContextProperty("FlashingTimer",&joe);
//    engine.rootContext()->setContextProperty("Extra", &extra);
//    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());
//    felgo.setMainQmlFileName(QStringLiteral("qml/Main.qml"));

//    FelgoLiveClient client (&engine);

//    return app.exec();
//}


//FlashingTimer allTheTimeStuff(){
//    QDateTime now= QDateTime::currentDateTime();
//    //Make and save tomorrow
//    QSettings settings;
//    SettingsManager dude;
//    QDateTime tomorrow=now.addSecs(86399);
//    if(!settings.contains("Time0"))
//        dude.writeSettings("Time0", tomorrow);
//    else{
//        tomorrow = SettingsManager::loadSettings("Time0").toDateTime();
//    }
//    FlashingTimer joe(tomorrow);
//    return joe;
//}

//// Default message handler to be called to bypass all other warnings.
//static const QtMessageHandler QT_DEFAULT_MESSAGE_HANDLER = qInstallMessageHandler(0);
//// a custom message handler to intercept warnings
//void customMessageHandler(QtMsgType type, const QMessageLogContext &context, const QString & msg)
//{
//    switch (type) {
//    case QtWarningMsg: {
//        if (!msg.contains("Unable to assign [undefined] to int")){ // suppress this warning
//            (*QT_DEFAULT_MESSAGE_HANDLER)(type, context, msg); // bypass and display all other warnings
//        }
//    }
//    break;
//    default:    // Call the default handler.
//        (*QT_DEFAULT_MESSAGE_HANDLER)(type, context, msg);
//        break;
//    }
//}


FlashingTimer allTheTimeStuff();

int main(int argc, char *argv[])
{
    //Prob only need this or...
    QGuiApplication::setApplicationName("Shoot Hoops");
    QGuiApplication::setOrganizationName("shootHoops");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication appy(argc, argv);
    //App information
    appy.setOrganizationName("shootHoops");
    appy.setOrganizationDomain("shootHoops.com");
    appy.setApplicationName("Shoot Hoops");

    QApplication app(argc, argv);

    //App information
    app.setOrganizationName("shootHoops");
    app.setOrganizationDomain("shootHoops.com");
    app.setApplicationName("Shoot Hoops");

    FelgoApplication felgo;
    //    felgo.setPreservePlatformFonts(true);
    QQmlApplicationEngine engine;
    felgo.initialize(&engine);
    felgo.setLicenseKey(PRODUCT_LICENSE_KEY);

    //sends when i break a property binding
    //    QLoggingCategory::setFilterRules(QStringLiteral("qt.qml.binding.removal.info=true"));

    FlashingTimer joe = allTheTimeStuff();
    Extras extra;
    SettingsManager dude;
    qmlRegisterType<MyTimer>("otherArjun2", 1, 2, "MyTimer");
    qmlRegisterType<SettingsManager>("Lebron2", 1,0, "SettingsManager");
    //one thing to note is that is you want to change something in c++ (say with a timer) and want to automatically have it update in QML use setContextObject with the object instead of setObjectProperty
    engine.rootContext()->setContextObject(&joe);
    engine.rootContext()->setContextProperty("FlashingTimer",&joe);
    engine.rootContext()->setContextProperty("Extra", &extra);
    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());

    felgo.setMainQmlFileName(QStringLiteral("qrc:/qml/Main.qml"));
    engine.load(QUrl(felgo.mainQmlFileName()));
    return app.exec();
}


FlashingTimer allTheTimeStuff(){
    QDateTime now= QDateTime::currentDateTime();
    //Make and save tomorrow
    QSettings settings;
    SettingsManager dude;
    QDateTime tomorrow=now.addSecs(86399);
    if(!settings.contains("Time0"))
        dude.writeSettings("Time0", tomorrow);
    else{
        tomorrow = SettingsManager::loadSettings("Time0").toDateTime();
    }
    FlashingTimer joe(tomorrow);
    return joe;
}

//// Default message handler to be called to bypass all other warnings.
//static const QtMessageHandler QT_DEFAULT_MESSAGE_HANDLER = qInstallMessageHandler(0);
//// a custom message handler to intercept warnings
//void customMessageHandler(QtMsgType type, const QMessageLogContext &context, const QString & msg)
//{
//    switch (type) {
//    case QtWarningMsg: {
//        if (!msg.contains("Unable to assign [undefined] to int")){ // suppress this warning
//            (*QT_DEFAULT_MESSAGE_HANDLER)(type, context, msg); // bypass and display all other warnings
//        }
//    }
//    break;
//    default:    // Call the default handler.
//        (*QT_DEFAULT_MESSAGE_HANDLER)(type, context, msg);
//        break;
//    }
//}

