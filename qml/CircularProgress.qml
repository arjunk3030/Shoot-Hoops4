import QtQml 2.2
import QtQuick 2.0
import Felgo 3.0
// draws two arcs (portion of a circle)
// fills the circle with a lighter secondary color
// when pressed
Canvas {
    id: canvas
    width: 400
    height: 400
    antialiasing: true
    property color primaryColor: "#e6e8f0"
    property color secondaryColor: "#18549e"

    property real centerWidth: width / 2
    property real centerHeight: height / 2
    property real radius: Math.min(canvas.width, canvas.height) / 2-30

    property real minimumValue: 0
    property real maximumValue: 100
    property real currentValue: 100
    // this is the angle that splits the circle in two arcs
    // first arc is drawn from 0 radians to angle radians
    // second arc is angle radians to 2*PI radians
    property real angle: (currentValue - minimumValue) / (maximumValue - minimumValue) * 2 * Math.PI

    // we want both circle to start / end at 12 o'clock
    // without this offset we would start / end at 9 o'clock
    property real angleOffset: -Math.PI / 2

    property string text: "Text"

    signal clicked()

    onPrimaryColorChanged: requestPaint()
    onSecondaryColorChanged: requestPaint()
    onMinimumValueChanged: requestPaint()
    onMaximumValueChanged: requestPaint()
    onCurrentValueChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d");
        ctx.save();

        ctx.clearRect(0, 0, canvas.width, canvas.height);

        // fills the mouse area when pressed
        // the fill color is a lighter version of the
        // secondary color

        //        if (mouseArea.pressed) {
        //            ctx.beginPath();
        //            ctx.lineWidth = 1;
        //            ctx.fillStyle = Qt.lighter(canvas.secondaryColor, 1.25);
        //            ctx.arc(canvas.centerWidth,
        //                    canvas.centerHeight,
        //                    canvas.radius,
        //                    0,
        //                    2*Math.PI);
        //            ctx.fill();
        //        }

        // First, thinner arc
        // From angle to 2*PI

        ctx.beginPath();
        ctx.lineWidth = 40;
        ctx.strokeStyle = primaryColor;
        ctx.arc(canvas.centerWidth,
                canvas.centerHeight,
                canvas.radius,
                angleOffset + canvas.angle,
                angleOffset + 2*Math.PI);
        ctx.stroke();


        // Second, thicker arc
        // From 0 to angle

        ctx.beginPath();
        ctx.lineWidth = 40;
        ctx.strokeStyle = canvas.secondaryColor;
        ctx.arc(canvas.centerWidth,
                canvas.centerHeight,
                canvas.radius,
                canvas.angleOffset,
                canvas.angleOffset + canvas.angle);
        ctx.stroke();

        ctx.restore();
    }


    //    Rectangle{
    //        anchors.centerIn: parent
    //        color: "black"
    //        width: 30
    //        height: 30
    //    }
    SequentialAnimation{
        id: beatingHeartAnim
        onStopped: {
            if(visible)
                start()
        }
        PropertyAnimation{
            target:heartIcon
            property: "iconSize"
            from: 255
            to: 225
            duration: 700
        }
        PropertyAnimation{
            target:heartIcon
            property: "iconSize"
            from: 225
            to: 255
            duration: 600
        }
    }
    Rectangle{
        width: heartIcon.width
        height: heartIcon.height
        visible: heartIcon.visible
        anchors.centerIn: heartIcon
        color: "transparent"
        MouseArea{
            anchors.fill: parent
            enabled: parent.visible
            onClicked:{
                newMissionsAdButton.clicked()
            }
        }
        z:15
    }
    Image{
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        width: 50
        height: 50
        source: "../assets/images/coinFrontTranslucent.png"
    }
    Image{
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 15
        width: 50
        height: 50
        source: "../assets/images/coinFrontTranslucent.png"
    }
    Image{
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15
        width: 50
        height: 50
        source: "../assets/images/coinFrontTranslucent.png"
    }
    Image{
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.right: parent.right
        anchors.rightMargin: 15
        width: 50
        height: 50
        source: "../assets/images/coinFrontTranslucent.png"
    }
    IconButtonBarItem{
        z:10
        onVisibleChanged: {
            if(visible){
                beatingHeartAnim.start()
                circleTimer.start()
            }
        }
        visible:true
        color: "red"
        id: heartIcon
        icon: IconType.heart
        iconSize: 255
        anchors.centerIn: parent
        MouseArea{
            anchors.fill: parent
            enabled: heartIcon.visible
            onClicked:{
                newMissionsAdButton.clicked()
            }
        }
    }
    MouseArea{
        z:11
        anchors.fill: parent
        enabled: heartIcon.visible
        onClicked:{
            newMissionsAdButton.clicked()
        }
    }
    MouseArea {
        z:11
        id: mouseArea
        anchors.fill: parent
        onClicked: canvas.clicked()
        onPressedChanged: canvas.requestPaint()
    }
    Timer{
        id: circleTimer
        interval: 15
        onTriggered: {
            if(canvas.currentValue<=0){
                if(quitButtonWasClicked){
                    quitButtonWasClicked=false
                }
                else{
                    afterGameIsActuallyOver()
                    newRetryCircle.visible=false
                    newFadedRed.visible=false
                    retryBox.visible=true;
                    retryScreenHappening=true
                }
                canvas.currentValue=100
                circleTimer.stop();
            }
            else{
                canvas.currentValue-=0.25
                start()
            }
        }
    }
}


