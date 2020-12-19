import QtQuick 2.0
import Lebron2 1.0
import QtQml.Models 2.2
import Felgo 3.0
import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import Qt.labs.settings 1.0
import QtQuick.Controls 2.12
import QtMultimedia 5.8

Slider{
    property var chaosDuration: 1200
    property var chaosSliderEasingType: Easing.Linear
    Connections {
        target: Extra
        function onChaosSliderNeedsChange() {
            if(easingNumber < 4 && easingNumber>=0){
                chaosDuration -= 150
            }
            easingNumber = Math.floor((Math.random() * 24));
            if(easingNumber<4){
                chaosDuration += 150;
            }
            chaosDuration-=Math.random()*170+30
            let options = [Easing.OutInBounce, Easing.InOutBounce, Easing.OutBounce,Easing.InBounce, Easing.OutElastic, Easing.InQuad, Easing.OutQuad, Easing.InOutCubic, Easing.OutCubic, Easing.InQuart, Easing.OutQuart, Easing.OutQuint, Easing.InOutQuint, Easing.InSine, Easing.OutSine, Easing.InExpo, Easing.OutInExpo, Easing.InCirc, Easing.OutCirc, Easing.OutInCirc, Easing.OutBack, Easing.OutInBack, Easing.InBack, Easing.BezierCurve]
            chaosSliderEasingType=options[Math.floor((Math.random() * 28))];
            sliderId.value=200;
            insideTheSliderRectangleMouseArea.enabled = true
        }
    }
    onValueChanged: {
        if(firstTime2){
            if(value===1){
                counterio=1;
            }
            if(counterio ==1 && value===500.5){
                seqAnimationId.stop();
            }
        }
        else{
            if(value===1)
            {
                seqAnimationId.restart()
            }
        }
    }
    id: sliderId
    from: 1;
    to: 1000;
    value: 200;
    width: 480;
    height: 30;
    enabled:false;
    MouseArea{
        id: insideTheSliderRectangleMouseArea
        enabled: false;
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: {
            whatToDoInsideRectangleMA()
            if(level===3){
                enabled=false
                mouse.accepted.false
            }
        }
        onDoubleClicked:{
            mouse.accepted=false;
        }
    }
    background: Rectangle{
        implicitHeight: 6
        height: implicitHeight
        radius: 8
        gradient: Gradient{
            orientation: Gradient.Horizontal
            GradientStop{position: 0.0; color: "#cf3732"}
            GradientStop{position: 0.2; color:"#db8d44"}
            GradientStop{position: 0.35; color:"#e3d430"}
            GradientStop{position: 0.5; color:"#29c910"}
            GradientStop{position: 0.65; color:"#e3d430"}
            GradientStop{position: 0.8; color:"#db8d44"}
            GradientStop{position:1.0; color:"#cf3732"}
        }
        Rectangle {
            height: parent.height
            color: "#21be2b"
            radius: 3
        }
    }
    handle: Rectangle {
        id: handleId
        x: sliderId.leftPadding + sliderId.visualPosition * (sliderId.availableWidth - width)
        y: sliderId.topPadding + sliderId.availableHeight / 2 - height / 2
        implicitWidth: 20
        implicitHeight: 50
        radius: 7
        color: sliderId.pressed ? "#f0f0f0" : "#ededed"
        border.color: "#9e9e9e"
    }
    SequentialAnimation{
        id: seqAnimationIdNEW
        running:seqAnimationId.running
        NumberAnimation {
            target: sliderId
            property: "value"
            to:1000
            duration: chaosDuration
            easing.type: chaosSliderEasingType
        }
        NumberAnimation {
            target: sliderId
            property: "value"
            to:0
            duration: chaosDuration
            easing.type: chaosSliderEasingType

        }
    }
}

