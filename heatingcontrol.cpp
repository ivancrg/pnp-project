
#include "heatingcontrol.h"

#include<QDebug>
#include<QVariant>

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

void HeatingControl::setTemperatures(QVariantMap newTemperatures)
{
    m_temperatures = newTemperatures;
    updateArduinoParameters();
    emit temperaturesChanged();
}

void HeatingControl::setRelays(QVariantMap newRelays)
{
    m_relays = newRelays;
    updateArduinoParameters();
    emit relaysChanged();
}

void HeatingControl::setHeatingMode(QString newMode)
{
    m_heatingMode = newMode;
    updateArduinoParameters();
    emit heatingModeChanged();
}

void HeatingControl::setTemperatureHistory(QVector<double> newTemperatureHistory)
{
    m_temperatureHistory = newTemperatureHistory;
    updateArduinoParameters();
    emit temperatureHistoryChanged();
}

void HeatingControl::setConsumptionHistory(QVector<double>newConsumptionHistory)
{
    m_consumptionHistory = newConsumptionHistory;
    updateArduinoParameters();
    emit consumptionHistoryChanged();
}

void HeatingControl::changeTemperature(QString key, QVariant value)
{
    m_temperatures[key] = value;
    updateArduinoParameters();
    emit temperaturesChanged();
}

void HeatingControl::changeRelay(QString key, QVariant value)
{
    m_relays[key] = value;
    updateArduinoParameters();
    emit relaysChanged();
}

void HeatingControl::updateArduinoParameters()
{
    qDebug() << m_relays << Qt::endl << m_temperatures;
    qDebug() << "Refresh ALL HEATING parameeters (send update to Arduino)! TODO!";
}

void HeatingControl::processVariable(QString data)
{
    QStringList args = data.split(":");
    if (args.length() < 2) return;

    QString id = args[0];
    QString value = args[1].trimmed();
    qDebug() << "HeatingControl to process data, " << id << ":" << value;
}
