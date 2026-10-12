// Date helpers for the Celestune dashboard. Names and formats come from
// I18n.js, which follows the system locale.

.import "I18n.js" as I18n

function pad2(n) { return (n < 10 ? "0" : "") + n }

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
