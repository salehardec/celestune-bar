import QtQuick
import qs.Commons
import qs.Ui
import "Dates.js" as Dates

BorderSurface {
  id: root

  required property QtObject bar
  property bool opened: false
  property date now: new Date()

  // Continuous time-of-day in seconds, monotonic across the 59→0 second
  // boundary (only wraps once a day at midnight, where every hand already
  // sits at 12). All three hand angles grow monotonically from it, so the
  // hands never jump backwards.
  readonly property real secondsOfDay: now.getHours() * 3600 + now.getMinutes() * 60
    + now.getSeconds() + now.getMilliseconds() / 1000
  readonly property real secondAngle: secondsOfDay * 6            // 6°/second
  readonly property real minuteAngle: secondsOfDay * 0.1          // 6°/minute
  readonly property real hourAngle: secondsOfDay * (360 / 43200)  // 360°/12h

  color: Style.normalFillFor(bar.foreground, Color.accent)
  borderSpec: Border.controlSpec("normal", bar.foreground, Color.accent)
  radius: Style.cornerRadius * 1.35

  // Runs only while the dashboard is open so we don't burn CPU in the background.
  Timer {
    interval: 16
    repeat: true
    running: root.opened
    triggeredOnStart: true
    onTriggered: root.now = new Date()
  }

  Item {
    anchors.fill: parent
    anchors.margins: Style.space(14)

    Column {
      anchors.centerIn: parent
      width: Style.space(168)
      spacing: Style.space(6)

      Item {
        id: face
        width: parent.width
        height: width

        // Dial background and a hairline rim.
        Rectangle {
          anchors.fill: parent
          radius: width / 2
          color: Style.normalFillFor(root.bar.foreground, Color.accent)
        }
        Rectangle {
          anchors.fill: parent
          radius: width / 2
          color: "transparent"
          border.width: Math.max(1, Style.space(1))
          border.color: Qt.rgba(root.bar.foreground.r, root.bar.foreground.g,
            root.bar.foreground.b, 0.16)
        }

        // 60 tick marks: minute (small), hour (medium), cardinal 12/3/6/9 (large).
        Repeater {
          model: 60

          Item {
            required property int index
            readonly property bool hourMark: index % 5 === 0
            readonly property bool cardinal: index % 15 === 0

            width: face.width
            height: face.height
            rotation: index * 6

            Rectangle {
              readonly property real len: parent.cardinal ? Style.space(14)
                : parent.hourMark ? Style.space(10) : Style.space(6)
              readonly property real w: parent.cardinal ? Math.max(1, Style.space(3))
                : parent.hourMark ? Math.max(1, Style.space(2)) : 1

              width: w
              height: len
              radius: w / 2
              x: parent.width / 2 - w / 2
              y: Style.space(6)
              color: parent.cardinal ? Color.accent
                : parent.hourMark ? root.bar.foreground
                : Qt.rgba(root.bar.foreground.r, root.bar.foreground.g, root.bar.foreground.b, 0.4)
            }
          }
        }

        // Digits at the four cardinals, just inside the tick ring.
        Text {
          text: "12"
          anchors.horizontalCenter: face.horizontalCenter
          anchors.top: face.top
          anchors.topMargin: Style.space(22)
          color: root.bar.foreground
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.title
          font.bold: true
        }
        Text {
          text: "6"
          anchors.horizontalCenter: face.horizontalCenter
          anchors.bottom: face.bottom
          anchors.bottomMargin: Style.space(22)
          color: root.bar.foreground
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.title
          font.bold: true
        }
        Text {
          text: "3"
          anchors.right: face.right
          anchors.rightMargin: Style.space(24)
          anchors.verticalCenter: face.verticalCenter
          color: root.bar.foreground
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.title
          font.bold: true
        }
        Text {
          text: "9"
          anchors.left: face.left
          anchors.leftMargin: Style.space(24)
          anchors.verticalCenter: face.verticalCenter
          color: root.bar.foreground
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.title
          font.bold: true
        }

        // Hour hand (shortest), minute hand, thin accent second hand.
        Item {
          x: face.width / 2
          y: face.height / 2
          rotation: root.hourAngle
          Rectangle {
            width: Style.space(4)
            height: face.width * 0.26
            radius: width / 2
            color: root.bar.foreground
            x: -width / 2
            y: -height + Style.space(8)
          }
        }

        Item {
          x: face.width / 2
          y: face.height / 2
          rotation: root.minuteAngle
          Rectangle {
            width: Style.space(3)
            height: face.width * 0.38
            radius: width / 2
            color: root.bar.foreground
            x: -width / 2
            y: -height + Style.space(10)
          }
        }

        Item {
          x: face.width / 2
          y: face.height / 2
          rotation: root.secondAngle
          Rectangle {
            width: Math.max(1, Style.space(1))
            height: face.width * 0.42
            radius: width / 2
            color: Color.accent
            x: -width / 2
            y: -height + Style.space(16)   // tail past the centre = counterweight
          }
        }

        // Centre dot.
        Rectangle {
          anchors.centerIn: parent
          width: Style.space(8)
          height: Style.space(8)
          radius: Style.space(4)
          color: Color.accent
        }
      }

      Text {
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: Dates.pad2(root.now.getHours()) + ":" + Dates.pad2(root.now.getMinutes())
          + ":" + Dates.pad2(root.now.getSeconds())
        color: root.bar.foreground
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.title
        font.bold: true
      }

      Text {
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: Dates.fullDate(root.now)
        color: Qt.darker(root.bar.foreground, 1.45)
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.caption
      }
    }
  }
}
