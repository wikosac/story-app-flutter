import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<AuthProvider, StoryProvider>(
      create: (_) => StoryProvider(apiService: ApiService()),
      update: (context, auth, story) => story!..getAllStories(auth.token),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                auth.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: const [
                Icon(Icons.menu),
                SizedBox(width: 16),
              ],
            ),
            body: switch (auth.state) {
              ResponseState.loading => const CircularProgressIndicator(),
              ResponseState.done => _buildContent(auth),
              ResponseState.error => const Text('Error'),
            },
          );
        },
      ),
    );
  }

  Widget _buildContent(AuthProvider auth) {
    return Consumer<StoryProvider>(
      builder: (context, story, _) {
        List<Story>? listData = story.listStory;
        List<Story> sortedList = [];
        if (listData != null) {
          for (var item in listData) {
            if (item.name == auth.name) sortedList.add(item);
          }
        }
        print('sorted: $sortedList');
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  profilePicture(78, 78, 48),
                  Column(
                    children: [
                      Text(
                        sortedList.length.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const Text('posts')
                    ],
                  ),
                  const Column(
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text('followers')
                    ],
                  ),
                  const Column(
                    children: [
                      Text(
                        '0',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text('following')
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
