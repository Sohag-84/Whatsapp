import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class SigninWithPhoneNumberUsecase {
  final UserRepository userRepository;
  const SigninWithPhoneNumberUsecase({required this.userRepository});

  Future<void> call({required String smsPinCode}) async {
    return await userRepository.signInWithPhoneNumber(smsPinCode);
  }
}
