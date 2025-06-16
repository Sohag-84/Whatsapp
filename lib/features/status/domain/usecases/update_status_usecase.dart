import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class UpdateStatusUsecase {
  final StatusRepository statusRepository;
  const UpdateStatusUsecase({required this.statusRepository});

  Future<void> call({required StatusEntity status}) async {
    return await statusRepository.updateStatus(status: status);
  }
}
