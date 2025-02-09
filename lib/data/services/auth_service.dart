import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_app/data/services/user_service.dart';
import '../../utils/validation_utils.dart';
import '../models/user.dart';
import '../enums/user_role.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final UserService _userService = UserService();

  Future<UserCredential?> registerUser({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    try {
      if (!ValidationUtils.isValidName(firstName)) {
        throw Exception("First name should only contain letters.");
      }

      if (!ValidationUtils.isValidName(lastName)) {
        throw Exception("Last name should only contain letters.");
      }

      if (!ValidationUtils.isValidPhoneNumber(phoneNumber)) {
        throw Exception(
            "Phone number should contain only numbers (9 to 15 digits) and optional +");
      }

      if (!ValidationUtils.isValidEmail(email)) {
        throw Exception("Email must contain '@'.");
      }

      bool userExists = await _userService.checkUserExistsByEmailOrPhone(
          email: email, phoneNumber: phoneNumber);
      if (userExists) {
        throw Exception("The email or phone number is already registered.");
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      UserModel newUser = UserModel(
        id: userId,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        email: email,
        role: UserRole.CLIENT,
      );

      await _firestore.collection('users').doc(userId).set(newUser.toJson());

      return userCredential;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> logoutUser() async {
    await _auth.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
