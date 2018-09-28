#include <QCoreApplication>
#include "test.h"


int main(int argc, char** argv)
{
    QCoreApplication app(argc, argv);
    test test;
    return app.exec();
}
