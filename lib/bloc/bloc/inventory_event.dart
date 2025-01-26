part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {}

// final class ProductsFetchEvent extends InventoryEvent {
//   ProductsFetchEvent(
//       {required this.productName,
//       required this.price,
//       required this.productCategory,
//       required this.stockQuantity, required String userId});
//   final String productName;
//   final String productCategory;
//   final double stockQuantity;
//   final double price;
// }

final class AddProductEvent extends InventoryEvent {
  AddProductEvent({required this.products, required this.userId});
  final Products products;
  final String userId;
}

final class ProductsFetchEvent extends InventoryEvent {
  final String userId;
  ProductsFetchEvent({required this.userId});
}

final class UpdateQuantityEvent extends InventoryEvent {
  UpdateQuantityEvent({required this.quantity});
  final int quantity;
}

class DeleteProductEvent extends InventoryEvent {
  final String userId;
  final String? productId;

  DeleteProductEvent({required this.userId, required this.productId});
}

final class FetchProductByNameEvent extends InventoryEvent {
  FetchProductByNameEvent(
      {required this.productName, required this.price, required this.uid});

  final String productName;
  final double price;
  final String uid;
}
