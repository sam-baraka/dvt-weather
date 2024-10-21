class WeatherData {
  final double lat;
  final double lon;
  final String timezone;
  final int timezoneOffset;
  final Current current;
  final List<Minutely> minutely;
  final List<Daily> daily;

  const WeatherData({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.current,
    required this.minutely,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      lat: json['lat']?.toDouble() ?? 0.0,
      lon: json['lon']?.toDouble() ?? 0.0,
      timezone: json['timezone'] ?? '',
      timezoneOffset: json['timezone_offset'] ?? 0,
      current: Current.fromJson(json['current'] ?? {}),
      minutely: (json['minutely'] as List<dynamic>?)
              ?.map((e) => Minutely.fromJson(e))
              .toList() ??
          [],
             daily: (json['daily'] as List<dynamic>?)
            ?.map((e) => Daily.fromJson(e))
            .toList() ??
        [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
      'timezone': timezone,
      'timezone_offset': timezoneOffset,
      'current': current.toJson(),
      'minutely': minutely.map((e) => e.toJson()).toList(),
      'daily': daily.map((e) => e.toJson()).toList(),
    };
  }
}

class Current {
  final int dt;
  final int sunrise;
  final int sunset;
  final double temp;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double uvi;
  final int clouds;
  final int visibility;
  final double windSpeed;
  final int windDeg;
  final List<Weather> weather;

  Current({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.weather,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      dt: json['dt'] ?? 0,
      sunrise: json['sunrise'] ?? 0,
      sunset: json['sunset'] ?? 0,
      temp: json['temp']?.toDouble() ?? 0.0,
      feelsLike: json['feels_like']?.toDouble() ?? 0.0,
      pressure: json['pressure'] ?? 0,
      humidity: json['humidity'] ?? 0,
      dewPoint: json['dew_point']?.toDouble() ?? 0.0,
      uvi: json['uvi']?.toDouble() ?? 0.0,
      clouds: json['clouds'] ?? 0,
      visibility: json['visibility'] ?? 0,
      windSpeed: json['wind_speed']?.toDouble() ?? 0.0,
      windDeg: json['wind_deg'] ?? 0,
      weather: (json['weather'] as List<dynamic>?)
              ?.map((e) => Weather.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'sunrise': sunrise,
      'sunset': sunset,
      'temp': temp,
      'feels_like': feelsLike,
      'pressure': pressure,
      'humidity': humidity,
      'dew_point': dewPoint,
      'uvi': uvi,
      'clouds': clouds,
      'visibility': visibility,
      'wind_speed': windSpeed,
      'wind_deg': windDeg,
      'weather': weather.map((e) => e.toJson()).toList(),
    };
  }
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json['id'] ?? 0,
      main: json['main'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main': main,
      'description': description,
      'icon': icon,
    };
  }
}

class Minutely {
  final int dt;
  final double precipitation;

  Minutely({
    required this.dt,
    required this.precipitation,
  });

  factory Minutely.fromJson(Map<String, dynamic> json) {
    return Minutely(
      dt: json['dt'] ?? 0,
      precipitation: json['precipitation']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'precipitation': precipitation,
    };
  }
}


class Daily {
  final int dt;
  final int sunrise;
  final int sunset;
  final int moonrise;
  final int moonset;
  final double moonPhase;
  final String summary;
  final Temp temp;
  final FeelsLike feelsLike;
  final int pressure;
  final int humidity;
  final double dewPoint;
  final double windSpeed;
  final int windDeg;
  final double windGust;
  final List<Weather> weather;
  final int clouds;
  final double pop;
  final double uvi;

  Daily({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.summary,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.weather,
    required this.clouds,
    required this.pop,
    required this.uvi,
  });

  factory Daily.fromJson(Map<String, dynamic> json) {
    return Daily(
      dt: json['dt'] ?? 0,
      sunrise: json['sunrise'] ?? 0,
      sunset: json['sunset'] ?? 0,
      moonrise: json['moonrise'] ?? 0,
      moonset: json['moonset'] ?? 0,
      moonPhase: json['moon_phase']?.toDouble() ?? 0.0,
      summary: json['summary'] ?? '',
      temp: Temp.fromJson(json['temp'] ?? {}),
      feelsLike: FeelsLike.fromJson(json['feels_like'] ?? {}),
      pressure: json['pressure'] ?? 0,
      humidity: json['humidity'] ?? 0,
      dewPoint: json['dew_point']?.toDouble() ?? 0.0,
      windSpeed: json['wind_speed']?.toDouble() ?? 0.0,
      windDeg: json['wind_deg'] ?? 0,
      windGust: json['wind_gust']?.toDouble() ?? 0.0,
      weather: (json['weather'] as List<dynamic>?)
              ?.map((e) => Weather.fromJson(e))
              .toList() ??
          [],
      clouds: json['clouds'] ?? 0,
      pop: json['pop']?.toDouble() ?? 0.0,
      uvi: json['uvi']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': dt,
      'sunrise': sunrise,
      'sunset': sunset,
      'moonrise': moonrise,
      'moonset': moonset,
      'moon_phase': moonPhase,
      'summary': summary,
      'temp': temp.toJson(),
      'feels_like': feelsLike.toJson(),
      'pressure': pressure,
      'humidity': humidity,
      'dew_point': dewPoint,
      'wind_speed': windSpeed,
      'wind_deg': windDeg,
      'wind_gust': windGust,
      'weather': weather.map((e) => e.toJson()).toList(),
      'clouds': clouds,
      'pop': pop,
      'uvi': uvi,
    };
  }
}

class Temp {
  final double day;
  final double min;
  final double max;
  final double night;
  final double eve;
  final double morn;

  Temp({
    required this.day,
    required this.min,
    required this.max,
    required this.night,
    required this.eve,
    required this.morn,
  });

  factory Temp.fromJson(Map<String, dynamic> json) {
    return Temp(
      day: json['day']?.toDouble() ?? 0.0,
      min: json['min']?.toDouble() ?? 0.0,
      max: json['max']?.toDouble() ?? 0.0,
      night: json['night']?.toDouble() ?? 0.0,
      eve: json['eve']?.toDouble() ?? 0.0,
      morn: json['morn']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'min': min,
      'max': max,
      'night': night,
      'eve': eve,
      'morn': morn,
    };
  }
}

class FeelsLike {
  final double day;
  final double night;
  final double eve;
  final double morn;

  FeelsLike({
    required this.day,
    required this.night,
    required this.eve,
    required this.morn,
  });

  factory FeelsLike.fromJson(Map<String, dynamic> json) {
    return FeelsLike(
      day: json['day']?.toDouble() ?? 0.0,
      night: json['night']?.toDouble() ?? 0.0,
      eve: json['eve']?.toDouble() ?? 0.0,
      morn: json['morn']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'night': night,
      'eve': eve,
      'morn': morn,
    };
  }
}