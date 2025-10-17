import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1C1C1C"

    property color tacticalbg: "#1C1C1C"
    property color tacticaltan: "#C3B091"
    property color tacticalolive: "#6B7A54"
    property color tacticalgray: "#2B2D2E"
    property color textcolor: "#E5D5C5"

    Rectangle {
        anchors.fill: parent
        color: tacticalbg

        Image {
            anchors.fill: parent
            source: "background.jpg"
            fillMode: Image.PreserveAspectCrop
            visible: false
        }
    }

    Rectangle {
        id: loginBox
        width: 450
        height: 520
        anchors.centerIn: parent
        color: tacticalbg
        border.color: tacticaltan
        border.width: 3
        radius: 8
        opacity: 0.95

        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width - 80
            spacing: 25

            Text {
                text: "TACTICAL SWAY"
                font.family: "monospace"
                font.pixelSize: 32
                font.bold: true
                color: tacticaltan
                Layout.alignment: Qt.AlignHCenter
                font.letterSpacing: 2
            }

            Text {
                text: "AUTHENTICATE"
                font.family: "monospace"
                font.pixelSize: 14
                color: tacticalgray
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
                font.letterSpacing: 1
            }

            TextField {
                id: usernameField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: "USERNAME"
                font.family: "monospace"
                font.pixelSize: 14
                color: textcolor
                placeholderTextColor: tacticalgray
                background: Rectangle {
                    color: tacticalbg
                    border.color: usernameField.activeFocus ? tacticaltan : tacticalgray
                    border.width: 2
                    radius: 4
                }
                text: userModel.lastUser
                KeyNavigation.backtab: passwordField
                KeyNavigation.tab: passwordField
            }

            TextField {
                id: passwordField
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                placeholderText: "PASSWORD"
                font.family: "monospace"
                font.pixelSize: 14
                color: textcolor
                placeholderTextColor: tacticalgray
                echoMode: TextInput.Password
                background: Rectangle {
                    color: tacticalbg
                    border.color: passwordField.activeFocus ? tacticaltan : tacticalgray
                    border.width: 2
                    radius: 4
                }
                KeyNavigation.backtab: usernameField
                KeyNavigation.tab: loginButton
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        loginButton.clicked()
                    }
                }
                Component.onCompleted: forceActiveFocus()
            }

            ComboBox {
                id: sessionSelect
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                model: sessionModel
                currentIndex: sessionModel.lastIndex
                textRole: "name"
                font.family: "monospace"
                font.pixelSize: 14
                background: Rectangle {
                    color: tacticalbg
                    border.color: sessionSelect.down ? tacticaltan : tacticalgray
                    border.width: 2
                    radius: 4
                }
                contentItem: Text {
                    text: sessionSelect.displayText
                    font: sessionSelect.font
                    color: textcolor
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 15
                }
                delegate: ItemDelegate {
                    width: sessionSelect.width
                    height: 40
                    background: Rectangle {
                        color: highlighted ? tacticalgray : tacticalbg
                    }
                    contentItem: Text {
                        text: model.name
                        color: textcolor
                        font.family: "monospace"
                        font.pixelSize: 14
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: 15
                    }
                    highlighted: sessionSelect.highlightedIndex === index
                }
            }

            Button {
                id: loginButton
                Layout.fillWidth: true
                Layout.preferredHeight: 55
                Layout.topMargin: 10
                text: "LOGIN"
                font.family: "monospace"
                font.pixelSize: 16
                font.bold: true
                font.letterSpacing: 2
                enabled: passwordField.text !== ""
                
                background: Rectangle {
                    color: loginButton.enabled ? (loginButton.down ? tacticalolive : tacticaltan) : tacticalgray
                    radius: 4
                    border.width: 0
                }
                
                contentItem: Text {
                    text: loginButton.text
                    font: loginButton.font
                    color: tacticalbg
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    sddm.login(usernameField.text, passwordField.text, sessionSelect.currentIndex)
                }
            }

            Text {
                id: errorMessage
                Layout.fillWidth: true
                Layout.topMargin: 5
                text: ""
                color: "#D08770"
                font.family: "monospace"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
        }
    }

    Row {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: 30
        spacing: 20

        Button {
            width: 50
            height: 50
            text: "⏻"
            font.pixelSize: 24
            ToolTip.visible: hovered
            ToolTip.text: "Shutdown"
            
            background: Rectangle {
                color: parent.down ? tacticalolive : (parent.hovered ? tacticalgray : "transparent")
                border.color: tacticaltan
                border.width: 2
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                font: parent.font
                color: tacticaltan
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: sddm.powerOff()
        }

        Button {
            width: 50
            height: 50
            text: "⟳"
            font.pixelSize: 24
            ToolTip.visible: hovered
            ToolTip.text: "Reboot"
            
            background: Rectangle {
                color: parent.down ? tacticalolive : (parent.hovered ? tacticalgray : "transparent")
                border.color: tacticaltan
                border.width: 2
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                font: parent.font
                color: tacticaltan
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: sddm.reboot()
        }

        Button {
            width: 50
            height: 50
            text: "⏾"
            font.pixelSize: 24
            ToolTip.visible: hovered
            ToolTip.text: "Suspend"
            
            background: Rectangle {
                color: parent.down ? tacticalolive : (parent.hovered ? tacticalgray : "transparent")
                border.color: tacticaltan
                border.width: 2
                radius: 4
            }
            
            contentItem: Text {
                text: parent.text
                font: parent.font
                color: tacticaltan
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            
            onClicked: sddm.suspend()
        }
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 30
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d, yyyy  •  hh:mm AP")
        font.family: "monospace"
        font.pixelSize: 16
        color: tacticaltan
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorMessage.text = "AUTHENTICATION FAILED"
            passwordField.text = ""
            passwordField.forceActiveFocus()
        }
    }
}

