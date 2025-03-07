import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:pos_project/models/products.dart';
import 'package:pos_project/services/firestore_services.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final FirestoreService firestoreService;

  InventoryBloc(
    this.firestoreService,
  ) : super(InventoryInitial(products: const [])) {
    on<AddProductEvent>((event, emit) async {
      emit(InventoryLoadingState());
      try {
        bool isAdded =
            await firestoreService.addProduct(event.userId, event.products);
        if (isAdded) {
          List<Products> product =
              await firestoreService.fetchProducts(event.userId);
          emit(InventoryLoadedState(products: product));
        } else {
          emit(InventoryErrorState(errorMessage: 'failed to fetch product'));
        }
      } catch (e) {
        emit(InventoryErrorState(errorMessage: 'failed to add product'));
      }
    });
    on<ProductsFetchEvent>((event, emit) async {
      emit(InventoryLoadingState());
      try {
        List<Products> fetchedProducts =
            await firestoreService.fetchProducts(event.userId);
        emit(InventoryLoadedState(products: fetchedProducts));
      } catch (e) {
        emit(InventoryErrorState(errorMessage: 'Failed to fetch products.'));
      }
    });

    on<DeleteProductEvent>((event, emit) async {
      try {
        await firestoreService.deleteProducts(event.userId, event.productId);
        if (state is InventoryLoadedState) {
          List<Products> updatedProducts = (state as InventoryLoadedState)
              .products
              .where((product) => product.productId != event.productId)
              .toList();

          emit(InventoryLoadedState(products: updatedProducts)); // Update state
        }
      } catch (e) {
        emit(InventoryErrorState(
            errorMessage:
                'failed to delete product. $e')); // Emit an error state
      }
    });

    on<UpdateProductEvent>((event, emit) async {
      try {
        await firestoreService.updateProduct(event.userID, event.product);
        emit(ProductUpdatedState(product: event.product));
      } catch (e) {
        emit(InventoryErrorState(errorMessage: 'failed to update product $e'));
      }
    });

    on<UpdateQuantityEvent>((event, emit) async {
      if (state is ProductByNameLoadedState) {
        final currentState = state as ProductByNameLoadedState;
        final totalPrice = event.quantity * currentState.product.price;
        emit(currentState.copyWith(totalPrice: totalPrice));
      }
    });

    on<FetchProductByNameEvent>((event, emit) async {
      emit(InventoryLoadingState());
      try {
        print(
            'Fetching product with name: ${event.productName}, uid: ${event.uid}');
        final product = await firestoreService.fetchProductByName(
            event.productName, event.uid);
        if (product != null) {
          emit(ProductByNameLoadedState(
              product: product, totalPrice: event.price));
        } else {
          emit(InventoryErrorState(errorMessage: 'Product not found.'));
        }
      } catch (e) {
        print('Error fetching product: $e');
        emit(InventoryErrorState(errorMessage: 'Failed to fetch product. $e'));
      }
    });
  }
}
