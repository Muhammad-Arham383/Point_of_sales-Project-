part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {
  final List<Products> products;
  InventoryInitial({required this.products});
}

final class InventoryLoadingState extends InventoryState {}

final class InventoryLoadedState extends InventoryState {
  final List<Products> products;
  InventoryLoadedState({required this.products});
}

final class ProductByNameLoadedState extends InventoryState {
  final Products product;
  final double totalPrice;
  ProductByNameLoadedState({required this.product, required this.totalPrice});

  ProductByNameLoadedState copyWith({Products? product, double? totalPrice}) {
    return ProductByNameLoadedState(
      product: product ?? this.product,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}

class ProductDeletedState extends InventoryState {
  ProductDeletedState(this.productId);
  final String productId;
}

final class InventoryErrorState extends InventoryState {
  InventoryErrorState({required this.errorMessage});
  final String errorMessage;
}
