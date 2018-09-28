#ifndef test_H
#define test_H

#include <QtCore/QObject>

class test : public QObject
{
    Q_OBJECT

public:
    test();
    virtual ~test();

private slots:
    void output();
};

#endif // test_H
