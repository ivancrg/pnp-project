
#include "heatingcontrol.h"

#include<QDebug>
#include<QVariant>
#include <QThread>

HeatingControl::HeatingControl(QObject *parent)
    : QObject{parent}
{
    // updateArduinoParameters();
    m_temperatures["room"] = QVariant(12.3);
    m_temperatures["release"] = 34.5;
    m_temperatures["return"] = 23.4;
    m_temperatures["p_room"] = 22.0;
    m_temperatures["p_room_int"] = 34.5;
    m_temperatures["p_heater_1_delta"] = 3.5;
    m_temperatures["p_heater_2_delta"] = 7.5;
    m_temperatures["p_pump_delta"] = 5.5;
    m_relays["heater_1"] = false;
    m_relays["heater_2"] = true;
    m_relays["pump"] = false;
    m_heatingMode = "rapid_mode";
    m_temperatureHistory = {24, 23, 24, 24, 22, 23, 22, 23, 22, 23, 22, 24, 24, 23, 24, 23, 22, 24, 22, 27};
    m_consumptionHistory = {1994, 1987, 1981, 1972, 1966, 2000, 1990, 1965, 1986, 1969, 1989, 1974, 1989, 1973, 1997, 1998, 1999, 1990, 1986, 1984};
    pullArduinoParameters();
}

QVariantMap HeatingControl::temperatures()
{
    return m_temperatures;
}

QVariantMap HeatingControl::relays()
{
    return m_relays;
}

QString HeatingControl::heatingMode()
{
    return m_heatingMode;
}

QVector<double> HeatingControl::temperatureHistory()
{
    return m_temperatureHistory;
}

QVector<double> HeatingControl::consumptionHistory()
{
    return m_consumptionHistory;
}

void HeatingControl::updateTemperature(QString id, double temperature)
{
    if (m_temperatures[id] == temperature)
        return;

    m_ac->setVariable(id, QString::number(temperature));
}

void HeatingControl::setTemperatures(QVariantMap newTemperatures)
{
    m_temperatures = newTemperatures;
    emit temperaturesChanged();
}

void HeatingControl::updateRelay(QString id, bool relay)
{
    QThread::msleep(2000);
    if (m_relays[id] == relay)
        return;

    m_ac->setVariable(id, (relay ? "true" : "false"));
}

void HeatingControl::setRelays(QVariantMap newRelays)
{
    m_relays = newRelays;
    emit relaysChanged();
}

void HeatingControl::updateHeatingMode(QString newMode)
{
    if (newMode == m_heatingMode)
        return;

    m_ac->setVariable("heating_mode", newMode);

    QThread::msleep(2000);
}

void HeatingControl::setHeatingMode(QString newMode)
{
    m_heatingMode = newMode;
    emit heatingModeChanged();
}

void HeatingControl::setTemperatureHistory(QVector<double> newTemperatureHistory)
{
    m_temperatureHistory = newTemperatureHistory;
    emit temperatureHistoryChanged();
}

void HeatingControl::setConsumptionHistory(QVector<double>newConsumptionHistory)
{
    m_consumptionHistory = newConsumptionHistory;
    emit consumptionHistoryChanged();
}

void HeatingControl::setAc(ArduinoCommunication *ac)
{
    m_ac = ac;
    qDebug() << "HeatingC ac changed, " << ac->selectedPort();
}

void HeatingControl::processVariable(QString data)
{
    QChar q = data.at(0);
    data = data.removeFirst();

    QStringList args = data.split(":");
    if (args.length() < 2) return;

    QString id = args[0];
    QString value = args[1].trimmed();

    if (q == '-')
        processSimpleVariable(id, value);
    else
        processArrayVariable(id, value);
}

void HeatingControl::processSimpleVariable(QString id, QString value){
    qDebug() << "HeatingC to process simple data, " << id << ":" << value;
    if (id == "room" || id == "release" || id == "return" || id == "p_room"
        || id == "p_room_int" || id == "p__heater_1_delta"
        || id == "p_heater_2_delta" || id == "p_pump_delta") {
        QVariantMap newTemperatures = m_temperatures;
        newTemperatures[id] = value.toDouble();
        setTemperatures(newTemperatures);
    } else if (id == "heater_1" || id == "heater_2" || id == "pump") {
        QVariantMap newRelays = m_relays;
        newRelays[id] = (value == "true");
        setRelays(newRelays);
    } else if (id == "heating_mode") {
        setHeatingMode(value);
    }
}

void HeatingControl::processArrayVariable(QString id, QString value) {
    qDebug() << "HeatingC not valid for processing complex data, " << id << ":" << value.split(",");
}

void HeatingControl::pullArduinoParameters()
{
    if (!m_ac){
        qDebug() << "Arduino communication failed.";
        return;
    }

    m_ac->getVariable("all");
}
