#include <QtWidgets/QApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv); // Change to QApplication

    QFontDatabase::addApplicationFont(":/fonts/materialdesignicons-webfont.ttf");

    QQmlApplicationEngine engine;
    const QUrl url(u"qrc:/projekt/Main.qml"_qs);

    engine.addImportPath(app.applicationDirPath());

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

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
