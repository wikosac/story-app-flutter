import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/utils.dart';
import 'package:story_app/utils/widgets.dart';
import 'package:story_app/variant/flavor_config.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future _onRefresh() async {
    context.read<StoryProvider>().refresh();
  }

  @override
  void initState() {
    super.initState();
    final sp = context.read<StoryProvider>();

    sp.scrollController.addListener(() {
      if (sp.scrollController.position.pixels >=
          sp.scrollController.position.maxScrollExtent) {
        if (sp.pageItems != null) {
          sp.getAllStories();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.read<StoryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Story App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              FlavorConfig.instance.values.appType,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.favorite_border),
          const SizedBox(width: 16),
          const Icon(Icons.messenger_outline),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          controller: sp.scrollController,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        story.lat != null
                            ? FutureBuilder<String>(
                                future: _getLocation(story),
                                builder: (_, snapshot) {
                                  return Text(
                                    snapshot.data ?? '',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  );
                                },
                              )
                            : const SizedBox(),
                      ],
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
      List<Story> allStory = provider.allStory;
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
          return allStory.isNotEmpty
              ? ListView.builder(
                  itemCount:
                      allStory.length + (provider.pageItems != null ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == allStory.length &&
                        provider.pageItems != null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _postItem(context, allStory[index]),
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

  Future<String> _getLocation(Story story) async {
    final latLng = LatLng(story.lat!, story.lon!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    return place.subLocality ?? '';
  }
}
