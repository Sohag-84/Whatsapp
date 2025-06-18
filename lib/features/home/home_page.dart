// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/core/global/widgets/loader.dart';
import 'package:whatsapp/core/global/widgets/show_image_and_video_widget.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/call/presentation/pages/call_history_page.dart';
import 'package:whatsapp/features/chat/presentation/pages/chat_page.dart';
import 'package:whatsapp/features/status/domain/enitties/status_entity.dart';
import 'package:whatsapp/features/status/domain/enitties/status_image_entity.dart';
import 'package:whatsapp/features/status/domain/usecases/get_my_status_future_usecase.dart';
import 'package:whatsapp/features/status/presentation/cubit/status/status_cubit.dart';
import 'package:whatsapp/features/status/presentation/pages/status_page.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:whatsapp/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:path/path.dart' as path;
import 'package:whatsapp/main_injection_container.dart' as di;
import 'package:whatsapp/storage/storage_provider.dart';

class HomePage extends StatefulWidget {
  final String uid;
  final int? index;
  const HomePage({super.key, required this.uid, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int currentTabIndex = 0;

  List<StatusImageEntity> stories = [];

  List<File>? _selectedMedia;
  List<String>? _mediaTypes;

  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();

        // Initialize the media types list
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');

        // Determine the type of each selected file
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension =
              path.extension(_selectedMedia![i].path).toLowerCase();
          if (extension == '.jpg' ||
              extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' ||
              extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }

        setState(() {});
        print("mediaTypes = $_mediaTypes");
      } else {
        print("No file is selected.");
      }
    } catch (e) {
      print("Error while picking file: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<UserCubit>().updateUser(
          userEntity: UserEntity(uid: widget.uid, isOnline: true),
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        context.read<UserCubit>().updateUser(
          userEntity: UserEntity(uid: widget.uid, isOnline: false),
        );
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        currentTabIndex = _tabController!.index;
      });
    });

    context.read<GetSingleUserCubit>().getSingleUser(uid: widget.uid);
    if (widget.index != null) {
      setState(() {
        currentTabIndex = widget.index!;
        _tabController!.animateTo(1);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {
        if (state is GetSingleUserLoading) {
          return loader();
        }
        if (state is GetSingleUserLoaded) {
          final currentUser = state.singleUser;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "WhatsApp",

                style: TextStyle(
                  fontSize: 20,
                  color: greyColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: false,
              actions: [
                const Icon(
                  Icons.camera_alt_outlined,
                  color: greyColor,
                  size: 28,
                ),
                const SizedBox(width: 25),
                const Icon(Icons.search, color: greyColor, size: 28),
                const SizedBox(width: 10),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: greyColor, size: 28),
                  color: appBarColor,
                  iconSize: 28,
                  onSelected: (value) {},
                  itemBuilder:
                      (context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: "Settings",
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PageConst.settingsPage,
                                arguments: widget.uid,
                              );
                            },
                            child: const Text('Settings'),
                          ),
                        ),
                      ],
                ),
              ],
              bottom: TabBar(
                labelColor: tabColor,
                unselectedLabelColor: greyColor,
                indicatorColor: tabColor,
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: Text(
                      "Chats",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Calls",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: switchFloatingActionButtonOnTabIndex(
              currentTabIndex,
              currentUser,
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                ChatPage(uid: widget.uid),
                StatusPage(currentUser: currentUser),
                CallHistoryPage(),
              ],
            ),
          );
        }
        if (state is GetSingleUserFailure) {
          return Scaffold(body: Center(child: Text(state.error)));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  switchFloatingActionButtonOnTabIndex(int index, UserEntity currentUser) {
    switch (index) {
      case 0:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            Navigator.pushNamed(
              context,
              PageConst.contactUsersPage,
              arguments: widget.uid,
            );
          },
          child: const Icon(Icons.message, color: Colors.white),
        );

      case 1:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            selectMedia().then((value) {
              if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  context: context,
                  builder: (context) {
                    return ShowMultiImageAndVideoPickedWidget(
                      selectedFiles: _selectedMedia!,
                      onTap: () {
                        _uploadImageStatus(currentUser);
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              }
            });
          },
          child: const Icon(Icons.camera_alt, color: Colors.white),
        );

      case 2:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {
            Navigator.pushNamed(context, PageConst.callContactsPage);
          },
          child: const Icon(Icons.add_call, color: Colors.white),
        );

      default:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {},
          child: const Icon(Icons.message, color: Colors.white),
        );
    }
  }

  _uploadImageStatus(UserEntity currentUser) {
    StorageProviderRemoteDataSource.uploadStatuses(
      files: _selectedMedia!,
      onComplete: (onCompleteStatusUpload) {},
    ).then((statusImageUrls) {
      for (var i = 0; i < statusImageUrls.length; i++) {
        stories.add(
          StatusImageEntity(
            url: statusImageUrls[i],
            type: _mediaTypes![i],
            viewers: const [],
          ),
        );
      }

      di.sl<GetMyStatusFutureUsecase>().call(uid: widget.uid).then((myStatus) {
        if (myStatus.isNotEmpty) {
          BlocProvider.of<StatusCubit>(context)
              .updateOnlyImageStatus(
                status: StatusEntity(
                  statusId: myStatus.first.statusId,
                  stories: stories,
                ),
              )
              .then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(uid: widget.uid, index: 1),
                  ),
                );
              });
        } else {
          BlocProvider.of<StatusCubit>(context)
              .createStatus(
                status: StatusEntity(
                  caption: "",
                  createdAt: Timestamp.now(),
                  stories: stories,
                  username: currentUser.username,
                  uid: currentUser.uid,
                  profileUrl: currentUser.profileUrl,
                  imageUrl: statusImageUrls[0],
                  phoneNumber: currentUser.phoneNumber,
                ),
              )
              .then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HomePage(uid: widget.uid, index: 1),
                  ),
                );
              });
        }
      });
    });
  }
}
