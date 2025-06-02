import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:whatsapp/core/const/app_const.dart';
import 'package:whatsapp/core/const/firebase_collection_const.dart';
import 'package:whatsapp/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:whatsapp/features/user/data/models/user_model.dart';
import 'package:whatsapp/features/user/domain/entities/contact_entity.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  UserRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  String verificationId = "";

  @override
  Future<void> createUser(UserEntity user) async {
    final userCollection = firestore.collection(FirebaseCollectionConst.users);
    final uid = await getCurrentUID();
    final newUser = UserModel(
      username: user.username,
      email: user.email,
      phoneNumber: user.phoneNumber,
      isOnline: user.isOnline,
      uid: uid,
      status: user.status,
      profileUrl: user.profileUrl,
    );
    try {
      userCollection.doc(uid).get().then((userDoc) {
        if (!userDoc.exists) {
          userCollection.doc(uid).set(newUser.toDocument());
        } else {
          userCollection.doc(uid).update(newUser.toDocument());
        }
      });
    } catch (e) {
      throw Exception("Error occure while creating user");
    }
  }

  @override
  Stream<List<UserEntity>> getAllUsers() {
    final userCollection = firestore.collection(FirebaseCollectionConst.users);
    return userCollection.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
    );
  }

  @override
  Future<String> getCurrentUID() async {
    return firebaseAuth.currentUser!.uid;
  }

  @override
  Future<List<ContactEntity>> getDeviceNumber() async {
    List<ContactEntity> contactsList = [];
    if (await FlutterContacts.requestPermission()) {
      List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );
      for (var contact in contacts) {
        contactsList.add(
          ContactEntity(
            name: contact.name,
            phones: contact.phones,
            photo: contact.photo,
          ),
        );
      }
    }

    return contactsList;
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) {
    final userCollection = firestore
        .collection(FirebaseCollectionConst.users)
        .where("uid", isEqualTo: uid);

    return userCollection.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList(),
    );
  }

  @override
  Future<bool> isSignIn() async => firebaseAuth.currentUser?.uid != null;

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsPinCode,
      );
      await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-verification-code") {
        toast("Invalid Verfication Code");
      }
      if (e.code == "quota exceeded") {
        toast("SMS Quota Exceeded");
      }
    } catch (e) {
      toast(e.toString());
    }
  }

  @override
  Future<void> signOut() async => await firebaseAuth.signOut();

  @override
  Future<void> updateUser(UserEntity user) async {
    final userCollection = firestore.collection(FirebaseCollectionConst.users);
    Map<String, dynamic> userInfo = {};

    if (user.username != "" && user.username != null) {
      userInfo['username'] = user.username;
    }
    if (user.status != "" && user.status != null) {
      userInfo['status'] = user.status;
    }
    if (user.profileUrl != "" && user.profileUrl != null) {
      userInfo['profileUrl'] = user.profileUrl;
    }
    if (user.isOnline != null) {
      userInfo['isOnline'] = user.isOnline;
    }

    userCollection.doc(user.uid).update(userInfo);
  }

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    phoneVerificationCompleted(AuthCredential authCredential) {
      print(
        "Phone verified:\nToken: ${authCredential.token}\nMethod: ${authCredential.signInMethod}",
      );
    }

    verificationFailed(FirebaseAuthException authExeption) {
      print(
        "Phone verification failed:\nMessage: ${authExeption.message}\nCode: ${authExeption.code}",
      );
    }

    codeAutoRetrievalTimeout(String verificationId) {
      this.verificationId = verificationId;
      print("Time out: $verificationId");
    }

    codeSent(String verificationId, int? forceResendingToken) {
      this.verificationId = verificationId;
    }

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided.");
      } else {
        throw Exception("Login failed: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  @override
  Future<void> signUp({required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        throw Exception(
          "The email address is already in use by another account.",
        );
      } else if (e.code == "invalid-email") {
        throw Exception("The email address is not valid.");
      } else if (e.code == "weak-password") {
        throw Exception("The password is too weak.");
      } else {
        throw Exception("Signup failed: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
