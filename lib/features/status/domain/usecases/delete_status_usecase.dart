import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class DeleteStatusUsecase {
  final StatusRepository statusRepository;
  const DeleteStatusUsecase({required this.statusRepository});

  Future<void> call({required StatusEntity status}) async {
    return await statusRepository.deleteStatus(status: status);
  }
}
