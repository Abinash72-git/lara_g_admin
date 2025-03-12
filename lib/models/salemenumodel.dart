class MenuDetails {
  final String menuName;
  final double rate;
  final String image;

  MenuDetails({
    required this.menuName,
    required this.rate,
    required this.image,
  });

  // Method to create MenuDetails from a map (usually from API response)
  factory MenuDetails.fromMap(Map<String, dynamic> json) {
    return MenuDetails(
      menuName: json['menu_name'] ?? '',
      rate: double.tryParse(json['rate'].toString()) ?? 0.0,
      image: json['image'] ?? '',
    );
  }
}