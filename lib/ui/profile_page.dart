import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/utils.dart';
import 'package:story_app/utils/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Text(
                  auth.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Icon(Icons.keyboard_arrow_down)
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => showBottomSheetDialog(
                  context,
                  () => _showLogoutConfirmationDialog(context),
                ),
                icon: const Icon(Icons.menu),
              ),
              const SizedBox(width: 16),
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
        return SmartRefresher(
          controller: _refreshController,
          onRefresh: () => _onRefresh(),
          child: Column(
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
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                    sortedList.isEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text('No Post'),
                            ),
                          )
                        : _buildGridView(sortedList),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  GridView _buildGridView(List<Story> myPost) {
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
              return const Icon(Icons.broken_image, size: 48);
            },
          ),
        );
      },
      shrinkWrap: true,
    );
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log Out'),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            Consumer<AuthProvider>(
              builder: (context, auth, _) {
                return TextButton(
                  onPressed: () {
                    auth.deleteCredential();
                    context.goNamed(Routes.login);
                    showSnackBar(context, 'Logged Out!');
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
