import 'package:flutter/material.dart';
import 'package:whatsapp/core/theme/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int currentTabIndex = 0;

  @override
  void initState() {
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
        actions: [
          Row(
            children: [
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
                          onTap: () {},
                          child: const Text('Settings'),
                        ),
                      ),
                    ],
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
        children: [
          Center(child: Text("Chat Page")),
          Center(child: Text("Status Page")),
          Center(child: Text("Call History Page")),
        ],
      ),
    );
  }

  switchFloatingActionButtonOnTabIndex(int index) {
    switch (index) {
      case 0:
        return FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: () {},
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
          onPressed: () {},
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
