import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class GetMyStatusUsecase {
  final StatusRepository statusRepository;
  const GetMyStatusUsecase({required this.statusRepository});

  Stream<List<StatusEntity>> call({required String uid}) {
    return statusRepository.getMyStatus(uid: uid);
  }
}
