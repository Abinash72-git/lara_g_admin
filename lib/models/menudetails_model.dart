class MenuDetails {
  final String menuName;
  final double rate;
  final String image;

  MenuDetails({
    required this.menuName,
    required this.rate,
    required this.image,
  });

  factory MenuDetails.fromJson(Map<String, dynamic> json) {
    return MenuDetails(
      menuName: json['menu_name'],
      rate: json['rate'],
      image: json['image'],
    );
  }
}