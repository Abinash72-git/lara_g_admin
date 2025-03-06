class ShopDetailsModel {
  final String shopId;
  final String userId;
  final String shopName;
  final String shopLocation;
  final String createdAt;
  final String image;

  ShopDetailsModel({
    required this.shopId,
    required this.userId,
    required this.shopName,
    required this.shopLocation,
    required this.createdAt,
    required this.image,
  });

  static List<ShopDetailsModel> fromList(List<dynamic> list) {
    return list
        .map((item) => ShopDetailsModel(
              shopId: item['shop_id'] ?? '',
              userId: item['user_id'] ?? '',
              shopName: item['shop_name'] ?? '',
              shopLocation: item['shop_location'] ?? '',
              createdAt: item['created_at'] ?? '',
              image: item['image'] ?? '',
            ))
        .toList();
  }
}
