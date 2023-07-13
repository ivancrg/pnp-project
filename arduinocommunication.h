
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
    void getVariable(QString id);
    bool setVariable(QString id, QString payload);
    void setSelectedPort(QString);
    void setAvailablePortsNames(QVector<QString>);
    void refreshAvailablePorts();
    void setLedControl(QObject *);
    void setHeatingControl(QObject *);

private slots:
    QString read();
    bool write(QString data);

private:
    QSerialPort *m_arduino = nullptr;
    QString m_selectedPort;
    QVector<QString> m_availablePortsNames;
    bool serialReady = false;
    QObject *m_ledControl;
    QObject *m_heatingControl;
};

#endif // ARDUINOCOMMUNICATION_H
