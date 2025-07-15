import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class UserDataService {
    static const String _collection1 = "users";
    static const String _collection2 = "onboarding_responses";
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Uuid _uuid = Uuid();

    // Get user data for currently signed in user
    Future<Map<String, dynamic>> getUserData() async {
        final user = _auth.currentUser;
        if (user == null) {
            throw Exception("User not authenticated");
        }

        final docRef = _firestore.collection(_collection1).doc(user.uid);
        final doc = await docRef.get();

        if (!doc.exists) {
            throw Exception("User data not found");
        }
        print("User data found: ${doc.data()}");
        return doc.data() ?? {};
    }

    // Get onboarding responses for currently signed in user
    Future<Map<String, dynamic>> getOnboardingResponses() async {
        final user = _auth.currentUser;
        if (user == null) {
            throw Exception("User not authenticated");
        }

        final querySnapshot = await _firestore
            .collection(_collection2)
            .where('uid', isEqualTo: user.uid)
            .get();

        if (querySnapshot.docs.isEmpty) {
            throw Exception("Onboarding responses not found");
        }

        // Return the first document's data (assuming one response per user)
        final doc = querySnapshot.docs.first;
        print("Onboarding responses found: ${doc.data()}");
        return doc.data();
    }
}