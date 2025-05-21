import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class IsSigninUsecase {
  final UserRepository userRepository;
  const IsSigninUsecase({required this.userRepository});

  Future<bool> call() async {
    return await userRepository.isSignIn();
  }
}
