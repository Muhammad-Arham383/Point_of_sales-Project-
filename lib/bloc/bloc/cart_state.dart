part of 'cart_bloc.dart';

@immutable
class CartState {
  final Map<String, Products> cartItems;
  final double totalPrice;

  CartState({required this.cartItems})
      : totalPrice = cartItems.values
            .fold(0, (sum, item) => sum + (item.price * item.stockQuantity));
}

class CartLoaded extends CartState {
  final List<Transactions> transactions;
  CartLoaded({required this.transactions, required super.cartItems});
}

class CartError extends CartState {
  final String message;
  CartError({required this.message, required super.cartItems});
}
