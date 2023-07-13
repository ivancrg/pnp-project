
#ifndef HEATINGCONTROL_H
#define HEATINGCONTROL_H

#include <QObject>
#include <QVariantMap>

class HeatingControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantMap temperatures READ temperatures WRITE setTemperatures NOTIFY temperaturesChanged)
    Q_PROPERTY(QVariantMap relays READ relays WRITE setRelays NOTIFY relaysChanged)
    Q_PROPERTY(QString heatingMode READ heatingMode WRITE setHeatingMode NOTIFY heatingModeChanged)
    Q_PROPERTY(QVector<double> temperatureHistory READ temperatureHistory WRITE setTemperatureHistory NOTIFY temperatureHistoryChanged)
    Q_PROPERTY(QVector<double> consumptionHistory READ consumptionHistory WRITE setConsumptionHistory NOTIFY consumptionHistoryChanged)

public:
    explicit HeatingControl(QObject *parent = nullptr);
    QVariantMap temperatures();
    QVariantMap relays();
    QString heatingMode();
    QVector<double> temperatureHistory();
    QVector<double> consumptionHistory();

signals:
    void temperaturesChanged();
    void relaysChanged();
    void heatingModeChanged();
    void temperatureHistoryChanged();
    void consumptionHistoryChanged();

public slots:
    void setTemperatures(QVariantMap);
    void setRelays(QVariantMap);
    void setHeatingMode(QString);
    void setTemperatureHistory(QVector<double>);
    void setConsumptionHistory(QVector<double>);
    void changeTemperature(QString, QVariant);
    void changeRelay(QString, QVariant);
    void updateArduinoParameters();

    void processVariable(QString data);
private:
    QVariantMap m_temperatures;
    QVariantMap m_relays;
    QString m_heatingMode;
    QVector<double> m_temperatureHistory;
    QVector<double> m_consumptionHistory;
};

#endif // HEATINGCONTROL_H
