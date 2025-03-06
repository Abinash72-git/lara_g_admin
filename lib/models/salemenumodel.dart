class Salemenumodel {
  final String menuName;
  final String rate;
  final String image;

  Salemenumodel({
    required this.menuName,
    required this.rate,
    required this.image,
  });

  factory Salemenumodel.fromJson(Map<String, dynamic> json) {
    return Salemenumodel(
      menuName: json["menu_name"] ?? "",
      rate: json["rate"] ?? "0.0",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "menu_name": menuName,
      "rate": rate,
      "image": image,
    };
  }
}
