import QtQuick
import QtQuick.Dialogs

Item {
    function refreshEffect() {
        // For static and off effects
        currentAnimation.stop();

        preview.iconColor = effectColor;
        preview.opacity = 1;

        switch (effectName) {
        case "p":
            currentAnimation = pulseAnimation;
            break;
        case "f":
            currentAnimation = flashAnimation;
            break;
        case "df":
            currentAnimation = doubleFlashAnimation;
            break;
        case "c":
            currentAnimation = cycleAnimation;
            break;
        case "w":
            currentAnimation = waveAnimation;
            break;
        case "o":
            preview.opacity = 0;
            break;
        }

        if (effectName !== "s" && effectName !== "o") {
            currentAnimation.start()
        }
    }

    id: root

    property string effectName: "s"
    property string effectColor: "#000000"
    property SequentialAnimation currentAnimation: waveAnimation

    onEffectNameChanged: refreshEffect()
    onEffectColorChanged: refreshEffect()

    CustomIcon {
        id: preview
        anchors.centerIn: parent
        iconWidth: parent.width
        iconHeight: parent.height
        iconColor: effectColor
        iconSource: "qrc:/icons/lightbulb.svg"
    }

    // Pulse animation
    SequentialAnimation {
        id: pulseAnimation
        loops: Animation.Infinite

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 0; to: 1; duration: 850
            easing.type: Easing.InQuad
        }

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 1; to: 0; duration: 850
            easing.type: Easing.OutQuad
        }


        PauseAnimation { duration: 500 }
    }

    // Flash animation
    SequentialAnimation {
        id: flashAnimation
        loops: Animation.Infinite

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 0; to: 1; duration: 200
            easing.type: Easing.InExpo
        }

        PauseAnimation { duration: 200 }

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 1; to: 0; duration: 200
            easing.type: Easing.OutExpo
        }
    }

    // Double flash animation
    SequentialAnimation {
        id: doubleFlashAnimation
        loops: Animation.Infinite

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 0; to: 1; duration: 150
            easing.type: Easing.InExpo
        }

        PauseAnimation { duration: 25 }

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 1; to: 0; duration: 150
            easing.type: Easing.OutExpo
        }

        PauseAnimation { duration: 75 }

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 0; to: 1; duration: 150
            easing.type: Easing.InExpo
        }

        PauseAnimation { duration: 25 }

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 1; to: 0; duration: 150
            easing.type: Easing.OutExpo
        }

        PauseAnimation { duration: 350 }
    }

    // Cycle animation
    SequentialAnimation {
        id: cycleAnimation
        loops: Animation.Infinite

        ColorAnimation { target: preview; duration: 750; property: "iconColor"; from: "red"; to: "orange" }
        ColorAnimation { target: preview; duration: 750; property: "iconColor"; from: "orange"; to: "yellow" }
        ColorAnimation { target: preview; duration: 750; property: "iconColor"; from: "yellow"; to: "green" }
        ColorAnimation { target: preview; duration: 750; property: "iconColor"; from: "green"; to: "aqua" }
        ColorAnimation { target: preview; duration: 750; property: "iconColor"; from: "aqua"; to: "blue" }
        ColorAnimation { target: preview; duration: 750; property: "iconColor"; from: "blue"; to: "indigo" }
        ColorAnimation { target: preview; duration: 750; property: "iconColor"; from: "indigo"; to: "violet" }
        ColorAnimation { target: preview; duration: 750; property: "iconColor"; from: "violet"; to: "red" }
    }

    // Wave animation
    SequentialAnimation {
        id: waveAnimation
        loops: Animation.Infinite

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 0.15; to: 1; duration: 950
            easing.type: Easing.InCubic
        }

        PropertyAnimation {
            target: preview
            property: "opacity"; from: 1; to: 0.15; duration: 950
            easing.type: Easing.OutCubic
        }

        PauseAnimation { duration: 500 }
    }
}
