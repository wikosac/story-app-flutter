import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/auth_provider.dart';
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
          SizedBox(
            width: 12,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: _buildStories(),
            ),
            _buildPostList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStories() {
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.pink, // Change border color as needed
              width: 2.0,
            ),
          ),
          child: const ClipOval(
            child: Icon(Icons.person),
          ),
        ),
      ],
    );
  }

  Widget _imagePost(Story story) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Image.network(
          story.photoUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPostList(BuildContext context) {
    return Consumer<StoryProvider>(builder: (context, provider, _) {
      List<Story>? data = provider.listStory;
      print('data: $data');
      switch (provider.state) {
        case ResponseState.loading:
          return const CircularProgressIndicator();
        case ResponseState.done:
          return data != null
              ? ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _imagePost(data[index]);
                  },
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
