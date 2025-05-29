import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class LoginUsecase {
  final UserRepository userRepository;
  const LoginUsecase({required this.userRepository});

  Future<void> call({required String email, required String password}) async {
    return await userRepository.login(email: email, password: password);
  }
}
