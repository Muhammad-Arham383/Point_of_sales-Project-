import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:pos_project/bloc/bloc/inventory_bloc.dart';
import 'package:pos_project/bloc/bloc/user_data_bloc.dart';
import 'package:pos_project/models/products.dart';
import 'package:pos_project/services/firestore_services.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirestoreService firestoreService;
  final InventoryBloc inventoryBloc;
  CartBloc({required this.firestoreService, required this.inventoryBloc})
      : super(CartState(cartItems: const {})) {
    // Select or Deselect Product from Inventory
    on<ToggleProductSelection>((event, emit) {
      final updatedCart = Map<String, Products>.from(state.cartItems);

      if (updatedCart.containsKey(event.product.productId)) {
        updatedCart
            .remove(event.product.productId); // Remove if already selected
      } else {
        updatedCart[event.product.productId] = Products(
            productId: event.product.productId,
            productName: event.product.productName,
            productCategory: event.product.productCategory,
            price: event.product.price,
            stockQuantity: event.product.stockQuantity // Default quantity 1
            );
      }

      emit(CartState(cartItems: updatedCart));
    });

    // Update Product Quantity
    on<UpdateProductQuantity>((event, emit) {
      final updatedCart = Map<String, Products>.from(state.cartItems);

      if (updatedCart.containsKey(event.productId)) {
        final item = updatedCart[event.productId]!;
        updatedCart[event.productId] =
            item.copyWith(stockQuantity: event.quantity);
      }

      emit(CartState(cartItems: updatedCart));
    });

    // Confirm Purchase (Update Firestore Inventory)
    on<ConfirmPurchase>((event, emit) async {
      final updatedCart = state.cartItems;

      for (var item in updatedCart.values) {
        var uid = FirebaseAuth.instance.currentUser?.uid ?? '';
        await firestoreService.reduceProductQuantity(
            uid, item.productId, item.stockQuantity);
      }

      emit(CartState(cartItems: const {})); // Clear cart after purchase

      // Dispatch event to refresh inventory in InventoryBloc
      var uid = FirebaseAuth.instance.currentUser?.uid ?? '';

      inventoryBloc.add(ProductsFetchEvent(userId: uid));
    });
  }
}
