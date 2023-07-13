
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

void LEDControl::updateCurrentEffect(QString newEffect)
{
   if (newEffect == m_currentEffect)
        return;

    updateShowCurrentEffect(false);
    QThread::msleep(100);
    m_ac->setVariable("current_effect", newEffect);
}

void LEDControl::setCurrentEffect(QString newEffect)
{
    m_currentEffect = newEffect;
    emit currentEffectChanged();
}

void LEDControl::updateCurrentColor(QString newColor)
{
    if (newColor == m_currentColor)
        return;

    updateShowCurrentEffect(false);
    QThread::msleep(100);
    m_ac->setVariable("current_color", newColor);
}

void LEDControl::setCurrentColor(QString newColor)
{
    m_currentColor = newColor;
    emit currentColorChanged();
}

void LEDControl::updatePresetEffects(QVector<QString> newPresetEffects)
{
    QStringList stringList;
    for (const QString& element : newPresetEffects)
        stringList.append(element);

    m_ac->setVariable("preset_effects", stringList.join(","));
}

void LEDControl::setPresetEffects(QVector<QString> newPresetEffects)
{
    m_presetEffects = newPresetEffects;
    emit presetEffectsChanged();
}

void LEDControl::updatePresetColors(QVector<QString> newPresetColors)
{
    QStringList stringList;
    for (const QString& element : newPresetColors)
        stringList.append(element);

    m_ac->setVariable("preset_colors", stringList.join(","));
}

void LEDControl::setPresetColors(QVector<QString> newPresetColors)
{
    m_presetColors = newPresetColors;
    emit presetColorsChanged();
}

void LEDControl::changePreset(int index, QString effect, QString color)
{
    if (effect != m_presetEffects[index]){
        QVector<QString> newEffects(m_presetEffects);
        newEffects[index] = effect;
        updatePresetEffects(newEffects);
    }

    if (color != m_presetColors[index]){
        QVector<QString> newColors(m_presetColors);
        newColors[index] = color;
        updatePresetColors(newColors);
    }
}

void LEDControl::updateShowCurrentEffect(bool show)
{
    if (m_showCurrentEffect == show)
        return;

    m_ac->setVariable("show_current_effect", show ? "true" : "false");
}

void LEDControl::setShowCurrentEffect(bool show)
{
    m_showCurrentEffect = show;
    emit showCurrentEffectChanged();
}

void LEDControl::updateActivePreset(int index)
{
    if (m_activePreset == index)
        return;

    m_ac->setVariable("active_preset", QString::number(index));
}

void LEDControl::setActivePreset(int index)
{
    m_activePreset = index;
    emit activePresetChanged();
}

void LEDControl::pullArduinoParameters()
{
    if (!m_ac){
        qDebug() << "Arduino communication failed.";
        return;
    }

    m_ac->getVariable("all");
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
        setCurrentEffect(value);
    } else if (id == "current_color") {
        setCurrentColor(value);
    } else if (id == "show_current_effect") {
        setShowCurrentEffect(value == "true");
    } else if (id == "active_preset") {
        setActivePreset(value.toInt());
    }
}

void LEDControl::processArrayVariable(QString id, QString value) {
    qDebug() << "LEDC to process complex data, " << id << ":" << value.split(",");
    QStringList list = value.split(",");

    if (id == "preset_effects") {
        QVector<QString> newEffects(list.begin(), list.end());
        setPresetEffects(newEffects);
    } else if (id == "preset_colors") {
        QVector<QString> newColors(list.begin(), list.end());
        setPresetColors(newColors);
    }
}
