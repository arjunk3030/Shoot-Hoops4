import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtMultimedia 5.9

Item {
    z:20
    id: dialog
    anchors.fill: parent
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
            dialog.hide()
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
                settingsDialog.visible=false
                Extra.isOpen = false;
                root.volume=volumeSlider.volume
                root.sound=soundSlider.sound
            }
        }

        //            x: Math.round((705 - width) / 2)
        //            y: 130
        //            y: Math.round(785 / 6)
        //            width: Math.round(Math.min(705, 785) /3 * 2)
        width: 620
        height: 550
        focus: true
        Timer{
            id: delayTimerVolume
            interval: 1
            onTriggered: {
                volumeSlider.value=root.volume
                soundSlider.value=root.sound
            }
        }
        ColumnLayout {
            id: settingsColumn
            spacing: 80
            y:15
            Text{
                width: 400
                text: "          Settings                      "
                font.family: bodoniMTBlack.name
                wrapMode: Label.Wrap
                font.pixelSize: 50
                font.bold:true;
                id: setttingsTitle
            }
            Rectangle{
                color: "white"
                height: 20
                width:parent.width
                IconButtonBarItem{
                    anchors.verticalCenter: parent.verticalCenter
                    x:10
                    visible:true
                    color: "black"
                    id: musicVolumeIcon
                    icon: (volume<0.45)?((volume<0.02)?IconType.volumeoff:IconType.volumeoff):IconType.volumeup
                    iconSize: 50
                    Rectangle{
                        anchors.centerIn: parent
                        width: 50
                        height:width
                        color:"transparent"
                        MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                musicVolumeIcon.icon=IconType.volumeoff
                                volume=0.0;
                                volumeSlider.value=0
                                shouldExtraVolumeChange=false
                                volumeSlider.valueChanged();

                                //nobody knows why but do it twice
                                musicVolumeIcon.icon=IconType.volumeoff
                                volume=0.0;
                                volumeSlider.value=0
                                shouldExtraVolumeChange=false
                                volumeSlider.valueChanged();
                            }
                        }
                    }
                }
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    x:98
                    text: "Music:"
                    font.pointSize: textMultiplier* 22
                    font.bold: true
                    id: musicText
                }
                AppSlider {
                    anchors.verticalCenter: parent.verticalCenter
                    Component.onCompleted:{
                        root.volume = volumeSlider.volume
                        if(!delayTimerVolume.running)
                            delayTimerVolume.start()
                        x=musicText.width+musicText.x+18
                    }
                    x:musicText.width+musicText.x+18
                    from: 0
                    to: 1
                    handle:Rectangle{
                        x: volumeSlider.leftPadding  + volumeSlider.visualPosition * (volumeSlider.availableWidth - width)
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        implicitWidth: volumeSlider.pressed ? 34: 28
                        implicitHeight: volumeSlider.pressed ? 34: 28
                        radius: volumeSlider.pressed ? 34: 28
                        color: volumeSlider.pressed ? "#233ab8" : "#3F51B5"
                        border.color:  volumeSlider.pressed ? "#233ab8" : "#3F51B5"
                    }
                    background: Rectangle {
                        x: volumeSlider.leftPadding
                        y: volumeSlider.topPadding + volumeSlider.availableHeight / 2 - height / 2
                        implicitWidth: 320
                        implicitHeight: 14
                        width: volumeSlider.availableWidth
                        height: implicitHeight
                        radius: 12
                        color: "#7C7C7C"
                        Rectangle {
                            width: volumeSlider.visualPosition * parent.width
                            height: parent.height
                            color: "#3F51B5"
                            radius: 12
                        }
                    }
                    id: volumeSlider
                    onValueChanged: {
                        if(value<0.05){
                            value = 0.0
                            value = 0.0
                            if(!(musicVolumeIcon.icon===IconType.volumeoff)){
                                musicVolumeIcon.icon=IconType.volumeoff
                            }
                        }
                        else if(value<0.45){
                            if(!(musicVolumeIcon.icon===IconType.volumedown)){
                                musicVolumeIcon.icon=IconType.volumedown
                            }
                        }
                        else {
                            if(!(musicVolumeIcon.icon===IconType.volumeup)){
                                musicVolumeIcon.icon=IconType.volumeup
                            }
                        }
                        if(shouldExtraVolumeChange){
                            root.volume=volumeSlider.volume
                        }
                        else
                            shouldExtraVolumeChange=true
                    }
                    value: QtMultimedia.convertVolume(root.volume,QtMultimedia.LinearVolumeScale,QtMultimedia.LogarithmicVolumeScale);
                    property real volume: QtMultimedia.convertVolume(volumeSlider.value,
                                                                     QtMultimedia.LogarithmicVolumeScale, QtMultimedia.LinearVolumeScale)
                }
            }

            Rectangle{
                color: "white"
                height: 20
                width:parent.width
                IconButtonBarItem{
                    x:10
                    anchors.verticalCenter: parent.verticalCenter;
                    visible:true
                    color: "black"
                    id: musicSoundIcon
                    icon: (sound<0.45)?((sound<0.02)?IconType.volumeoff:IconType.volumeoff):IconType.volumeup
                    iconSize: 50
                    Rectangle{
                        anchors.centerIn: parent
                        width: 40
                        height:width
                        color:"transparent"
                        MouseArea{
                            anchors.fill: parent
                            onClicked:{
                                musicSoundIcon.icon=IconType.volumeoff
                                sound=0.0;
                                soundSlider.value=0
                                shouldExtraSoundChange=false
                                soundSlider.valueChanged();

                                //nobody knows why but do it twice
                                musicSoundIcon.icon=IconType.volumeoff
                                sound=0.0;
                                soundSlider.value=0
                                shouldExtraSoundChange=false
                                soundSlider.valueChanged();
                            }
                        }
                    }
                }
                Label{
                    anchors.verticalCenter: parent.verticalCenter
                    x:98
                    text: "Sound:"
                    font.pointSize: textMultiplier* 22
                    font.bold: true
                    id: soundText
                }
                AppSlider {
                    anchors.verticalCenter: parent.verticalCenter
                    Component.onCompleted:{
                        root.volume = volumeSlider.volume
                        if(!delayTimerVolume.running)
                            delayTimerVolume.start()
                        x=soundText.width+soundText.x+18
                    }
                    x:soundText.width+soundText.x+18
                    id: soundSlider
                    from: 0
                    to: 1
                    handle:Rectangle{
                        x: soundSlider.leftPadding + soundSlider.visualPosition * (soundSlider.availableWidth - width)
                        y: soundSlider.topPadding + soundSlider.availableHeight / 2 - height / 2
                        implicitWidth: soundSlider.pressed ? 34: 28
                        implicitHeight: soundSlider.pressed ? 34: 28
                        radius: soundSlider.pressed ? 34: 28
                        color: soundSlider.pressed ? "#233ab8" : "#3F51B5"
                        border.color:  soundSlider.pressed ? "#233ab8" : "#3F51B5"
                    }
                    background: Rectangle {
                        x: soundSlider.leftPadding
                        y: soundSlider.topPadding + soundSlider.availableHeight / 2 - height / 2
                        implicitWidth: 320
                        implicitHeight: 14
                        width: soundSlider.availableWidth
                        height: implicitHeight
                        radius: 12
                        color: "#7C7C7C"
                        Rectangle {
                            width: soundSlider.visualPosition * parent.width
                            height: parent.height
                            color: "#3F51B5"
                            radius: 12
                        }
                    }
                    onValueChanged: {
                        if(value<0.05){
                            sound = 0.0
                            sound = 0.0
                            if(!(musicSoundIcon.icon===IconType.volumeoff)){
                                musicSoundIcon.icon=IconType.volumeoff
                            }
                        }
                        else if(value<0.45){
                            if(!(musicSoundIcon.icon===IconType.volumedown)){
                                musicSoundIcon.icon=IconType.volumedown
                            }
                        }
                        else {
                            if(!(musicSoundIcon.icon===IconType.volumeup)){
                                musicSoundIcon.icon=IconType.volumeup
                            }
                        }
                        if(shouldExtraSoundChange){
                            root.sound=soundSlider.sound
                        }
                        else
                            shouldExtraSoundChange=true
                    }
                    value: QtMultimedia.convertVolume(root.sound,QtMultimedia.LinearVolumeScale,QtMultimedia.LogarithmicVolumeScale);
                    property real sound: QtMultimedia.convertVolume(soundSlider.value,
                                                                    QtMultimedia.LogarithmicVolumeScale, QtMultimedia.LinearVolumeScale)
                }
            }
            Rectangle{
                width: 3
                height: 38-soundSlider.implicitHeight
            }
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
    Settings{
        property alias volumeSliderValueSettings: volumeSlider.value
        property alias volumeSliderVolumeSettings: volumeSlider.volume
        property alias soundSliderValueSettings: soundSlider.value
        property alias soundSliderSoundSettings: soundSlider.sound
    }
}
