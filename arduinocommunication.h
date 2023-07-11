
#ifndef ARDUINOCOMMUNICATION_H
#define ARDUINOCOMMUNICATION_H

#include <QObject>

class ArduinoCommunication : public QObject
{
    Q_OBJECT

public:
    explicit ArduinoCommunication(QObject *parent = nullptr);

signals:

public slots:

private slots:

private:
    QString m_currentEffect;
};

#endif // ARDUINOCOMMUNICATION_H
