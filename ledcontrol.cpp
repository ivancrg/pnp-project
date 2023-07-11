
#include "ledcontrol.h"
#include<QDebug>

LEDControl::LEDControl(QObject *parent)
    : QObject{parent}
{
    // updateArduinoParameters()
    m_presetEffects = { "static", "flash", "pulse", "double_flash", "cycle", "lightbulb_off" };
    m_presetColors = { "green", "cyan", "white", "aqua", "blue", "red" };
    m_currentEffect = "wave";
    m_currentColor = "#00ff00";
    m_showCurrentEffect = false;
    m_activePreset = 0;
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
    m_showCurrentEffect = false;
    m_currentEffect = newEffect;
    updateArduinoParameters();
    emit currentEffectChanged();
}

void LEDControl::setCurrentColor(QString newColor)
{
    m_showCurrentEffect = false;
    m_currentColor = newColor;
    updateArduinoParameters();
    emit currentColorChanged();
}

void LEDControl::setPresetEffects(QVector<QString> newPresetEffects)
{
    m_presetEffects = newPresetEffects;
    updateArduinoParameters();
    emit presetEffectsChanged();
}

void LEDControl::setPresetColors(QVector<QString> newPresetColors)
{
    m_presetColors = newPresetColors;
    updateArduinoParameters();
    emit presetColorsChanged();
}

void LEDControl::changePreset(int index, QString effect, QString color)
{
    if (index >= 0 && index < m_presetEffects.size())
    {
        m_presetEffects[index] = effect;
        emit presetEffectsChanged();
    }

    if (index >= 0 && index < m_presetColors.size())
    {
        m_presetColors[index] = color;
        emit presetColorsChanged();
    }

    updateArduinoParameters();
}

void LEDControl::setShowCurrentEffect(bool show)
{
    m_showCurrentEffect = show;
    updateArduinoParameters();
    emit showCurrentEffectChanged();
}

void LEDControl::setActivePreset(int index)
{
    m_activePreset = index;
    updateArduinoParameters();
    emit activePresetChanged();
}

void LEDControl::updateArduinoParameters()
{
    qDebug() << "activePreset: " << m_activePreset << " showCurrent: " << m_showCurrentEffect << "effect: " << m_currentEffect << ", color: " << m_currentColor;
    qDebug() << "Refresh ALL LED parameeters (send update to Arduino)! TODO!";
}

