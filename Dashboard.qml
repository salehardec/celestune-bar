import QtQuick
import qs.Commons

Item {
  id: root

  required property QtObject bar
  property var weather: null
  property var mediaService: null
  property date now: new Date()
  property bool opened: false
  readonly property bool editingLocation: weatherCard.editingLocation

  // Show the current month and day each time the dashboard opens.
  onOpenedChanged: if (opened) calendarCard.resetToday()

  implicitWidth: Style.space(972)
  implicitHeight: Style.space(420)

  Row {
    anchors.fill: parent
    spacing: Style.space(12)

    ClockCard {
      id: clockCard
      width: Style.space(200)
      height: parent.height
      bar: root.bar
      opened: root.opened
    }

    Column {
      width: parent.width - clockCard.width - mediaCard.width - parent.spacing * 2
      height: parent.height
      spacing: Style.space(12)

      WeatherCard {
        id: weatherCard
        width: parent.width
        height: Style.space(132)
        bar: root.bar
        weather: root.weather
        now: root.now
      }

      CalendarCard {
        id: calendarCard
        width: parent.width
        height: parent.height - Style.space(144)
        bar: root.bar
      }
    }

    MediaCard {
      id: mediaCard
      width: Style.space(270)
      height: parent.height
      bar: root.bar
      mediaService: root.mediaService
    }
  }
}
