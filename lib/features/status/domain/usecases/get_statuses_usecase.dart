import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class GetStatusesUsecase {
  final StatusRepository statusRepository;
  const GetStatusesUsecase({required this.statusRepository});

  Stream<List<StatusEntity>> call({required StatusEntity status}) {
    return statusRepository.getStatuses(status: status);
  }
}
