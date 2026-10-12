import QtQuick
import Quickshell
import qs.Commons
import qs.Ui
import "Dates.js" as Dates
import "I18n.js" as I18n

BarWidget {
  id: root
  moduleName: "celestune-bar"

  readonly property var mediaService: bar?.shell?.firstPartyServiceFor("omarchy.media")
  readonly property var activePlayer: mediaService ? mediaService.activePlayer : null
  readonly property var weatherPanel: weatherLoader.item
  readonly property bool hasMedia: activePlayer !== null
    && ((activePlayer.trackTitle || "") !== "" || (activePlayer.trackArtist || "") !== "")
  readonly property string mediaTitle: hasMedia ? (activePlayer.trackTitle || I18n.tr("media.unknownTrack")) : ""
  readonly property string playIcon: activePlayer && activePlayer.isPlaying ? "󰏤" : "󰐊"
  readonly property string weatherIcon: weatherPanel && weatherPanel.label !== ""
    ? weatherPanel.label : "󰖐"
  readonly property string weatherTemp: weatherPanel && weatherPanel.reportTempNum !== ""
    ? weatherPanel.reportTempNum + weatherPanel.tempUnit : ""

  property bool opened: false
  property date now: new Date()
  property bool popoutSwitchClosing: false

  // Snap the calendar back to the current month/day whenever the dashboard
  // opens; otherwise shownDate/today stay on whatever day the shell started.
  onOpenedChanged: {
    if (opened && dashboard) dashboard.resetCalendar()
  }

  function open() { opened = true }
  function close() { opened = false }
  function togglePanel() { opened = !opened }
  function closeForPopoutSwitch() {
    popoutSwitchClosing = true
    close()
    Qt.callLater(function() { root.popoutSwitchClosing = false })
  }

  function mediaAction(action) {
    if (!mediaService) return
    var key = activePlayer ? mediaService.playerKey(activePlayer) : ""
    mediaService.runAction(action, false, key)
  }

  function refreshWeather() {
    if (weatherPanel && weatherPanel.refresh) weatherPanel.refresh()
  }

  function shortText(value, limit) {
    var text = String(value || "")
    return text.length > limit ? text.slice(0, limit - 1) + "…" : text
  }

  function barLabel() {
    var clock = Dates.compactDateTime(now)
    var weather = weatherIcon + (weatherTemp !== "" ? " " + weatherTemp : "")
    var media = hasMedia ? playIcon + " " + shortText(mediaTitle, 18) : ""
    if (vertical) return weatherIcon
    return clock + "  ·  " + weather + (media !== "" ? "  ·  " + media : "")
  }

  function injectWeather() {
    var target = weatherLoader.item
    if (!target) return
    if ("bar" in target) target.bar = root.bar
    if ("settings" in target) target.settings = ({})
    if ("anchorItem" in target) target.anchorItem = pill
    if ("hostWidget" in target) target.hostWidget = root
  }

  onBarChanged: injectWeather()

  Timer {
    interval: 1000
    repeat: true
    running: true
    triggeredOnStart: true
    onTriggered: root.now = new Date()
  }

  Loader {
    id: weatherLoader
    active: true
    asynchronous: false
    visible: false
    source: Util.fileUrl(Quickshell.env("OMARCHY_PATH") + "/shell/plugins/panels/weather/Panel.qml")
    onLoaded: {
      root.injectWeather()
      Qt.callLater(root.injectWeather)
    }
  }

  visible: true
  implicitWidth: pill.implicitWidth
  implicitHeight: pill.implicitHeight

  WidgetButton {
    id: pill
    anchors.fill: parent
    bar: root.bar
    labelVisible: false
    hasVisualContent: true
    fixedWidth: pillBg.implicitWidth + Style.space(6)
    fixedHeight: root.barSize || Style.space(26)
    tooltipText: I18n.tr("bar.tooltip")

    onPressed: function(button) {
      if (button === Qt.MiddleButton) root.mediaAction("playPause")
      else if (button === Qt.RightButton) root.refreshWeather()
      else root.togglePanel()
    }

    onWheelMoved: function(delta) {
      root.mediaAction(delta > 0 ? "previous" : "next")
    }

    // Pill in the SSH style: solid Color.accent background, Color.background
    // text. The accent gets denser while the dashboard is open.
    Rectangle {
      id: pillBg
      anchors.centerIn: parent
      implicitWidth: pillRow.implicitWidth + Style.space(18)
      implicitHeight: Math.max(Style.space(20), (root.barSize || Style.space(26)) - Style.space(6))
      radius: Style.space(8)
      color: Color.accent
      opacity: root.opened ? 1 : 0.92

      Behavior on opacity { NumberAnimation { duration: 120 } }

      Row {
        id: pillRow
        anchors.centerIn: parent
        spacing: Style.space(7)

        Text {
          visible: !root.vertical
          text: Dates.compactDateTime(root.now)
          color: Color.background
          font.family: Style.font.family
          font.pixelSize: Style.font.bodySmall
          font.bold: true
        }
        Text {
          visible: !root.vertical
          text: "·"
          color: Color.background
          opacity: 0.55
          font.family: Style.font.family
          font.pixelSize: Style.font.bodySmall
        }
        Text {
          text: root.vertical
            ? root.weatherIcon
            : root.weatherIcon + (root.weatherTemp !== "" ? " " + root.weatherTemp : "")
          color: Color.background
          font.family: Style.font.family
          font.pixelSize: Style.font.bodySmall
          font.bold: true
        }
        Text {
          visible: root.hasMedia && !root.vertical
          text: root.playIcon + " " + root.shortText(root.mediaTitle, 18)
          color: Color.background
          font.family: Style.font.family
          font.pixelSize: Style.font.bodySmall
        }
      }
    }
  }

  // PopupCard's focus grab treats the whole bar window as an allowed surface,
  // so a click on another bar widget is not considered an outside click.
  // Observe the bar's registered click targets and dismiss this dashboard when
  // any target other than our own pill is pressed.
  Repeater {
    model: root.bar ? root.bar.clickTargets : []

    delegate: Item {
      id: barClickObserver
      required property var modelData

      width: 0
      height: 0
      visible: false

      Connections {
        target: barClickObserver.modelData
        ignoreUnknownSignals: true

        function onPressed(button) {
          if (root.opened && barClickObserver.modelData !== pill) root.close()
        }
      }
    }
  }

  Connections {
    target: root.bar
    ignoreUnknownSignals: true

    function onActivePopoutChanged() {
      if (root.opened && root.bar && root.bar.activePopout
          && root.bar.activePopout !== root) root.close()
    }
  }

  PopupCard {
    id: popup
    anchorItem: root
    bar: root.bar
    owner: root
    open: root.opened
    centerOnBar: true
    contentWidth: popup.fittedContentWidth(dashboard.implicitWidth)
    contentHeight: popup.fittedContentHeight(dashboard.implicitHeight)

    Dashboard {
      id: dashboard
      anchors.fill: parent
      bar: root.bar
      weather: root.weatherPanel
      mediaService: root.mediaService
      now: root.now
      opened: root.opened
    }
  }
}
