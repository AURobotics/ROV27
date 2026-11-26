import QtQuick
import QtQuick.Window

Item {
    id: root
    property int topZ: 1
    property int dropIndex: -1

    function insertInDock(item, index) {
        var list = []
        for (var i = 0; i < dockRow.children.length; i++) {
            var ch = dockRow.children[i]
            if (ch !== item && ch !== dropPlaceholder) list.push(ch)
        }
        var target = (index === undefined || index < 0) ? list.length : Math.min(index, list.length)
        list.splice(target, 0, item)

        for (var j = 0; j < list.length; j++) {
            list[j].parent = null
            list[j].parent = dockRow
        }
        dropPlaceholder.parent = null
        dropPlaceholder.parent = dockRow
    }

    function updateDropPreview(box) {
        if (box.y + box.height / 2 <= dock.y) {
            dropPlaceholder.visible = false
            dropIndex = -1
            return
        }

        var cursorX = box.mapToItem(dockRow, box.width / 2, 0).x
        var list = []
        var idx = 0
        var accX = 0

        for (var i = 0; i < dockRow.children.length; i++) {
            var ch = dockRow.children[i]
            if (ch === dropPlaceholder || !ch.visible) continue
            list.push(ch)
            if (cursorX > accX + ch.width / 2) idx++
            accX += ch.width + dockRow.spacing
        }

        dropIndex = idx
        dropPlaceholder.width = box.width
        dropPlaceholder.visible = true

        list.splice(idx, 0, dropPlaceholder)
        var same = (dockRow.children.length === list.length)
        if (same) {
            for (var j = 0; j < list.length; j++) {
                if (dockRow.children[j] !== list[j]) { same = false; break }
            }
        }
        if (!same) {
            for (var k = 0; k < list.length; k++) {
                list[k].parent = null
                list[k].parent = dockRow
            }
        }
    }

    function finishDropPreview() {
        var idx = dropIndex
        dropPlaceholder.visible = false
        dropIndex = -1
        return idx
    }

    Rectangle {
        id: dock
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: 12 }
        height: 0.3 * parent.height; radius: 10; color: "#181b24"; border.color: "#2a3040"

        Row {
            id: dockRow
            anchors { fill: parent; margins: 10 }
            spacing: 10

            Rectangle {
                id: dropPlaceholder
                visible: false
                width: 260
                height: dockRow.height
                radius: 8
                color: "#1a2438"
                border.color: "#4f8cff"
            }
        }
    }

    Item {
        id: floatLayer
        anchors.fill: parent; z: 2
    }

    Component {
        id: winComp
        Window {
            visible: true; color: "#12141a"
            property Item island
            onClosing: if (island) island.redock()
        }
    }

    Component {
        id: islandComp
        Rectangle {
            id: box
            property string title: "Island"
            property color accent: "#4f8cff"
            property bool docked: true
            property real freeH: 200
            property var extWin: null
            property alias body: content

            width: 260
            height: docked ? dockRow.height : freeH
            radius: 8; color: "#1e222d"; border.color: "#32394b"

            function redock(index) {
                if (extWin) { var w = extWin; extWin = null; w.island = null; w.destroy() }
                anchors.fill = undefined
                docked = true
                root.insertInDock(box, index)
                x = 0
                y = 0
                z = 0
            }

            Rectangle {
                id: header
                anchors { top: parent.top; left: parent.left; right: parent.right }
                height: 32; radius: 8; color: "#262b38"

                Text {
                    anchors { left: parent.left; leftMargin: 10; verticalCenter: parent.verticalCenter }
                    text: box.title; color: box.accent; font.bold: true
                }

                Text {
                    anchors { right: parent.right; rightMargin: 10; verticalCenter: parent.verticalCenter }
                    text: box.extWin ? "↙" : "↗"; color: "#cfd6e6"
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (box.extWin) { box.redock(); return }
                            var p = box.mapToGlobal(0, 0)
                            box.docked = false
                            box.extWin = winComp.createObject(root, {
                                x: p.x, y: p.y, width: box.width, height: box.freeH,
                                title: box.title, island: box
                            })
                            box.parent = box.extWin.contentItem
                            box.anchors.fill = box.extWin.contentItem
                        }
                    }
                }

                MouseArea {
                    anchors { fill: parent; rightMargin: 30 }
                    property point p0
                    onPressed: function(m) {
                        p0 = Qt.point(m.x, m.y)
                        if (!box.docked) box.z = ++root.topZ
                    }
                    onPositionChanged: function(m) {
                        if (!pressed || box.extWin) return
                        var dx = m.x - p0.x, dy = m.y - p0.y
                        if (box.docked && (Math.abs(dx) > 8 || Math.abs(dy) > 8)) {
                            var p = box.mapToItem(floatLayer, 0, 0)
                            box.docked = false; box.parent = floatLayer
                            box.x = p.x; box.y = p.y; box.z = ++root.topZ
                        }
                        if (!box.docked) {
                            box.x = Math.max(0, Math.min(root.width - box.width, box.x + dx))
                            box.y = Math.max(0, Math.min(root.height - box.height, box.y + dy))
                            root.updateDropPreview(box)
                        }
                    }
                    onReleased: {
                        var idx = root.finishDropPreview()
                        if (!box.docked && box.y + box.height / 2 > dock.y) box.redock(idx)
                    }
                    onCanceled: root.finishDropPreview()
                }
            }

            Item {
                id: content
                anchors { top: header.bottom; left: parent.left; right: parent.right; bottom: parent.bottom; margins: 10 }
                clip: true
            }

            Rectangle {
                visible: !box.extWin
                anchors { right: parent.right; bottom: parent.bottom; top: parent.top }
                width: 12; color: "transparent"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.SizeHorCursor
                    property point s
                    onPressed: function(m) { s = Qt.point(m.x, m.y); if (!box.docked) box.z = ++root.topZ }
                    onPositionChanged: function(m) {
                        if (!pressed) return
                        box.width = Math.max(160, box.width + m.x - s.x)
                        if (!box.docked) box.freeH = Math.max(120, box.freeH + m.y - s.y)
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        var items = []
        for (var i = 0; i < children.length; i++)
            if (children[i] !== dock && children[i] !== floatLayer) items.push(children[i])

        items.forEach(function(c) {
            var box = islandComp.createObject(dockRow, {
                title: c.dockTitle || "Island",
                accent: c.dockColor || "#4f8cff",
                width: c.dockWidth || 260
            })
            c.parent = box.body
            c.anchors.fill = box.body
        })
    }
}