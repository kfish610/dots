import Quickshell
import Quickshell.Wayland

import QtQuick
import QtQuick.Effects

Scope {
    QtObject {
        id: shape

        property var top: 5
        property var bottom: 5
        property var left: 30
        property var right: 5
    }

    PanelWindow {
        id: win

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true

        color: "transparent"

        WlrLayershell.mask: Region {
            x: shape.left
            y: shape.top
            width: win.width - shape.left - shape.right
            height: win.height - shape.top - shape.bottom
            intersection: Intersection.Xor
        }

        Item {
            anchors.fill: parent

            Rectangle {
                id: rect

                anchors.fill: parent
                color: '#d012181c'
                visible: false
            }

            Item {
                id: cover

                anchors.fill: parent
                layer.enabled: true
                visible: false

                Rectangle {
                    anchors.fill: parent

                    anchors.topMargin: shape.top
                    anchors.bottomMargin: shape.bottom
                    anchors.leftMargin: shape.left
                    anchors.rightMargin: shape.right

                    radius: 5
                }
            }

            MultiEffect {
                anchors.fill: parent

                source: rect
                maskSource: cover

                maskEnabled: true
                maskInverted: true
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1
            }
        }
    }
}
