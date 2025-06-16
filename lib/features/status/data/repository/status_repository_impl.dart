import 'package:whatsapp/features/status/data/data_source/status_remote_data_source.dart';
import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/repository/status_repository.dart';

class StatusRepositoryImpl implements StatusRepository {
  final StatusRemoteDataSource statusRemoteDataSource;
  const StatusRepositoryImpl({required this.statusRemoteDataSource});
  @override
  Future<void> createStatus({required StatusEntity status}) async {
    return await statusRemoteDataSource.createStatus(status: status);
  }

  @override
  Future<void> deleteStatus({required StatusEntity status}) async =>
      await statusRemoteDataSource.deleteStatus(status: status);

  @override
  Stream<List<StatusEntity>> getMyStatus({required String uid}) {
    return statusRemoteDataSource.getMyStatus(uid: uid);
  }

  @override
  Future<List<StatusEntity>> getMyStatusFuture({required String uid}) async {
    return await statusRemoteDataSource.getMyStatusFuture(uid: uid);
  }

  @override
  Stream<List<StatusEntity>> getStatuses({required StatusEntity status}) {
    return statusRemoteDataSource.getStatuses(status: status);
  }

  @override
  Future<void> seenStatusUpdate({
    required String statusId,
    required int imageIndex,
    required String userId,
  }) async {
    return await statusRemoteDataSource.seenStatusUpdate(
      statusId: statusId,
      imageIndex: imageIndex,
      userId: userId,
    );
  }

  @override
  Future<void> updateOnlyImageStatus({required StatusEntity status}) async {
    return await statusRemoteDataSource.updateOnlyImageStatus(status: status);
  }

  @override
  Future<void> updateStatus({required StatusEntity status}) async {
    return await statusRemoteDataSource.updateStatus(status: status);
  }
}
