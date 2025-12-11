String mapConditionToEmoji(String main) {
  switch (main.toLowerCase()) {
    case 'rain':
      return '🌧️';
    case 'clouds':
      return '☁️';
    case 'clear':
      return '☀️';
    case 'thunderstorm':
      return '⛈️';
    case 'drizzle':
      return '🌦️';
    case 'snow':
      return '❄️';
    default:
      return '🌡️';
  }
}
