import 'package:flutter/material.dart';
import 'package:flutter_app_stulish/pages/friend_list/friend_list.dart';
import 'package:flutter_app_stulish/pages/friend_list/ranking_list.dart';

class AllUser extends StatefulWidget {
  const AllUser({Key? key}) : super(key: key);

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> with SingleTickerProviderStateMixin {
  int indexTab = 0;
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0)
      ..addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 55, right: 20, left: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              indexTab == 0 ? "CARI TEMAN" : "RANKING",
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.circular(7)),
                child: Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.all(5),
                      child: TabBar(
                        // isScrollable: true,
                        unselectedLabelColor: Colors.white,
                        labelColor: Colors.white,
                        indicatorColor: Colors.white,
                        indicatorWeight: 1,
                        indicator: BoxDecoration(
                          color: Color(0xFFF5A720),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        controller: _tabController,
                        onTap: (index) {
                          setState(() {
                            indexTab = index;
                          });
                        },
                        tabs: [
                          Tab(
                            text: 'CARI TEMAN',
                          ),
                          Tab(
                            text: 'RANKING',
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  FriendList(),
                  RankingList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
