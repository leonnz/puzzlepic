class Images {
  Images.fromJson(Map<String, dynamic> json)
      : categoryName = json["categoryName"],
        categoryImages = json["categoryImages"];

  final String categoryName;
  final Map<String, dynamic> categoryImages;
}
