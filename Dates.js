// Date and weather-condition helpers for the Celestune dashboard.
// Names, formats and condition text come from I18n.js, which follows the
// system locale.

.import "I18n.js" as I18n

function pad2(n) { return (n < 10 ? "0" : "") + n }

// Pill label: "ср, 7 окт, 15:45" in Russian, "Wed, Oct 7, 15:45" in English.
function compactDateTime(date) {
  return I18n.fill(I18n.tr("date.pill"), {
    wd: I18n.tr("date.weekdaysShort")[date.getDay()],
    d: date.getDate(),
    m: I18n.tr("date.monthsShort")[date.getMonth()],
    t: pad2(date.getHours()) + ":" + pad2(date.getMinutes())
  })
}

// Card date: "среда, 9 сентября" or "Wednesday, September 9".
function fullDate(date) {
  return I18n.fill(I18n.tr("date.full"), {
    wd: I18n.tr("date.weekdays")[date.getDay()],
    d: date.getDate(),
    m: I18n.tr("date.months")[date.getMonth()]
  })
}

// Calendar header: "Сентябрь 2026" or "September 2026".
function monthYear(date) {
  return I18n.fill(I18n.tr("date.monthYear"), {
    m: I18n.capitalize(I18n.tr("date.monthsNominative")[date.getMonth()]),
    y: date.getFullYear()
  })
}

// Forecast header from an ISO date string ("2026-09-10"): "ПТ" or "FRI".
function forecastDay(dateString) {
  var d = new Date(String(dateString || "").slice(0, 10) + "T12:00:00")
  if (isNaN(d.getTime())) return "---"
  return I18n.tr("date.weekdaysShort")[d.getDay()].toUpperCase()
}

// Open-Meteo WMO weather code -> condition text.
function openMeteoCondition(code) {
  var table = I18n.tr("condition.openMeteo")
  var c = parseInt(String(code), 10)
  return table[c] !== undefined ? table[c] : I18n.tr("condition.fallback")
}

// wttr.in condition text -> localized text. Unknown text is shown as is.
function wttrCondition(desc) {
  var key = String(desc || "").trim()
  if (key === "") return ""
  var table = I18n.tr("condition.wttr")
  return table[key] !== undefined ? table[key] : key
}
