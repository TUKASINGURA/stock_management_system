// models/product.dart
class Product {
  final String id;
  final String name;
  final String? description;
  final String barcode;
  final String category;
  final double purchasePrice;
  final double sellingPrice;
  final int currentStock;
  final int minimumStockLevel;
  final DateTime? expiryDate;
  final List<String>? variants; // size, color etc.
  final DateTime dateAdded;
  final DateTime? lastRestocked;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.barcode,
    required this.category,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.currentStock,
    this.minimumStockLevel = 5,
    this.expiryDate,
    this.variants,
    required this.dateAdded,
    this.lastRestocked,
  });

  bool get isLowStock => currentStock <= minimumStockLevel;

  bool get isExpired {
    if (expiryDate == null) return false;
    return expiryDate!.isBefore(DateTime.now());
  }

  bool get isExpiringSoon {
    if (expiryDate == null) return false;
    final daysToExpiry = expiryDate!.difference(DateTime.now()).inDays;
    return daysToExpiry <= 7 && daysToExpiry >= 0;
  }
}
