class Product {
  final String id;
  final String title;
  final String description;
  final double currentPrice;
  final double offerPrice;
  final String category;
  final String subCategory;
  late final int quantity;
  final String imageUrl;
  final String totalRating;
  final bool trendingProducts;
  final String ratings;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.currentPrice,
    required this.offerPrice,
    required this.category,
    required this.subCategory,
    required this.quantity,
    required this.imageUrl,
    required this.totalRating,
    required this.trendingProducts,
    required this.ratings
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      currentPrice: json['CurrentPrice'].toDouble(),
      offerPrice: json['offerPrice'].toDouble(),
      category: json['Category'],
      subCategory: json['subCategory'],
      quantity: json['quantity'],
      imageUrl: 'http://103.61.224.178:8022${json['images'][0]['url']}',
      totalRating: json['totalrating'],
      trendingProducts: json['trendingProducts'],
      ratings: json['ratings']?.toString() ?? "No ratings yet", // Handle null


    );
  }
}
