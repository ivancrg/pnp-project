
#include "arduinocommunication.h"
#include <./QDebug>
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QList>
#include <QObject>

ArduinoCommunication::ArduinoCommunication(QObject *parent)
    : QObject{parent}
{
    refreshAvailablePorts();
}

ArduinoCommunication::~ArduinoCommunication()
{
    if (m_arduino->isOpen())
        m_arduino->close();
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
    //qDebug() << "TEST"; return NULL;
    if (!m_arduino || !m_arduino->isOpen() || !m_arduino->isReadable()) {
        qDebug() << "Serial not readable!";
        return NULL;
    }

    qDebug() << "Reading from Arduino...";
    QString data;
    data = m_arduino->read(1000);
    qDebug() << data;
    return data;
}

bool ArduinoCommunication::write(QString data)
{
    if (!m_arduino || !m_arduino->isOpen() || !m_arduino->isReadable()) {
        qDebug() << "Serial not writeable!";
        return false;
    }

    qDebug() << "Sending to Arduino: [" << data << "]";
    m_arduino->write(data.toStdString().c_str());
    return true;
}

bool ArduinoCommunication::setVariable(QString id, QString payload)
{
    if (!m_arduino || !m_arduino->isOpen() || !m_arduino->isReadable()) {
        qDebug() << "Serial not writeable!";
        return false;
    }

    QString data = id + ": " + payload;

    qDebug() << "Sending to Arduino: [" << data << "]";
    m_arduino->write(data.toStdString().c_str());
    return true;
}

QString ArduinoCommunication::getVariable(QString id)
{

}

void ArduinoCommunication::setSelectedPort(QString newPort)
{
    m_selectedPort = newPort;
    emit selectedPortChanged();

    m_arduino = new QSerialPort;
    m_arduino->setPortName(m_selectedPort);
    m_arduino->open(QSerialPort::ReadWrite);
    m_arduino->setBaudRate(QSerialPort::Baud9600);
    m_arduino->setDataBits(QSerialPort::Data8);
    m_arduino->setParity(QSerialPort::NoParity);
    m_arduino->setStopBits(QSerialPort::OneStop);
    m_arduino->setFlowControl(QSerialPort::NoFlowControl);
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
