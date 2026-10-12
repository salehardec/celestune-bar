# Celestune Bar for Omarchy

A unified Omarchy bar widget: an analog clock, a weather summary with a
three-day forecast, a monthly calendar, and MPRIS media controls in one
dashboard. Weather comes from Omarchy's weather panel, and media is read
directly from Quickshell's MPRIS service.

This is a fork of [FlipZ3ro/celestune-bar](https://github.com/FlipZ3ro/celestune-bar)
(GPL-3.0-only) with a localized interface, an analog clock in the dashboard,
and a Russian-aware date layout.

![Celestune preview](preview.png)

## Files

| File | What it does |
| --- | --- |
| `manifest.json` | Plugin manifest: id, version, bar-widget entry point, settings |
| `BarWidget.qml` | Bar pill, dashboard popup host, clock-format cycling, media/weather wiring |
| `Dashboard.qml` | Dashboard layout: clock column, weather and calendar column, media column |
| `ClockCard.qml` | Analog clock and digital time, redrawn only while the dashboard is open |
| `WeatherCard.qml` | Current conditions, forecast, and the city editor |
| `CalendarCard.qml` | Monthly calendar; highlights today by local date and resets on open |
| `MediaCard.qml` | Album art, track details, playback controls, seek, and volume |
| `MediaSource.qml`, `DistroIcons.js` | Media header and the OmaLogo distro icon |
| `Dates.js` | Date formatting and weather-condition text, built on `I18n.js` |
| `I18n.js` | All interface strings and locale tables (Russian and English) |

## Requirements

- Omarchy Shell with its built-in weather panel.
- GeoClue is optional and only required for device-location Auto mode.
- An MPRIS-compatible player for media information and controls.

Manual weather locations work without GeoClue. Celestune Bar needs no
privileged access while running.

## Installation

```bash
omarchy plugin add https://github.com/salehardec/celestune-bar.git --enable
```

Celestune Bar is placed in the center section by default. You can reposition
it through Omarchy's bar configuration.

### Recommended setup

Disable Omarchy's default clock to avoid showing two clocks:

```bash
omarchy plugin disable omarchy.clock
```

To keep Celestune Bar pinned to the physical center when nearby widgets
change width, set `centerAnchor` in `~/.config/omarchy/shell.json`:

```json
"bar": {
  "centerAnchor": "salehardec.celestune-bar"
}
```

## Language

The interface follows the system locale: Russian for `ru*`, English for
everything else. Strings and locale tables live in `I18n.js`.

## Controls

- Left click: open or close the dashboard.
- Click the weather location or map marker: edit the city directly in the
  dashboard. Use `AUTO` for GeoClue device-location detection; inaccurate IP
  fallbacks are rejected so they cannot replace a correct manual city.
- Middle click: play or pause media.
- Right click: cycle the clock format and save the selection.
- Scroll: previous or next track.
- Weather refresh button: reload the forecast.

## Development

- Omarchy loads the plugin from `~/.config/omarchy/plugins/<id>`. A symlink to
  a checkout works, and Omarchy hot-reloads the plugin on every save.
- After changing the id, run `omarchy-shell shell rescanPlugins`.
- Check the manifest with `omarchy-plugin-validate <path>`.
- Lint the QML with `qmllint -I /usr/lib/qt6/qml *.qml`.
- Watch for runtime errors with `journalctl --user | grep celestune`.
- Bump `version` in `manifest.json` on every change.

## Removal

```bash
omarchy plugin remove salehardec.celestune-bar
```

## Contributors

- [Pierorivera1](https://github.com/Pierorivera1): persistent clock formats and setup documentation.
- [VideoPants](https://github.com/VideoPants): direct MPRIS support for Omarchy 4.
  Also contributed the optional OmaLogo-aware media header.

## License

Celestune Bar is licensed under the GNU General Public License v3.0 only.
The original work is by oxrapzz; this fork keeps the same license and
copyright notices.
