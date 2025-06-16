// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/core/const/firebase_collection_const.dart';
import 'package:whatsapp/features/chat/data/models/status_model.dart';
import 'package:whatsapp/features/status/data/data_source/status_remote_data_source.dart';
import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/enitties/status_image_entity.dart';

class StatusRemoteDataSourceImpl implements StatusRemoteDataSource {
  final FirebaseFirestore firestore;
  const StatusRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> createStatus({required StatusEntity status}) async {
    final statusCollection = firestore.collection(
      FirebaseCollectionConst.status,
    );

    final statusId = statusCollection.doc().id;

    final newStatus =
        StatusModel(
          imageUrl: status.imageUrl,
          profileUrl: status.profileUrl,
          uid: status.uid,
          createdAt: status.createdAt,
          phoneNumber: status.phoneNumber,
          username: status.username,
          statusId: statusId,
          caption: status.caption,
          stories: status.stories,
        ).toDocument();

    final statusDocRef = await statusCollection.doc(statusId).get();

    try {
      if (!statusDocRef.exists) {
        statusCollection.doc(statusId).set(newStatus);
      } else {
        return;
      }
    } catch (e) {
      print("Some error occur while creating status");
    }
  }

  @override
  Future<void> deleteStatus({required StatusEntity status}) async {
    final statusCollection = firestore.collection(
      FirebaseCollectionConst.status,
    );

    try {
      await statusCollection.doc(status.statusId).delete();
    } catch (e) {
      print("some error occur while deleting status");
    }
  }

  @override
  Stream<List<StatusEntity>> getMyStatus({required String uid}) {
    final statusCollection = firestore
        .collection(FirebaseCollectionConst.status)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .where(
          "createdAt",
          isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)),
        );

    return statusCollection.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs
              .where(
                (doc) => doc.data()['createdAt'].toDate().isAfter(
                  DateTime.now().subtract(const Duration(hours: 24)),
                ),
              )
              .map((e) => StatusModel.fromSnapshot(e))
              .toList(),
    );
  }

  @override
  Future<List<StatusEntity>> getMyStatusFuture({required String uid}) {
    final statusCollection = firestore
        .collection(FirebaseCollectionConst.status)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .where(
          "createdAt",
          isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)),
        );

    return statusCollection.get().then(
      (querySnapshot) =>
          querySnapshot.docs
              .where(
                (doc) => doc.data()['createdAt'].toDate().isAfter(
                  DateTime.now().subtract(const Duration(hours: 24)),
                ),
              )
              .map((e) => StatusModel.fromSnapshot(e))
              .toList(),
    );
  }

  @override
  Stream<List<StatusEntity>> getStatuses({required StatusEntity status}) {
    final statusCollection = firestore
        .collection(FirebaseCollectionConst.status)
        .where(
          "createdAt",
          isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)),
        );

    return statusCollection.snapshots().map(
      (querySnapshot) =>
          querySnapshot.docs
              .where(
                (doc) => doc.data()['createdAt'].toDate().isAfter(
                  DateTime.now().subtract(const Duration(hours: 24)),
                ),
              )
              .map((e) => StatusModel.fromSnapshot(e))
              .toList(),
    );
  }

  @override
  Future<void> seenStatusUpdate({
    required String statusId,
    required int imageIndex,
    required String userId,
  }) async {
    try {
      final statusDocRef = firestore
          .collection(FirebaseCollectionConst.status)
          .doc(statusId);

      final statusDoc = await statusDocRef.get();

      final stories = List<Map<String, dynamic>>.from(statusDoc.get('stories'));

      final viewersList = List<String>.from(stories[imageIndex]['viewers']);

      // Check if the user ID is already present in the viewers list
      if (!viewersList.contains(userId)) {
        viewersList.add(userId);

        // Update the viewers list for the specified image index
        stories[imageIndex]['viewers'] = viewersList;

        await statusDocRef.update({'stories': stories});
      }
    } catch (error) {
      print('Error updating viewers list: $error');
    }
  }

  @override
  Future<void> updateOnlyImageStatus({required StatusEntity status}) async {
    final statusCollection = firestore.collection(
      FirebaseCollectionConst.status,
    );

    final statusDocRef = await statusCollection.doc(status.statusId).get();

    try {
      if (statusDocRef.exists) {
        final existingStatusData = statusDocRef.data()!;
        final createdAt = existingStatusData['createdAt'].toDate();

        // check if the existing status is still within its 24 hours period
        if (createdAt.isAfter(
          DateTime.now().subtract(const Duration(hours: 24)),
        )) {
          // if it is, update the existing status with the new stores (images, or videos)

          final stories = List<Map<String, dynamic>>.from(
            statusDocRef.get('stories'),
          );

          stories.addAll(
            status.stories!.map((e) => StatusImageEntity.toJsonStatic(e)),
          );

          await statusCollection.doc(status.statusId).update({
            'stories': stories,
            'imageUrl': stories[0]['url'],
          });
          return;
        }
      } else {
        return;
      }
    } catch (e) {
      print("Some error occur while updating status stories");
    }
  }

  @override
  Future<void> updateStatus({required StatusEntity status}) async {
    final statusCollection = firestore.collection(
      FirebaseCollectionConst.status,
    );

    Map<String, dynamic> statusInfo = {};

    if (status.imageUrl != "" && status.imageUrl != null) {
      statusInfo['imageUrl'] = status.imageUrl;
    }

    if (status.stories != null) {
      statusInfo['stories'] = status.stories;
    }

    await statusCollection.doc(status.statusId).update(statusInfo);
  }
}
