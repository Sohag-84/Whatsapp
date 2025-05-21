import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/domain/repository/user_repository.dart';

class GetSingleUserUsecase {
  final UserRepository userRepository;
  const GetSingleUserUsecase({required this.userRepository});

  Stream<List<UserEntity>> call({required String uid}) {
    return userRepository.getSingleUser(uid);
  }
}
