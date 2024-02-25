import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/utils.dart';
import 'package:story_app/utils/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    StoryProvider sp = Provider.of(context, listen: false);
    AuthProvider ap = Provider.of(context, listen: false);
    sp.getAllStories(ap.token!);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Story App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Icon(Icons.favorite_border),
          SizedBox(width: 16),
          Icon(Icons.messenger_outline),
          SizedBox(width: 16),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: () => _onRefresh(),
        child: SingleChildScrollView(
          child: _buildContent(context),
        ),
      ),
    );
  }

  Column _buildContent(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
          child: Row(
            children: [
              profilePicture(78, 78, 48),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: _buildPostList(context),
        ),
      ],
    );
  }

  Widget _postItem(BuildContext context, Story story) {
    return GestureDetector(
      onTap: () {
        context.goNamed(
          Routes.detail,
          pathParameters: {'id': story.id},
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    profilePicture(42, 42, 16),
                    const SizedBox(width: 8),
                    Text(
                      story.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.more_vert),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: Image.network(
              story.photoUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, event) {
                if (event == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: event.expectedTotalBytes != null
                          ? event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (context, obj, trace) {
                return const Icon(Icons.broken_image, size: 100);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.mode_comment_outlined),
                    SizedBox(width: 16),
                    Icon(Icons.send),
                  ],
                ),
                Icon(Icons.bookmark_border_rounded),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  story.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    story.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  convertDateTime(story.createdAt),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostList(BuildContext context) {
    return Consumer<StoryProvider>(builder: (context, provider, _) {
      List<Story>? data = provider.listStory;
      switch (provider.state) {
        case ResponseState.loading:
          return SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        case ResponseState.done:
          return data != null
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _postItem(context, data[index]),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(AppLocalizations.of(context)!.noData),
                  ),
                );
        case ResponseState.error:
          return SizedBox(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(AppLocalizations.of(context)!.networkError),
            ),
          );
        case null:
          return const Text('Error: state null');
      }
    });
  }
}
