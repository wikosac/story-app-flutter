import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/widgets.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
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
            ResponseState.loading =>
              const Center(child: CircularProgressIndicator()),
            ResponseState.done => _buildContent(auth),
            ResponseState.error => const Center(child: Text('Error')),
          },
        );
      },
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
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Row(
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              auth.email,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              '"If there is a will, there is a way"\n THIS IS THE WAY',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(Icons.grid_view_outlined, size: 24),
                      Icon(
                        Icons.ondemand_video,
                        size: 24,
                        color: Colors.grey,
                      ),
                      Icon(
                        Icons.person_pin_outlined,
                        size: 24,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  _buildgridView(sortedList),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  GridView _buildgridView(List<Story> myPost) {
    return GridView.builder(
      itemCount: myPost.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () => context.goNamed(
            Routes.detail,
            pathParameters: {'id': myPost[index].id},
          ),
          child: Image.network(
            myPost[index].photoUrl,
            fit: BoxFit.cover,
          ),
        );
      },
      shrinkWrap: true,
    );
  }
}
