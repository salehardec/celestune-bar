import QtQuick
import QtQuick.Controls as QQC
import qs.Commons
import qs.Ui
import "Dates.js" as Dates

BorderSurface {
  id: root

  required property QtObject bar
  property date shownDate: new Date()
  // Local "today", kept fresh by the timer below. MonthGrid's own model.today
  // is only recomputed when the model is repopulated (month/year/locale change),
  // so it goes stale after midnight; we don't rely on it.
  property date today: new Date()

  function changeMonth(delta) {
    shownDate = new Date(shownDate.getFullYear(), shownDate.getMonth() + delta, 1)
  }

  function resetToday() {
    today = new Date()
    shownDate = new Date()
  }

  Timer {
    interval: 60000
    repeat: true
    running: true
    onTriggered: root.today = new Date()
  }

  color: Style.normalFillFor(bar.foreground, Color.accent)
  borderSpec: Border.controlSpec("normal", bar.foreground, Color.accent)
  radius: Style.cornerRadius * 1.35

  Column {
    anchors.fill: parent
    anchors.margins: Style.space(14)
    spacing: Style.space(3)

    Row {
      width: parent.width
      height: Style.space(30)

      Button {
        iconText: "󰅁"
        foreground: root.bar.foreground
        horizontalPadding: Style.spacing.controlPaddingY
        verticalPadding: Style.spacing.controlPaddingY
        onClicked: root.changeMonth(-1)
      }

      Item {
        width: parent.width - Style.space(64)
        height: parent.height

        Text {
          anchors.centerIn: parent
          text: Dates.monthYear(root.shownDate)
          color: Color.accent
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.subtitle
          font.bold: true

          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.resetToday()
          }
        }
      }

      Button {
        iconText: "󰅂"
        foreground: root.bar.foreground
        horizontalPadding: Style.spacing.controlPaddingY
        verticalPadding: Style.spacing.controlPaddingY
        onClicked: root.changeMonth(1)
      }
    }

    QQC.DayOfWeekRow {
      id: daysRow
      width: parent.width
      height: Style.space(24)
      locale: Qt.locale()

      delegate: Text {
        required property var model
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: model.shortName.slice(0, 2).toUpperCase()
        color: model.day === 0 || model.day === 6
          ? Color.accent : Qt.darker(root.bar.foreground, 1.35)
        font.family: root.bar.fontFamily
        font.pixelSize: Style.font.caption
        font.bold: true
      }
    }

    QQC.MonthGrid {
      id: monthGrid
      width: parent.width
      height: parent.height - Style.space(60)
      month: root.shownDate.getMonth()
      year: root.shownDate.getFullYear()
      locale: Qt.locale()
      spacing: Style.space(2)

      delegate: Item {
        id: dayCell
        required property var model

        // Compare the cell's year/month/day to our own, timer-refreshed
        // local "today" instead of MonthGrid's stale model.today.
        readonly property bool isToday:
          dayCell.model.year === root.today.getFullYear()
          && dayCell.model.month === root.today.getMonth()
          && dayCell.model.day === root.today.getDate()
        // model.date can be shifted around midnight in some timezones, so
        // derive the weekday from the cell's year/month/day in local time.
        readonly property int dayOfWeek:
          new Date(dayCell.model.year, dayCell.model.month, dayCell.model.day).getDay()

        implicitWidth: Style.space(48)
        implicitHeight: Style.space(27)
        opacity: dayCell.model.month === monthGrid.month || dayCell.isToday ? 1 : 0.32

        Rectangle {
          anchors.centerIn: parent
          width: Style.space(26)
          height: width
          radius: width / 2
          visible: dayCell.isToday
          color: Color.accent
        }

        Text {
          anchors.centerIn: parent
          text: dayCell.model.day
          color: dayCell.isToday ? Color.background
            : (dayCell.dayOfWeek === 0 || dayCell.dayOfWeek === 6
                ? Color.accent : root.bar.foreground)
          font.family: root.bar.fontFamily
          font.pixelSize: Style.font.bodySmall
          font.bold: dayCell.isToday
        }
      }
    }
  }
}
