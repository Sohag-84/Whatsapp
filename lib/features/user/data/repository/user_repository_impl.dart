import 'package:whatsapp/features/user/data/data_sources/user_remote_data_source.dart';
import 'package:whatsapp/features/user/domain/entities/contact_entity.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  const UserRepositoryImpl({required this.userRemoteDataSource});

  @override
  Future<void> createUser(UserEntity user) async =>
      await userRemoteDataSource.createUser(user);

  @override
  Stream<List<UserEntity>> getAllUsers() => userRemoteDataSource.getAllUsers();

  @override
  Future<String> getCurrentUID() async {
    return await userRemoteDataSource.getCurrentUID();
  }

  @override
  Future<List<ContactEntity>> getDeviceNumber() async {
    return await userRemoteDataSource.getDeviceNumber();
  }

  @override
  Stream<List<UserEntity>> getSingleUser(String uid) =>
      userRemoteDataSource.getSingleUser(uid);

  @override
  Future<bool> isSignIn() async => await userRemoteDataSource.isSignIn();

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async =>
      await userRemoteDataSource.signInWithPhoneNumber(smsPinCode);

  @override
  Future<void> signOut() async => await userRemoteDataSource.signOut();

  @override
  Future<void> updateUser(UserEntity user) async =>
      await userRemoteDataSource.updateUser(user);

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async =>
      await userRemoteDataSource.verifyPhoneNumber(phoneNumber);

  @override
  Future<void> login({required String email, required String password}) {
    return userRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> signUp({required String email, required String password}) {
    return userRemoteDataSource.signUp(email: email, password: password);
  }
}
