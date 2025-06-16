import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';

abstract interface class StatusRepository {
  Future<void> createStatus({required StatusEntity status});
  Future<void> updateStatus({required StatusEntity status});
  Future<void> updateOnlyImageStatus({required StatusEntity status});
  Future<void> seenStatusUpdate({
    required String statusId,
    required int imageIndex,
    required String userId,
  });
  Future<void> deleteStatus({required StatusEntity status});
  Stream<List<StatusEntity>> getStatuses({required StatusEntity status});
  Stream<List<StatusEntity>> getMyStatus({required String uid});
  Future<List<StatusEntity>> getMyStatusFuture({required String uid});
}
