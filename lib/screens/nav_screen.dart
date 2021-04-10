import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui_clone/data.dart';
import 'package:flutter_youtube_ui_clone/screens/home_screen.dart';
import 'package:flutter_youtube_ui_clone/screens/video_screen.dart';
import 'package:miniplayer/miniplayer.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);
final miniPlayerControllerProvider =
    StateProvider<MiniplayerController>((ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final double _playerMinHight = 60.0;
  int _selectedIndex = 0;

  final _screens = [
    HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text("Explore"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Add"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Subscriptions"),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text("Library"),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, child) {
          final selectedVideo = watch(selectedVideoProvider).state;
          final miniPlayerController =
              watch(miniPlayerControllerProvider).state;
          return Stack(
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                    i,
                    Offstage(
                      offstage: _selectedIndex != i,
                      child: screen,
                    )))
                .values
                .toList()
                  ..add(Offstage(
                    offstage: selectedVideo == null,
                    child: Miniplayer(
                      controller: miniPlayerController,
                      minHeight: _playerMinHight,
                      maxHeight: MediaQuery.of(context).size.height,
                      builder: (height, percentage) {
                        if (selectedVideo == null) return SizedBox.shrink();
                        if (height <= _playerMinHight + 220.0)
                          return Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.network(
                                      selectedVideo.thumbnailUrl,
                                      height: _playerMinHight - 4.0,
                                      width: 120.0,
                                      fit: BoxFit.cover,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                selectedVideo.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                selectedVideo.author.username,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.play_arrow),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        context
                                            .read(selectedVideoProvider)
                                            .state = null;
                                      },
                                    ),
                                  ],
                                ),
                                LinearProgressIndicator(
                                  value: 0.4,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.red),
                                )
                              ],
                            ),
                          );
                        return VideoScreen();
                      },
                    ),
                  )),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() {
          _selectedIndex = i;
          context
              .read(miniPlayerControllerProvider)
              .state
              .animateToHeight(state: PanelState.MIN);
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions_outlined),
            activeIcon: Icon(Icons.subscriptions),
            label: "Subscriptions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: "Library",
          ),
        ],
      ),
    );
  }
}
