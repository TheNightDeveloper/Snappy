class PredictionLocation {
  String? city;
  String? displayName;
  String? displayAddrr;
  String? lat;
  String? lon;

  PredictionLocation(
      {this.city, this.displayAddrr, this.displayName, this.lat, this.lon});

  PredictionLocation.fromJson(Map<String, dynamic> jsonData) {
    city = jsonData['address']['city'];
    displayAddrr = jsonData['display_address'];
    displayName = jsonData['display_name'];
    lat = jsonData['lat'];
    lon = jsonData['lon'];
  }
}
