// UI strings and date names for the Celestune dashboard.
// The language follows the system locale (Qt.locale()). Languages without a
// table here fall back to English.

var STRINGS = {
  en: {
    "bar.tooltip": "Dashboard\nLeft click: open · Middle click: play/pause · Right click: clock format · Scroll: change track",
    "media.nowPlaying": "NOW PLAYING",
    "media.label": "MEDIA",
    "media.nothingPlaying": "Nothing playing",
    "media.startPlayer": "Start Spotify or another player",
    "media.unknownTrack": "Unknown track",
    "media.unknownArtist": "Unknown artist",
    "weather.location": "Weather",
    "weather.feelsLike": "Feels like ",
    "weather.loading": "Updating forecast…",
    "weather.cityPlaceholder": "Search for a city",
    "weather.editHint": "Enter: save · Auto: device location",
    "weather.changeLocation": "Change location or use automatic",
    "weather.refresh": "Refresh weather",
    "weather.saveLocation": "Save location",
    "weather.deviceTooltip": "Device location through GeoClue",
    "weather.cancel": "Cancel",
    "weather.notFound": "Location not found",
    "weather.searchFailed": "Could not search for the location",
    "weather.deviceUnavailable": "Device location is unavailable",
    "weather.deviceInaccurate": "Device location is not accurate yet",
    "weather.geoclueMissing": "GeoClue is not installed",
    "weather.currentLocation": "Current location",
    "date.full": "{wd}, {m} {d}",
    "date.monthYear": "{m} {y}",
    "date.weekdays": ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    "date.months": ["January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"],
    "date.monthsNominative": ["January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"]
  },

  ru: {
    "bar.tooltip": "Дашборд\nЛКМ: открыть · СКМ: пауза/пуск · ПКМ: формат часов · Колесо: сменить трек",
    "media.nowPlaying": "СЕЙЧАС ИГРАЕТ",
    "media.label": "МЕДИА",
    "media.nothingPlaying": "Ничего не играет",
    "media.startPlayer": "Запустите Spotify или другой плеер",
    "media.unknownTrack": "Неизвестный трек",
    "media.unknownArtist": "Неизвестный исполнитель",
    "weather.location": "Погода",
    "weather.feelsLike": "Ощущается как ",
    "weather.loading": "Обновляем прогноз…",
    "weather.cityPlaceholder": "Найти город",
    "weather.editHint": "Enter: сохранить · Auto: геопозиция устройства",
    "weather.changeLocation": "Сменить место или определять автоматически",
    "weather.refresh": "Обновить погоду",
    "weather.saveLocation": "Сохранить место",
    "weather.deviceTooltip": "Геопозиция устройства через GeoClue",
    "weather.cancel": "Отмена",
    "weather.notFound": "Место не найдено",
    "weather.searchFailed": "Не удалось найти место",
    "weather.deviceUnavailable": "Геопозиция устройства недоступна",
    "weather.deviceInaccurate": "Геопозиция пока неточная",
    "weather.geoclueMissing": "GeoClue не установлен",
    "weather.currentLocation": "Текущее местоположение",
    "date.full": "{wd}, {d} {m}",
    "date.monthYear": "{m} {y}",
    "date.weekdays": ["воскресенье", "понедельник", "вторник", "среда",
      "четверг", "пятница", "суббота"],
    // Genitive forms follow a day number ("9 сентября"); the nominative list
    // is used for headers ("Сентябрь 2026").
    "date.months": ["января", "февраля", "марта", "апреля", "мая", "июня",
      "июля", "августа", "сентября", "октября", "ноября", "декабря"],
    "date.monthsNominative": ["январь", "февраль", "март", "апрель", "май", "июнь",
      "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"]
  }
}

var language = ""

// "ru_RU.UTF-8" / "en_US" -> "ru" / "en". Unknown languages use English.
function lang() {
  if (language === "") {
    var code = String(Qt.locale().name || "").split(/[_.-]/)[0].toLowerCase()
    language = STRINGS[code] !== undefined ? code : "en"
  }
  return language
}

// Plain string or list for a key; missing keys fall back to English.
function tr(key) {
  var table = STRINGS[lang()]
  if (table[key] !== undefined) return table[key]
  return STRINGS.en[key]
}

// Fills "{name}" placeholders: fill("{a}, {b}", {a: 1, b: 2}) -> "1, 2".
function fill(template, values) {
  return String(template).replace(/\{(\w+)\}/g, function(match, name) {
    return values[name] !== undefined ? values[name] : match
  })
}

// Capitalizes the first letter ("сентябрь" -> "Сентябрь").
function capitalize(text) {
  return text.charAt(0).toUpperCase() + text.slice(1)
}
