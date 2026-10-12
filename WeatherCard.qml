import QtQuick
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Dates.js" as Dates
import "I18n.js" as I18n

BorderSurface {
  id: root

  required property QtObject bar
  property var weather: null
  property date now: new Date()
  property bool opened: false

  readonly property string icon: weather && weather.label !== "" ? weather.label : "󰖐"
  readonly property string temperature: weather && weather.reportTempNum !== ""
    ? weather.reportTempNum + weather.tempUnit : "--°"
  readonly property string location: weather && weather.reportLocation !== ""
    ? weather.reportLocation : I18n.tr("weather.location")
  readonly property string condition: {
    var current = weather ? weather.current : null
    if (current) {
      var code = current.openMeteoWeatherCode
      if (code !== undefined && code !== null && String(code).trim() !== "")
        return Dates.openMeteoCondition(code)
      if (current.weatherDesc && current.weatherDesc.length > 0)
        return Dates.wttrCondition(String(current.weatherDesc[0].value || ""))
    }
    return weather && weather.reportFeels !== ""
      ? I18n.tr("weather.feelsLike") + weather.reportFeels : I18n.tr("weather.loading")
  }
  readonly property var forecast: weather && weather.forecastDays
    ? weather.forecastDays.slice(0, 3) : []

  // ---- City picker. Clicking the location opens a search over this card.
  // The chosen city goes through omarchy-weather-location, the same file
  // Omarchy's weather panel reads, so both weather views show one place.
  property bool editing: false
  property var suggestions: []
  property bool geocodeStale: false
  readonly property string geocodeLanguage: {
    var code = Qt.locale().name.split("_")[0]
    return /^[a-z]{2}$/.test(code) ? code : "en"
  }

  onOpenedChanged: if (!opened) closeEditor()

  function startEditing() {
    editing = true
    suggestions = []
    cityField.text = ""
    Qt.callLater(cityField.forceActiveFocus)
  }

  function closeEditor() {
    editing = false
    geocodeDebounce.stop()
    suggestions = []
    cityField.focus = false
  }

  function requestGeocode() {
    var query = cityField.text.trim()
    if (query.length < 2) {
      suggestions = []
      return
    }
    if (geocodeProc.running) {
      geocodeStale = true
      return
    }
    geocodeProc.command = ["curl", "-fsS", "--max-time", "5",
      "https://geocoding-api.open-meteo.com/v1/search?name=" + encodeURIComponent(query)
      + "&count=5&language=" + geocodeLanguage + "&format=json"]
    geocodeProc.running = true
  }

  function parseGeocode(raw) {
    try {
      var results = JSON.parse(String(raw || "{}")).results || []
      return results.map(function(place) {
        var parts = [place.name, place.admin1, place.country].filter(function(part, index, all) {
          return part && all.indexOf(part) === index
        })
        return {
          name: place.name,
          latitude: place.latitude,
          longitude: place.longitude,
          label: parts.join(", ")
        }
      })
    } catch (error) {
      return []
    }
  }

  function storeLocation(args) {
    if (saveProc.running) return
    saveProc.command = ["omarchy-weather-location"].concat(args)
    saveProc.running = true
    closeEditor()
  }

  function pickSuggestion(place) {
    storeLocation(["--set", place.name, place.latitude + "," + place.longitude])
  }

  function pickFirstSuggestion() {
    if (suggestions.length > 0) pickSuggestion(suggestions[0])
  }

  function useIpLocation() {
    storeLocation(["--clear"])
  }

  Process {
    id: geocodeProc
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: {
        if (root.editing) root.suggestions = root.parseGeocode(text)
        if (root.geocodeStale) {
          root.geocodeStale = false
          Qt.callLater(root.requestGeocode)
        }
      }
    }
  }

  Process {
    id: saveProc
    onExited: function(exitCode) {
      if (exitCode === 0 && root.weather && root.weather.refresh) root.weather.refresh()
    }
  }

  Timer {
    id: geocodeDebounce
    interval: 300
    onTriggered: root.requestGeocode()
  }

  color: Style.normalFillFor(bar.foreground, Color.accent)
  borderSpec: Border.controlSpec("normal", bar.foreground, Color.accent)
  radius: Style.cornerRadius * 1.35

  Item {
    anchors.fill: parent
    anchors.margins: Style.space(12)

    Column {
      anchors.fill: parent
      spacing: Style.space(4)

      Row {
        id: summaryRow
        width: parent.width
        height: Style.space(54)
        spacing: Style.space(12)

        Row {
          id: currentBlock
          width: Style.space(180)
          height: parent.height
          spacing: Style.space(9)

          Text {
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            color: Color.accent
            font.family: root.bar.fontFamily
            font.pixelSize: Style.space(42)
          }

          Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 0

            Text {
              text: root.temperature
              color: root.bar.foreground
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.displayLarge
              font.bold: true
            }

            Text {
              width: Style.space(105)
              textFormat: Text.PlainText
              text: root.condition
              color: Qt.darker(root.bar.foreground, 1.35)
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.caption
              elide: Text.ElideRight
            }
          }
        }

        Column {
          width: parent.width - currentBlock.width - refreshButton.width - summaryRow.spacing * 2
          anchors.verticalCenter: parent.verticalCenter
          spacing: Style.space(1)

          Item {
            width: parent.width
            height: locationText.implicitHeight

            Text {
              id: locationText
              width: parent.width
              textFormat: Text.PlainText
              text: root.location
              color: root.bar.foreground
              font.family: root.bar.fontFamily
              font.pixelSize: Style.font.body
              font.bold: true
              elide: Text.ElideRight
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: root.startEditing()
            }
          }

          Text {
            text: Dates.fullDate(root.now)
            color: Qt.darker(root.bar.foreground, 1.45)
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.caption
          }
        }

        Button {
          id: refreshButton
          anchors.verticalCenter: parent.verticalCenter
          iconText: "󰑐"
          foreground: root.bar.foreground
          horizontalPadding: Style.spacing.controlPaddingY
          verticalPadding: Style.spacing.controlPaddingY
          onClicked: if (root.weather && root.weather.refresh) root.weather.refresh()
        }
      }

      Rectangle {
        width: parent.width
        height: 1
        color: Qt.rgba(root.bar.foreground.r,
          root.bar.foreground.g, root.bar.foreground.b, 0.12)
      }

      Row {
        id: forecastRow
        width: parent.width
        height: parent.height - summaryRow.height - Style.space(9)
        spacing: 0

        Repeater {
          model: root.forecast

          Item {
            required property var modelData
            required property int index

            width: Math.floor(forecastRow.width / 3)
            height: forecastRow.height

            Rectangle {
              visible: parent.index > 0
              anchors.left: parent.left
              anchors.verticalCenter: parent.verticalCenter
              width: 1
              height: Math.round(parent.height * 0.58)
              color: Qt.rgba(root.bar.foreground.r,
                root.bar.foreground.g, root.bar.foreground.b, 0.13)
            }

            Column {
              anchors.centerIn: parent
              width: parent.width - Style.space(12)
              spacing: Style.space(1)

              Text {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: root.weather ? Dates.forecastDay(modelData.date) : "---"
                color: Qt.darker(root.bar.foreground, 1.35)
                font.family: root.bar.fontFamily
                font.pixelSize: Style.font.caption
                font.bold: true
              }

              Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Style.space(5)

                Text {
                  text: root.weather ? root.weather.dayIcon(modelData) : ""
                  color: Color.accent
                  font.family: root.bar.fontFamily
                  font.pixelSize: Style.font.body
                }

                Text {
                  text: root.weather
                    ? root.weather.bareTempForDay(modelData, "max") + "°"
                    : "--°"
                  color: root.bar.foreground
                  font.family: root.bar.fontFamily
                  font.pixelSize: Style.font.caption
                  font.bold: true
                }

                Text {
                  text: root.weather
                    ? root.weather.bareTempForDay(modelData, "min") + "°"
                    : "--°"
                  color: Qt.darker(root.bar.foreground, 1.45)
                  font.family: root.bar.fontFamily
                  font.pixelSize: Style.font.caption
                }
              }
            }
          }
        }
      }
    }

    Rectangle {
      id: cityPicker
      anchors.fill: parent
      visible: root.editing
      radius: Style.cornerRadius
      color: Color.popups.background

      Column {
        anchors.fill: parent
        spacing: Style.space(4)

        Row {
          width: parent.width
          spacing: Style.space(6)

          TextField {
            id: cityField
            width: parent.width - useIp.width - closeCity.width - parent.spacing * 2
            foreground: root.bar.foreground
            accent: Color.accent
            placeholderText: I18n.tr("weather.cityPlaceholder")
            verticalPadding: Style.space(3)
            onTextChanged: geocodeDebounce.restart()
            onAccepted: root.pickFirstSuggestion()
            Keys.onEscapePressed: root.closeEditor()
          }

          Button {
            id: useIp
            text: "IP"
            tooltipText: I18n.tr("weather.useIp")
            foreground: root.bar.foreground
            verticalPadding: Style.space(3)
            onClicked: root.useIpLocation()
          }

          Button {
            id: closeCity
            text: "×"
            tooltipText: I18n.tr("weather.close")
            foreground: root.bar.foreground
            verticalPadding: Style.space(3)
            onClicked: root.closeEditor()
          }
        }

        Repeater {
          model: root.suggestions.slice(0, 3)

          Text {
            required property var modelData

            width: parent.width
            textFormat: Text.PlainText
            text: modelData.label
            color: root.bar.foreground
            font.family: root.bar.fontFamily
            font.pixelSize: Style.font.caption
            elide: Text.ElideRight

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: root.pickSuggestion(modelData)
            }
          }
        }
      }
    }
  }
}
