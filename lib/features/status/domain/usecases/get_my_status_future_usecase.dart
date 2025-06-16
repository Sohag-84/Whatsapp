import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class GetMyStatusFutureUsecase {
  final StatusRepository statusRepository;
  const GetMyStatusFutureUsecase({required this.statusRepository});

  Future<List<StatusEntity>> call({required String uid}) {
    return statusRepository.getMyStatusFuture(uid: uid);
  }
}
