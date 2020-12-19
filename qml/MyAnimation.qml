import QtQuick 2.11
SequentialAnimation {
    property var upEasingType: Easing.OutCirc
    property int upEasingHeight: 20
    property var downEasingType: Easing.OutBounce
    property var toX: root.width-ball.width
    property var toY: 20
    property var otherToY: rim.y-15
    property int animationDuration: rootDuration
    property int rotationNumber : 750
    property var percentageSmall: 0.27
    property var percentageLarge: 0.73
    property bool shrink: true
    ParallelAnimation {
        SequentialAnimation {
            NumberAnimation {
                target: basketBall
                properties: "y"
                to: toY
                duration: animationDuration * percentageLarge
                easing.type: upEasingType
            }
            ParallelAnimation{

                NumberAnimation {
                    target: basketBall
                    property: "width"
                    to: (shrink==true)?(72+25-10):(basketBall.width)
                    duration: animationDuration*percentageSmall
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    target: basketBall
                    property: "height"
                    to: (shrink==true)?(72+25-10):(basketBall.height)
                    duration: animationDuration*percentageSmall
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    target: basketBall
                    properties: "y"
                    to: otherToY
                    duration: animationDuration * percentageSmall
                    easing.type: downEasingType
                }
            }
        }
        NumberAnimation {
            target: basketBall
            properties: "x"
            to: toX
            duration: animationDuration
        }
        RotationAnimation{
            target: basketBall
            properties: "rotation"
            direction: RotationAnimation.Clockwise
            to: rotationNumber
            duration: animationDuration
        }
    }
    PauseAnimation{
        duration: 400
    }
}
