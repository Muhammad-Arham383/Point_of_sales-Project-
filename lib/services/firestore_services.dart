import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pos_project/models/products.dart';
import 'package:pos_project/models/transaction.dart';
import 'package:pos_project/models/users.dart';

class FirestoreService {
  static const String collectionName = "Users";
  static const String productsCollection = "Products";
  static const String transactionCollections = "Transactions";
  static FirestoreService? _firestoreService;
  FirestoreService.internal();
  factory FirestoreService() {
    return _firestoreService ??= FirestoreService.internal();
  }
  final userCollection = FirebaseFirestore.instance.collection(collectionName);
  final productCollection =
      FirebaseFirestore.instance.collection(productsCollection);
  final transactionsCollection =
      FirebaseFirestore.instance.collection(transactionCollections);
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

  Future<void> updateProduct(String uid, Products products) async {
    try {
      await userCollection
          .doc(uid)
          .collection(productsCollection)
          .doc(products.productId)
          .update(products.toMap());
    } catch (e) {
      print("Error updating product: $e");
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

  Future<void> storeTransaction(
      String uid, String productId, Transactions transactions) async {
    try {
      await userCollection
          .doc(uid)
          .collection(transactionCollections)
          .add(transactions.toMap());
      // Store transaction in Firestore
    } catch (e) {
      print("Error storing transaction: $e");
    } // Log errors for debugging
  }

  Future<List<Transactions>> fetchTransactions(String uid) async {
    try {
      QuerySnapshot querySnapshot = await userCollection
          .doc(uid)
          .collection(transactionCollections)
          .get();

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        return Transactions(
          id: doc.id,
          title: data['title'] ?? '',
          amount: (data['amount'] as num?)?.toDouble() ?? 0,
          quantity: data['quantity'] ?? 0,
          date: _convertToDateTime(data['date']), // ✅ Fix
        );
      }).toList();
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }

// ✅ Helper function to safely convert Firestore date values
  DateTime _convertToDateTime(dynamic date) {
    if (date is Timestamp) {
      return date.toDate(); // Convert Firestore Timestamp to DateTime
    } else if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(
          date); // Convert int to DateTime
    } else {
      return DateTime.now(); // Default value
    }
  }

  Future<List<Transactions>> fetchTransactionsByDateRange(
      DateTime start, DateTime end, String uid) async {
    try {
      print("Fetching transactions for UID: $uid from $start to $end");

      QuerySnapshot querySnapshot = await userCollection
          .doc(uid)
          .collection(transactionCollections)
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .get();

      print("Documents fetched: ${querySnapshot.docs.length}");

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        print("Transaction: ${data['title']} - ${data['amount']}");

        return Transactions(
          id: doc.id,
          title: data['title'] ?? '',
          amount: (data['amount'] as num?)?.toDouble() ?? 0,
          quantity: data['quantity'] ?? 0,
          date: _convertToDateTime(data['date']),
        );
      }).toList();
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
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
