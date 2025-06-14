import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/core/const/page_const.dart';
import 'package:whatsapp/core/theme/style.dart';
import 'package:whatsapp/features/call/presentation/pages/call_history_page.dart';
import 'package:whatsapp/features/chat/presentation/pages/chat_page.dart';
import 'package:whatsapp/features/status/presentation/pages/status_page.dart';
import 'package:whatsapp/features/user/domain/entities/user_entity.dart';
import 'package:whatsapp/features/user/presentation/cubit/user/user_cubit.dart';

class HomePage extends StatefulWidget {
  final String uid;
  const HomePage({super.key, required this.uid});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? _tabController;
  int currentTabIndex = 0;

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
          const Icon(Icons.camera_alt_outlined, color: greyColor, size: 28),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                "Status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Tab(
              child: Text(
                "Calls",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: switchFloatingActionButtonOnTabIndex(
        currentTabIndex,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [ChatPage(uid: widget.uid), StatusPage(), CallHistoryPage()],
      ),
    );
  }

  switchFloatingActionButtonOnTabIndex(int index) {
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
          onPressed: () {},
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
}
