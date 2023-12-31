#include <QtWidgets/QApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QQmlContext>
#include <QIcon>

#include "arduinocommunication.h"
#include "ledcontrol.h"
#include "heatingcontrol.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv); // Change to QApplication

    QFontDatabase::addApplicationFont(":/fonts/materialdesignicons-webfont.ttf");

    //qmlRegisterType<LEDControl> ("LEDControl", 1, 0, "LEDC");
    //qmlRegisterType<HeatingControl> ("HeatingControl", 1, 0, "HeatingC");
    //qmlRegisterType<ArduinoCommunication> ("ArduinoCommunication", 1, 0, "ArduinoCom");

    ArduinoCommunication arduinoCommunication;
    LEDControl ledControl;
    HeatingControl heatingControl;

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/projekt/Main.qml"_qs);

    engine.addImportPath(app.applicationDirPath());

    QQmlContext *rootContext = engine.rootContext();
    rootContext->setContextProperty("ArduinoComm", &arduinoCommunication);
    rootContext->setContextProperty("LEDC", &ledControl);
    rootContext->setContextProperty("HeatingC", &heatingControl);

    ledControl.setAc(&arduinoCommunication);
    heatingControl.setAc(&arduinoCommunication);
    arduinoCommunication.setLedControl(&ledControl);
    arduinoCommunication.setHeatingControl(&heatingControl);

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

//    app.setWindowIcon(QIcon("./icons/c.svg"));

    return app.exec();
}

//#include <QGuiApplication>
//#include <QQmlApplicationEngine>
//#include <QFontDatabase>

//int main(int argc, char *argv[])
//{
//    QGuiApplication app(argc, argv);

//    QFontDatabase::addApplicationFont(":/fonts/materialdesignicons-webfont.ttf");

//    QQmlApplicationEngine engine;
//    const QUrl url(u"qrc:/projekt/Main.qml"_qs);

//    // QQmlApplicationEngine engine;
//    // to make sure QGE module can be found at runtime.
//    engine.addImportPath(app.applicationDirPath());

//    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
//        &app, []() { QCoreApplication::exit(-1); },
//        Qt::QueuedConnection);
//    engine.load(url);
//    //engine.loadFromModule("projekt", "Main");
//    return app.exec();
//}
