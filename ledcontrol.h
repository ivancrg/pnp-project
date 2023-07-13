
#ifndef LEDCONTROL_H
#define LEDCONTROL_H

#include <QObject>
#include <arduinocommunication.h>

class LEDControl : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString currentEffect READ currentEffect WRITE setCurrentEffect NOTIFY currentEffectChanged)
    Q_PROPERTY(QString currentColor READ currentColor WRITE setCurrentColor NOTIFY currentColorChanged)
    Q_PROPERTY(QVector<QString> presetEffects READ presetEffects WRITE setPresetEffects NOTIFY presetEffectsChanged)
    Q_PROPERTY(QVector<QString> presetColors READ presetColors WRITE setPresetColors NOTIFY presetColorsChanged)
    Q_PROPERTY(bool showCurrentEffect READ showCurrentEffect WRITE setShowCurrentEffect NOTIFY showCurrentEffectChanged)
    Q_PROPERTY(int activePreset READ activePreset WRITE setActivePreset NOTIFY activePresetChanged)

public:
    explicit LEDControl(QObject *parent = nullptr);
    QString currentEffect();
    QString currentColor();
    QVector<QString> presetEffects();
    QVector<QString> presetColors();
    bool showCurrentEffect();
    int activePreset();

signals:
    void currentEffectChanged();
    void currentColorChanged();
    void presetEffectsChanged();
    void presetColorsChanged();
    void showCurrentEffectChanged();
    void activePresetChanged();

public slots:
    void setCurrentEffect(QString);
    void setCurrentColor(QString);
    void setPresetEffects(QVector<QString>);
    void setPresetColors(QVector<QString>);
    void changePreset(int, QString, QString);
    void setShowCurrentEffect(bool);
    void setActivePreset(int);
    void pullArduinoParameters();
    void setAc(ArduinoCommunication *);
    void processVariable(QString);
    void processSimpleVariable(QString, QString);
    void processArrayVariable(QString, QString);
    void updateCurrentEffect(QString newEffect);
    void updateCurrentColor(QString newColor);
    void updatePresetEffects(QVector<QString> newPresetEffects);
    void updatePresetColors(QVector<QString> newPresetColors);
    void updateShowCurrentEffect(bool show);
    void updateActivePreset(int index);

private slots:

private:
    QString m_currentEffect;
    QString m_currentColor;
    QVector<QString> m_presetEffects;
    QVector<QString> m_presetColors;
    bool m_showCurrentEffect;
    int m_activePreset;
    ArduinoCommunication *m_ac;
};

#endif // LEDCONTROL_H
