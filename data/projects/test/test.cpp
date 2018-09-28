#include "test.h"

#include <QTimer>
#include <iostream>

test::test()
{
    QTimer* timer = new QTimer(this);
    connect( timer, SIGNAL(timeout()), SLOT(output()) );
    timer->start( 1000 );
}

test::~test()
{}

void test::output()
{
    std::cout << "Hello World!" << std::endl;
}

#include "test.moc"
