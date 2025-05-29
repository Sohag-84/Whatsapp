import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class SignupUsecase {
  final UserRepository userRepository;
  const SignupUsecase({required this.userRepository});

  Future<void> call({required String email, required String password}) async {
    return await userRepository.signUp(email: email, password: password);
  }
}
