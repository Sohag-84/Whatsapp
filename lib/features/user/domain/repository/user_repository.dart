import 'package:whatsapp/features/user/domain/entities/contact_entity.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';

abstract interface class UserRepository {
  Future<void> verifyPhoneNumber(String phoneNumber);
  Future<void> signInWithPhoneNumber(String smsPinCode);
  Future<void> signUp({required String email, required String password});
  Future<void> login({required String email, required String password});

  Future<bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUID();
  Future<void> createUser(UserEntity user);
  Future<void> updateUser(UserEntity user);
  Stream<List<UserEntity>> getAllUsers();
  Stream<List<UserEntity>> getSingleUser(String uid);

  Future<List<ContactEntity>> getDeviceNumber();
}
