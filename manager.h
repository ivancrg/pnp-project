
#ifndef MANAGER_H
#define MANAGER_H


#include <QObject>
#include <arduinocommunication.h>
#include <ledcontrol.h>


class Manager : public QObject
{
    Q_OBJECT
public:
    explicit Manager(QObject *parent = nullptr);

signals:

private:
    ArduinoCommunication *m_ac;
    LEDControl *m_lc;
};

#endif // MANAGER_H
