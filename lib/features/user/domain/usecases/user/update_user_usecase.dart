import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class UpdateUserUsecase {
  final UserRepository userRepository;
  const UpdateUserUsecase({required this.userRepository});

  Future<void> call({required UserEntity userEntity}) async {
    return await userRepository.updateUser(userEntity);
  }
}
