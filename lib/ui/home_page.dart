import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/utils/response_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story App'),
        actions: const [
          Icon(Icons.favorite_border),
          SizedBox(width: 16),
          Icon(Icons.messenger_outline),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16.0, right: 16, left: 16),
              child: Row(
                children: [
                  _profilePicture(78, 78, 48),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildPostList(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profilePicture(double width, double height, double size) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.pink, // Change border color as needed
          width: 2.0,
        ),
      ),
      child: ClipOval(
        child: Icon(Icons.person, size: size),
      ),
    );
  }

  Widget _postItem(Story story) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  _profilePicture(42, 42, 16),
                  const SizedBox(width: 8),
                  Text('Anon'),
                ],
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
        Image.network(
          story.photoUrl,
          fit: BoxFit.cover,
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text('username'),
              SizedBox(width: 8),
              Text('desc'),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'Jan 11, 2024',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPostList(BuildContext context) {
    return Consumer<StoryProvider>(builder: (context, provider, _) {
      List<Story>? data = provider.listStory;
      switch (provider.state) {
        case ResponseState.loading:
          return const CircularProgressIndicator();
        case ResponseState.done:
          return data != null
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: _postItem(data[index]),
                    );
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                )
              : const Text('No data');
        case ResponseState.error:
          return const Text('Error');
        case null:
          return const Text('Error: state null');
      }
    });
  }
}
