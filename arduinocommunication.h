
#ifndef ARDUINOCOMMUNICATION_H
#define ARDUINOCOMMUNICATION_H

#include <QObject>
#include <QSerialPort>
#include <QList>

class ArduinoCommunication : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString selectedPort READ selectedPort WRITE setSelectedPort NOTIFY selectedPortChanged)
    Q_PROPERTY(QVector<QString> availablePortsNames READ availablePortsNames WRITE setAvailablePortsNames NOTIFY availablePortsNamesChanged)

public:
    explicit ArduinoCommunication(QObject *parent = nullptr);
    ~ArduinoCommunication();
    QString selectedPort();
    QVector<QString> availablePortsNames();

signals:
    void selectedPortChanged();
    void availablePortsNamesChanged();

public slots:
    QString getVariable(QString id);
    bool setVariable(QString id, QString payload);
    void setSelectedPort(QString);
    void setAvailablePortsNames(QVector<QString>);
    void refreshAvailablePorts();

private slots:
    QString read();
    bool write(QString data);

private:
    QSerialPort *m_arduino;
    QString m_selectedPort;
    QVector<QString> m_availablePortsNames;
};

#endif // ARDUINOCOMMUNICATION_H


/*
    const auto infos = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : infos)
        m_serialPortComboBox->addItem(info.portName());
*/
