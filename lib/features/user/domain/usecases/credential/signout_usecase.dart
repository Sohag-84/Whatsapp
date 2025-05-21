import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class SignoutUsecase {
  final UserRepository userRepository;
  const SignoutUsecase({required this.userRepository});

  Future<void> call() async {
    return await userRepository.signOut();
  }
}
