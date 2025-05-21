import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class GetCurrentUidUsecase {
  final UserRepository userRepository;
  const GetCurrentUidUsecase({required this.userRepository});

  Future<String> call() async {
    return await userRepository.getCurrentUID();
  }
}
