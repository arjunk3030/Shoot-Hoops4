import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.9


Item {
    z:20
anchors.fill: parent
    id: dialog
    // we need to disable this item if it is invisible, then all the contained MouseAreas are also disabled
    enabled: visible
    // by default, the dialog is invisible
    visible: false
    // alias to access the box
    property alias box: box

    // property to make this dialog modal and prevents selecting anything behind it
    property bool modal: false

    // signals emitted if a button has been pressed
    signal selectedOk
    signal selectedCancel

    // show function
    function show() {
        // set the dialog visible to enable it and start show animation
        dialog.visible = true
        showAnimation.start()
    }

    // hide function
    function hide() {
        // start hide animation, the dialog will be set invisible once the animation has finished
        hideAnimation.start()
    }

    // this component prevents selecting anything behind the dialog, only enabled if it's a modal dialog
    MouseArea {
        anchors.fill: parent
        enabled: dialog.modal
        onClicked: {
            hide()
        }
    }

    // visible overlay, only visible if it's a modal dialog
    Rectangle {
        id: overlay
        visible: dialog.modal
        anchors.fill: parent
        color: "#000"
    }

    // the box containing dialog text and buttons
    Rectangle {
        MouseArea{
            anchors.fill: parent
            enabled: dialog.modal
        }
        id: box
        color: "white"
        border.width: 1
        border.color: "black"
        radius: 10
        anchors.centerIn: parent
        onVisibleChanged: {
            if(visible){
                Extra.isOpen = true;
            }
            else{
                confirmMessage.visible=false
                Extra.isOpen = false;
            }
        }

        //            x: Math.round((705 - width) / 2)
        //            y: 130
        //            y: Math.round(785 / 6)
        //            width: Math.round(Math.min(705, 785) /3 * 2)
        width: 630
        height: 330
        focus: true
        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            x:20
            y:20
            width: box.width-20
            text: "Confirmation"
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            wrapMode: Label.Wrap
            font.pointSize: textMultiplier* 20
            font.family: bodoniMTBlack.name
        }

        Label {
            x:20
            y:60
            anchors.horizontalCenter: parent.horizontalCenter
            width: box.width-20
            text: "Are you sure you want to purchase this?"
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
            wrapMode: Label.Wrap
            font.pointSize: textMultiplier* 16.5
            font.family: centuryGothic.name
        }
        Button {
            Rectangle{
                anchors.fill: parent
                color: okButton.pressed?"#233ab8" : "#3F51B5"
            }
            Text{
                anchors.centerIn: parent
                font.pointSize: textMultiplier* 20
                text: "Ok"
                color: "White"
                font.family: centuryGothic.name
            }
            id: okButton
            width: templateButton.width+140
            height: templateButton.height+38
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            onClicked: {
                // emit signal and hide dialog if button is selected
                dialog.selectedOk()
                dialog.hide()
            }
        }
        Button {
            Rectangle{
                anchors.fill: parent
                color: cancelButton.pressed?"#233ab8" : "#3F51B5"
            }
            Text{
                anchors.centerIn: parent
                font.pointSize: textMultiplier* 20
                text: "Cancel"
                color: "White"
                font.family: centuryGothic.name
            }
            id: cancelButton
            width: templateButton.width+140
            height: templateButton.height+38
            anchors.right: okButton.left
            anchors.rightMargin: 30
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            onClicked: {
                // emit signal and hide dialog if button is selected
                dialog.selectedCancel()
                dialog.hide()
            }
        }
        Button{
            visible: false
            id: templateButton
        }
    }

    // animation to show the dialog
    ParallelAnimation {
        id: showAnimation
        NumberAnimation {
            target: box
            property: "scale"
            from: 0
            to: 1
            easing.type: Easing.OutBack
            duration: 250
        }
        NumberAnimation {
            target: overlay
            property: "opacity"
            from: 0
            to: 0.2
            duration: 250
        }
    }

    // animation to hide the dialog
    ParallelAnimation {
        id: hideAnimation
        NumberAnimation {
            target: box
            property: "scale"
            from: 1
            to: 0
            easing.type: Easing.InBack
            duration: 250
        }
        NumberAnimation {
            target: overlay
            property: "opacity"
            from: 0.2
            to: 0
            duration: 250
        }
        onStopped: {
            // set it invisible when the animation has finished to disable MouseAreas again
            dialog.visible = false
        }
    }
}
