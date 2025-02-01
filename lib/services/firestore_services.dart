import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_project/models/products.dart';
import 'package:pos_project/models/users.dart';

class FirestoreService {
  static const String collectionName = "Users";
  static const String productsCollection = "Products";
  static FirestoreService? _firestoreService;
  FirestoreService.internal();
  factory FirestoreService() {
    return _firestoreService ??= FirestoreService.internal();
  }
  final userCollection = FirebaseFirestore.instance.collection(collectionName);
  final productCollection =
      FirebaseFirestore.instance.collection(productsCollection);

  Future<bool> addUser(Users users, String uid) async {
    try {
      await userCollection.doc(uid).set(users.toMap());
      return true;
    } catch (e) {
      print('user not added: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      final userDocument = await userCollection.doc(uid).get();
      if (userDocument.exists) {
        return userDocument.data()!;
      } else {
        throw Exception('user not found');
      }
    } catch (e) {
      throw Exception('error fetching user data $e');
    }
  }

  Future<bool> addProduct(String userId, Products products) async {
    try {
      DocumentReference docRef = await userCollection
          .doc(userId)
          .collection(productsCollection)
          .add(products.toMap());

      String productId = docRef.id; // Get the generated ID

      // Update the document to store the productId inside Firestore
      await docRef.update({'productId': productId});

      return true;
    } catch (e) {
      print("Error adding product: $e");
      return false;
    }
  }

  Future<List<Products>> fetchProducts(String uid) async {
    try {
      QuerySnapshot querySnapshot =
          await userCollection.doc(uid).collection(productsCollection).get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Products(
          productId: doc.id,
          productName: data['productName'] ?? '',
          productCategory: data['productCategory'] ?? '',
          stockQuantity:
              int.tryParse(data['stockQuantity']?.toString() ?? '') ?? 0,
          price: data['price'] ?? '',
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteProducts(String uid, String? productId) async {
    try {
      await userCollection
          .doc(uid)
          .collection(productsCollection)
          .doc(productId)
          .delete();
    } catch (e) {
      Exception(e);
    }
  }

  Future<void> reduceProductQuantity(
      String uid, String productId, int quantityToReduce) async {
    try {
      await userCollection
          .doc(uid)
          .collection(productsCollection)
          .doc(productId)
          .update({'stockQuantity': FieldValue.increment(-quantityToReduce)});
    } catch (e) {
      // Optionally log the error or rethrow with a custom message
      throw Exception("Failed to update product quantity for $productId: $e");
    }
  }

  Future<Products?> fetchProductByName(String productName, String uid) async {
    try {
      final querySnapshot = await userCollection
          .doc(uid)
          .collection(productsCollection)
          .where('productName', isEqualTo: productName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        for (var doc in querySnapshot.docs) {
          if (data['stockQuantity'] is String) {
            int quantity = int.tryParse(data['stockQuantity']) ?? 0;
            await doc.reference.update({'stockQuantity': quantity});
          }
        }
        return Products(
          productId: data['productId'],
          productName: data['productName'] ?? '',
          price: data['price'] ?? 0,
          stockQuantity:
              int.tryParse(data['stockQuantity']?.toString() ?? '') ?? 0,
          productCategory: data['productCategory'] ?? '',
        );
      }
      return null; // Product not found
    } catch (e) {
      throw Exception('Error fetching product: $e');
    }
  }
}
