
#include "ledcontrol.h"
#include<QDebug>
#include<QThread>

LEDControl::LEDControl(QObject *parent)
    : QObject{parent}
{
    // updateArduinoParameters()
    m_presetEffects = { "s", "f", "p", "df", "c", "o" };
    m_presetColors = { "green", "cyan", "white", "aqua", "blue", "red" };
    m_currentEffect = "wave";
    m_currentColor = "#000f0f";
    m_showCurrentEffect = false;
    m_activePreset = 0;
    pullArduinoParameters();
}

QString LEDControl::currentEffect()
{
    return m_currentEffect;
}

QString LEDControl::currentColor()
{
    return m_currentColor;
}

QVector<QString> LEDControl::presetEffects()
{
    return m_presetEffects;
}

QVector<QString> LEDControl::presetColors()
{
    return m_presetColors;
}

bool LEDControl::showCurrentEffect()
{
    return m_showCurrentEffect;
}

int LEDControl::activePreset()
{
    return m_activePreset;
}

void LEDControl::setCurrentEffect(QString newEffect)
{
//    m_showCurrentEffect = false;
//    m_currentEffect = newEffect;
//    pushArduinoParameters();

    if (newEffect == m_currentEffect)
        return;

    setShowCurrentEffect(false);
    QThread::msleep(100);
    m_ac->setVariable("current_effect", newEffect);

    emit currentEffectChanged();
}

void LEDControl::setCurrentColor(QString newColor)
{
//    m_showCurrentEffect = false;
//    m_currentColor = newColor;
//    pushArduinoParameters();

    if (newColor == m_currentColor)
        return;

    setShowCurrentEffect(false);
    QThread::msleep(100);
    m_ac->setVariable("current_color", newColor);

    emit currentColorChanged();
}

void LEDControl::setPresetEffects(QVector<QString> newPresetEffects)
{
//    m_presetEffects = newPresetEffects;
//    pushArduinoParameters();

    QStringList stringList;
    for (const QString& element : newPresetEffects)
        stringList.append(element);

    m_ac->setVariable("preset_effects", stringList.join(","));
    emit presetEffectsChanged();
}

void LEDControl::setPresetColors(QVector<QString> newPresetColors)
{
//    m_presetColors = newPresetColors;
//    pushArduinoParameters();
    QStringList stringList;
    for (const QString& element : newPresetColors)
        stringList.append(element);

    m_ac->setVariable("preset_colors", stringList.join(","));
    emit presetColorsChanged();
}

void LEDControl::changePreset(int index, QString effect, QString color)
{
//    if (index >= 0 && index < m_presetEffects.size())
//    {
//        m_presetEffects[index] = effect;
//        emit presetEffectsChanged();
//    }

//    if (index >= 0 && index < m_presetColors.size())
//    {
//        m_presetColors[index] = color;
//        emit presetColorsChanged();
//    }

    if (effect == m_presetEffects[index] && color == m_presetColors[index])
        return;

    QVector<QString> newEffects(m_presetEffects);
    newEffects[index] = effect;

    QVector<QString> newColors(m_presetColors);
    newColors[index] = color;

    setPresetEffects(newEffects);
    setPresetColors(newColors);
}

void LEDControl::setShowCurrentEffect(bool show)
{
//    m_showCurrentEffect = show;
//    pushArduinoParameters();

    if (m_showCurrentEffect == show)
        return;

    m_ac->setVariable("show_current_effect", show ? "true" : "false");

    emit showCurrentEffectChanged();
}

void LEDControl::setActivePreset(int index)
{
//    m_activePreset = index;
//    pushArduinoParameters();

    if (m_activePreset == index)
        return;

    m_ac->setVariable("active_preset", QString::number(index));

    emit activePresetChanged();
}

void LEDControl::pullArduinoParameters()
{
    qDebug() << "isnull m_ac " << !m_ac;
    if (!m_ac){
        qDebug() << "Arduino communication failed.";
        return;
    }

    m_ac->getVariable("all");
}

void LEDControl::pushArduinoParameters()
{
    qDebug() << "activePreset: " << m_activePreset << " showCurrent: " << m_showCurrentEffect << "effect: " << m_currentEffect << ", color: " << m_currentColor;
    qDebug() << "Refresh ALL LED parameeters (send update to Arduino)! TODO!";
}

void LEDControl::setAc(ArduinoCommunication *ac)
{
    m_ac = ac;
    qDebug() << "LEDC ac changed, " << ac->selectedPort();
}

void LEDControl::processVariable(QString data)
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

void LEDControl::processSimpleVariable(QString id, QString value){
    qDebug() << "LEDC to process simple data, " << id << ":" << value;
    if (id == "current_effect") {
        m_currentEffect = value;
        emit currentEffectChanged();
    } else if (id == "current_color") {
        m_currentColor = value;
        emit currentColorChanged();
    } else if (id == "show_current_effect") {
        m_showCurrentEffect = (value == "true");
        emit showCurrentEffectChanged();
    } else if (id == "active_preset") {
        m_activePreset = value.toInt();
        emit activePresetChanged();
    }
}

void LEDControl::processArrayVariable(QString id, QString value) {
    qDebug() << "LEDC to process simple data, " << id << ":" << value.split(",");
    QStringList list = value.split(",");

    if (id == "preset_effects") {
        QVector<QString> newEffects(list.begin(), list.end());
        m_presetEffects = newEffects;
        emit presetEffectsChanged();
    } else if (id == "preset_colors") {
        QVector<QString> newColors(list.begin(), list.end());
        m_presetColors = newColors;
        emit presetColorsChanged();
    }
}
