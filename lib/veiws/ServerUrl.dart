class BackendApi {
  static const String baseUrl = "https://p9777pv7-8000.inc1.devtunnels.ms/";

  static String endpoint(String e) {
    return "$baseUrl/$e/";
  }
}
