import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui_clone/screens/nav_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final selectedVideo = watch(selectedVideoProvider).state;
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              Column(
                children: [
                  Image.network(
                    selectedVideo!.thumbnailUrl,
                    height: 220.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  LinearProgressIndicator(
                    value: 0.4,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(top: 8.0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedVideo.title,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontSize: 15.0),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            '${selectedVideo.viewCount} views . ${timeago.format(selectedVideo.timestamp)}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
