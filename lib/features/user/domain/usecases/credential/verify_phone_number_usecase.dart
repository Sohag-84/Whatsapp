import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class VerifyPhoneNumberUsecase {
  final UserRepository userRepository;
  const VerifyPhoneNumberUsecase({required this.userRepository});

  Future<void> call({required String phoneNumber}) async {
    return await userRepository.verifyPhoneNumber(phoneNumber);
  }
}
