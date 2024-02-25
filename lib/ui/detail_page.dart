import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/utils.dart';
import 'package:story_app/utils/widgets.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AuthProvider, StoryProvider>(
      create: (context) => StoryProvider(apiService: ApiService()),
      update: (context, auth, story) {
        return story!..getDetailStory(auth.token!, id);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Post',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer<StoryProvider>(builder: (context, provider, _) {
          Story? story = provider.story;
          switch (provider.state) {
            case ResponseState.loading:
              return const Center(child: CircularProgressIndicator());
            case ResponseState.done:
              return story != null
                  ? _buildContent(context, story)
                  : const Text('No data');
            case ResponseState.error:
              return const Text('Error');
            case null:
              return const Text('Error: state null');
          }
        }),
        bottomNavigationBar: Consumer<StoryProvider>(
          builder: (context, provider, _) {
            Story? story = provider.story;
            return provider.state == ResponseState.done && story != null
                ? _commentField()
                : Container();
          },
        ),
      ),
    );
  }

  Widget _commentField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Add a comment',
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(36.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Story story) {
    return SingleChildScrollView(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(story.description, textAlign: TextAlign.start),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
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
                            ? event.cumulativeBytesLoaded / event.expectedTotalBytes!
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.favorite, color: Colors.red),
                Icon(Icons.mode_comment_outlined),
                Icon(Icons.send),
                Icon(Icons.bookmark_border_rounded),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          const Text(
            'No comments yet',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}
