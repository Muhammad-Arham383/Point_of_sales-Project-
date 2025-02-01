part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class ToggleProductSelection extends CartEvent {
  final Products product;
  ToggleProductSelection(this.product);
}

class UpdateProductQuantity extends CartEvent {
  final String productId;
  final int quantity;
  UpdateProductQuantity(this.productId, this.quantity);
}

class ConfirmPurchase extends CartEvent {}
