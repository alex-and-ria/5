#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtWidgets/QApplication>
#include <QQmlContext>
#include <QQmlComponent>
#include "calc_dox.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    //QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    //QQmlContext *context = engine.rootContext();    // Создаём корневой контекст
    //QQmlComponent component(&engine_qml,QUrl::fromLocalFile("q1.qml"));
    //QObject *root_qml_obj = component.create();
    QList<QObject*> dataList;

    calc_dox calc(dataList,&engine);    // Создаём ядро приложения
       /* Загружаем объект в контекст для установки соединения,
        * а также определяем имя, по которому будет происходить соединение
        * */
    engine.rootContext()->setContextProperty("calc", &calc);
    calc.set_r_objects();
    //context->setContextProperty("p_model", QVariant::fromValue(dataList));



    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
