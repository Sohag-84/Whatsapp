import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class SeenStatusUpdateUsecase {
  final StatusRepository statusRepository;
  const SeenStatusUpdateUsecase({required this.statusRepository});

  Future<void> call({
    required String statusId,
    required int imageIndex,
    required String userId,
  }) {
    return statusRepository.seenStatusUpdate(
      statusId: statusId,
      imageIndex: imageIndex,
      userId: userId,
    );
  }
}
