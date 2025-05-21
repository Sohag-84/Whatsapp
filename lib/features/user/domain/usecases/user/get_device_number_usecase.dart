import 'package:whatsapp/features/user/domain/entities/contact_entity.dart';
import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class GetDeviceNumberUsecase {
  final UserRepository userRepository;
  const GetDeviceNumberUsecase({required this.userRepository});

  Future<List<ContactEntity>> call() async {
    return userRepository.getDeviceNumber();
  }
}
