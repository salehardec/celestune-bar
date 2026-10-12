// UI strings and locale data for the Celestune dashboard.
// The language follows the system locale (Qt.locale()). Languages without a
// table here fall back to English.

var STRINGS = {
  en: {
    "bar.tooltip": "Dashboard\nLeft click: open · Middle click: play/pause · Right click: refresh weather",
    "media.nowPlaying": "NOW PLAYING",
    "media.label": "MEDIA",
    "media.nothingPlaying": "Nothing playing",
    "media.startPlayer": "Start Spotify or another player",
    "media.unknownTrack": "Unknown track",
    "media.unknownArtist": "Unknown artist",
    "weather.location": "Weather",
    "weather.feelsLike": "Feels like ",
    "weather.loading": "Updating forecast…",
    "weather.cityPlaceholder": "City",
    "weather.useIp": "Detect the city from the IP address",
    "weather.close": "Close",
    "date.pill": "{wd}, {m} {d}, {t}",
    "date.full": "{wd}, {m} {d}",
    "date.monthYear": "{m} {y}",
    "date.weekdays": ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
    "date.weekdaysShort": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
    "date.months": ["January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"],
    "date.monthsNominative": ["January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"],
    "date.monthsShort": ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
    "condition.openMeteo": {
      0: "Clear",
      1: "Mostly clear",
      2: "Partly cloudy",
      3: "Overcast",
      45: "Fog",
      48: "Rime fog",
      51: "Light drizzle",
      53: "Drizzle",
      55: "Heavy drizzle",
      56: "Freezing drizzle",
      57: "Heavy freezing drizzle",
      61: "Light rain",
      63: "Rain",
      65: "Heavy rain",
      66: "Freezing rain",
      67: "Heavy freezing rain",
      71: "Light snow",
      73: "Snow",
      75: "Heavy snow",
      77: "Snow grains",
      80: "Light showers",
      81: "Showers",
      82: "Heavy showers",
      85: "Snow showers",
      86: "Heavy snow showers",
      95: "Thunderstorm",
      96: "Thunderstorm with hail",
      99: "Thunderstorm with heavy hail"
    },
    "condition.fallback": "Cloudy",
    // wttr.in already reports English, so no table is needed.
    "condition.wttr": {}
  },

  ru: {
    "bar.tooltip": "Дашборд\nЛКМ: открыть · СКМ: пауза/пуск · ПКМ: обновить погоду",
    "media.nowPlaying": "СЕЙЧАС ИГРАЕТ",
    "media.label": "МЕДИА",
    "media.nothingPlaying": "Ничего не играет",
    "media.startPlayer": "Запустите Spotify или другой плеер",
    "media.unknownTrack": "Неизвестный трек",
    "media.unknownArtist": "Неизвестный исполнитель",
    "weather.location": "Погода",
    "weather.feelsLike": "Ощущается как ",
    "weather.loading": "Обновляем прогноз…",
    "weather.cityPlaceholder": "Город",
    "weather.useIp": "Определять город по IP-адресу",
    "weather.close": "Закрыть",
    "date.pill": "{wd}, {d} {m}, {t}",
    "date.full": "{wd}, {d} {m}",
    "date.monthYear": "{m} {y}",
    "date.weekdays": ["воскресенье", "понедельник", "вторник", "среда",
      "четверг", "пятница", "суббота"],
    "date.weekdaysShort": ["вс", "пн", "вт", "ср", "чт", "пт", "сб"],
    // Genitive forms follow a day number ("9 сентября"); the nominative list
    // is used for headers ("Сентябрь 2026") and the short list for the bar.
    "date.months": ["января", "февраля", "марта", "апреля", "мая", "июня",
      "июля", "августа", "сентября", "октября", "ноября", "декабря"],
    "date.monthsNominative": ["январь", "февраль", "март", "апрель", "май", "июнь",
      "июль", "август", "сентябрь", "октябрь", "ноябрь", "декабрь"],
    "date.monthsShort": ["янв", "фев", "мар", "апр", "мая", "июн",
      "июл", "авг", "сен", "окт", "ноя", "дек"],
    "condition.openMeteo": {
      0: "Ясно",
      1: "Почти ясно",
      2: "Переменная облачность",
      3: "Пасмурно",
      45: "Туман",
      48: "Изморозь",
      51: "Морось",
      53: "Морось",
      55: "Сильная морось",
      56: "Ледяная морось",
      57: "Ледяная морось",
      61: "Небольшой дождь",
      63: "Дождь",
      65: "Сильный дождь",
      66: "Ледяной дождь",
      67: "Ледяной дождь",
      71: "Небольшой снег",
      73: "Снег",
      75: "Сильный снег",
      77: "Снежная крупа",
      80: "Небольшой ливень",
      81: "Ливень",
      82: "Сильный ливень",
      85: "Снегопад",
      86: "Сильный снегопад",
      95: "Гроза",
      96: "Гроза с градом",
      99: "Гроза с градом"
    },
    "condition.fallback": "Облачно",
    "condition.wttr": {
      "Sunny": "Ясно",
      "Clear": "Ясно",
      "Partly cloudy": "Переменная облачность",
      "Cloudy": "Облачно",
      "Overcast": "Пасмурно",
      "Mist": "Дымка",
      "Fog": "Туман",
      "Freezing fog": "Ледяной туман",
      "Light drizzle": "Небольшая морось",
      "Patchy light drizzle": "Небольшая морось",
      "Drizzle": "Морось",
      "Heavy drizzle": "Сильная морось",
      "Light rain": "Небольшой дождь",
      "Light rain shower": "Небольшой ливень",
      "Light rain showers": "Небольшие ливни",
      "Moderate rain": "Дождь",
      "Moderate rain at times": "Временами дождь",
      "Heavy rain": "Сильный дождь",
      "Heavy rain at times": "Временами сильный дождь",
      "Torrential rain shower": "Сильный ливень",
      "Patchy rain possible": "Возможен дождь",
      "Patchy rain nearby": "Возможен дождь",
      "Light snow": "Небольшой снег",
      "Light snow showers": "Небольшой снегопад",
      "Moderate snow": "Снег",
      "Moderate or heavy snow": "Снегопад",
      "Moderate or heavy snow showers": "Снегопад",
      "Heavy snow": "Сильный снег",
      "Blizzard": "Метель",
      "Patchy snow possible": "Возможен снег",
      "Patchy sleet possible": "Возможна крупа",
      "Light sleet": "Небольшая крупа",
      "Light sleet showers": "Небольшая крупа",
      "Moderate or heavy sleet": "Крупа",
      "Freezing drizzle": "Ледяная морось",
      "Heavy freezing drizzle": "Сильная ледяная морось",
      "Patchy freezing drizzle possible": "Возможна ледяная морось",
      "Light freezing rain": "Небольшой ледяной дождь",
      "Moderate or heavy freezing rain": "Ледяной дождь",
      "Thundery outbreaks possible": "Возможны грозы",
      "Patchy light rain with thunder": "Гроза с небольшим дождём",
      "Moderate or heavy rain with thunder": "Гроза с ливнем",
      "Patchy light snow with thunder": "Гроза со снегом",
      "Moderate or heavy snow with thunder": "Гроза со снегопадом",
      "Light rain with thunder": "Дождь с грозой",
      "Moderate or heavy rain shower": "Сильный ливень",
      "Moderate or heavy rain showers": "Ливни"
    }
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
