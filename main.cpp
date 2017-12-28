#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "calc_dox.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();    // Создаём корневой контекст
    QList<QObject*> dataList;
    calc_dox calc(dataList,context);    // Создаём ядро приложения
       /* Загружаем объект в контекст для установки соединения,
        * а также определяем имя, по которому будет происходить соединение
        * */
    context->setContextProperty("calc", &calc);
    context->setContextProperty("p_model", QVariant::fromValue(dataList));

    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
