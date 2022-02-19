class Config {
  final String apiUrl;
  final String sessionCookieKey;
  final String sessionFilePath;

  const Config({
    required this.apiUrl,
    required this.sessionCookieKey,
    required this.sessionFilePath,
  });
}