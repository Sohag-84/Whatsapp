import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class UpdateImageOnlyStatusUsecase {
  final StatusRepository statusRepository;
  const UpdateImageOnlyStatusUsecase({required this.statusRepository});

  Future<void> call({required StatusEntity status}) async {
    return await statusRepository.updateOnlyImageStatus(status: status);
  }
}
