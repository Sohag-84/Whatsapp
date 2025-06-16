import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class CreateStatusUsecase {
  final StatusRepository statusRepository;
  const CreateStatusUsecase({required this.statusRepository});

  Future<void> call({required StatusEntity status}) async {
    return await statusRepository.createStatus(status: status);
  }
}
