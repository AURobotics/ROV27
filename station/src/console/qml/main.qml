import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window

    visible: true
    width: 1200
    height: 760
    minimumWidth: 900
    minimumHeight: 600
    title: "Camera Workspace"

    color: '#0e1832'

    header: ToolBar {
        height: 66
        background: Rectangle {
            color: "#111827"
            border.color: "#1F2937"
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            spacing: 24

            Label {
                text: "CAMERA WORKSPACE"
                color: "#F8FAFC"
                font.pixelSize: 16
                font.bold: true
            }

            TabBar {
                id: tabs
                Layout.fillWidth: true
                Layout.fillHeight: true

                background: Rectangle {
                    color: "transparent"
                
                }

                TabButton {
                    text: "Workspace"
                    width: 150
                }

                TabButton {
                    text: "Monitoring"
                    width: 150
                }

                TabButton {
                    text: "Settings"
                    width: 150
                }
            }
            Label {
                text: "●  SYSTEM READY :)"
                color: "#34D399"
                font.pixelSize: 12
                font.bold: true
            } 
        }
    }
    
    StackLayout {
        id: pages
        anchors.fill:parent
        currentIndex: tabs.currentIndex
        Item{
            Rectangle{
                anchors.fill: parent
                color: "#0B1120"
                anchors.margins: 24
                radius: 16
                border.color: "#263244"
                Text {
                    text: "Workspace"
                    color: "#F8FAFC"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.centerIn: parent
                    
                }
                
            }
        }

         Item {
            Rectangle {
                anchors.fill: parent
                anchors.margins: 24
                radius: 16
                color: "#0B1120"
                border.color: "#263244"

                Label {
                    anchors.centerIn: parent
                    text: "Monitoring page"
                    color: "#F8FAFC"
                    font.pixelSize: 26
                    font.bold: true
                }
            }
        }
        Item {
            Rectangle {
                anchors.fill: parent
                anchors.margins: 24
                radius: 16
                color:"#0B1120"
                border.color: "#263244"

                Label {
                    anchors.centerIn: parent
                    text: "Settings page"
                    color: "#F8FAFC"
                    font.pixelSize: 26
                    font.bold: true
                }
            }
        }
    }
    footer : ToolBar {
            height: 30
            background: Rectangle {
                color: "#111827"
                border.color: "#1F2937"
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                spacing: 24

                Label {
                    text: "© 2026 Camera Workspace"
                    color: "#94A3B8"
                    font.pixelSize: 12
                    font.bold: true
                }
            }
        }
}
