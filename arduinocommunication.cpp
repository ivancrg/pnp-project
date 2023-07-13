
#include "arduinocommunication.h"
#include <./QDebug>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QList>
#include <QObject>
#include "ledcontrol.h"
#include "heatingcontrol.h"
#include<QThread>

ArduinoCommunication::ArduinoCommunication(QObject *parent)
    : QObject{parent}
{
    refreshAvailablePorts();
    m_arduino = nullptr;
}

ArduinoCommunication::~ArduinoCommunication()
{
    //    if (m_arduino->isOpen())
    //        m_arduino->close();
}

QString ArduinoCommunication::selectedPort()
{
    return m_selectedPort;
}

QVector<QString> ArduinoCommunication::availablePortsNames()
{
    return m_availablePortsNames;
}

QString ArduinoCommunication::read()
{
    if (!serialReady || !m_arduino || !(m_arduino->isOpen()) || !(m_arduino->isReadable())) {
        qDebug() << "Serial not readable!";
        if(serialReady && m_arduino) qDebug() << m_arduino->isOpen() << m_arduino->isReadable();
        return NULL;
    }

    qDebug() << "Reading from Arduino...";
    char transmission[10000];
    //while(!m_arduino->canReadLine());
    m_arduino->readLine(transmission, sizeof(transmission));


    QString data = QString(transmission);

//    if(data.trimmed().isEmpty()){
//        char transmission[10000];
//        m_arduino->readLine(transmission, sizeof(transmission));
//        data = QString(transmission);
//    }

    qDebug() << "READ DATA: " << data;

    ((LEDControl *) m_ledControl)->processVariable(data);
    ((HeatingControl *) m_heatingControl)->processVariable(data);

    return data;
}

bool ArduinoCommunication::write(QString data)
{
    bool a = (m_arduino == nullptr);
    qDebug() << a;
    if (!serialReady || !m_arduino || !(m_arduino->isOpen()) || !(m_arduino->isReadable())) {
        qDebug() << "Serial not writeable!";
        return false;
    }

    qDebug() << "Sending to Arduino: [" << data << "]";
    m_arduino->write(data.toStdString().c_str());

    return true;
}

void ArduinoCommunication::getVariable(QString id)
{
    qDebug() << "GET FROM ARDUINO " << id;
    write("GET: " + id);
}

bool ArduinoCommunication::setVariable(QString id, QString payload)
{
    return write(id + ": " + payload);
    QThread::msleep(250);
}

void ArduinoCommunication::setSelectedPort(QString newPort)
{
    serialReady = true;

    m_selectedPort = newPort;
    emit selectedPortChanged();

    m_arduino = new QSerialPort;
    m_arduino->setPortName(m_selectedPort);
    //    qDebug() << "1" << serialReady;
    serialReady = serialReady && m_arduino->open(QSerialPort::ReadWrite);
    //    qDebug() << "2" << serialReady;
    serialReady = serialReady && m_arduino->setBaudRate(QSerialPort::Baud9600);
    //    qDebug() << "3" << serialReady;
    serialReady = serialReady && m_arduino->setDataBits(QSerialPort::Data8);
    //    qDebug() << "4" << serialReady;
    serialReady = serialReady && m_arduino->setParity(QSerialPort::NoParity);
    //    qDebug() << "5" << serialReady;
    serialReady = serialReady && m_arduino->setStopBits(QSerialPort::OneStop);
    //    qDebug() << "6" << serialReady;
    serialReady = serialReady && m_arduino->setFlowControl(QSerialPort::NoFlowControl);
    //    qDebug() << "7" << serialReady;
    QObject::connect(m_arduino, SIGNAL(readyRead()), this, SLOT(read()));
}

void ArduinoCommunication::setAvailablePortsNames(QVector<QString> newPortNames)
{
    m_availablePortsNames = newPortNames;
    emit availablePortsNamesChanged();
}

void ArduinoCommunication::refreshAvailablePorts()
{
    const auto infos = QSerialPortInfo::availablePorts();
    QVector<QString> newPorts;

    for (const QSerialPortInfo &info : infos)
        newPorts.push_back(info.portName());

    setAvailablePortsNames(newPorts);
}

void ArduinoCommunication::setLedControl(QObject *p)
{
    m_ledControl = p;
}

void ArduinoCommunication::setHeatingControl(QObject * p)
{
    m_heatingControl = p;
}
