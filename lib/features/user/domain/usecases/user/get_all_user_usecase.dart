import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class GetAllUserUsecase {
  final UserRepository userRepository;
  const GetAllUserUsecase({required this.userRepository});

  Stream<List<UserEntity>> call() {
    return userRepository.getAllUsers();
  }
}
