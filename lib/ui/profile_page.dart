import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/model/stories_response.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future _onRefresh() async {
    context.read<StoryProvider>().refresh();
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
                  () => context.goNamed(Routes.dialog),
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
            ResponseState.error => Center(
                child: Text(AppLocalizations.of(context)!.networkError),
              ),
          },
        );
      },
    );
  }

  Widget _buildContent(AuthProvider auth) {
    return Consumer<StoryProvider>(
      builder: (context, story, _) {
        List<Story>? allStory = story.listStory;
        List<Story> myPost = [];
        if (allStory != null) {
          for (var item in allStory) {
            if (item.name == auth.name) myPost.add(item);
          }
        }
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        profilePicture(78, 78, 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  myPost.length.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(AppLocalizations.of(context)!.posts)
                              ],
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                            Column(
                              children: [
                                const Text(
                                  '0',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(AppLocalizations.of(context)!.followers)
                              ],
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                            Column(
                              children: [
                                const Text(
                                  '0',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(AppLocalizations.of(context)!.following)
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
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
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width - 32, 42),
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Edit Profile'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          child: const ClipOval(
                            child: Icon(Icons.add, size: 36),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.grid_view_outlined,
                        size: 28,
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.ondemand_video,
                        size: 28,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.person_pin_outlined,
                        size: 28,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  myPost.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.noPost,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : _buildGridView(myPost),
                ],
              ),
            ),
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
      physics: const NeverScrollableScrollPhysics(),
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

  void showBottomSheetDialog(BuildContext context, void Function() onclick) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => onclick(),
                  child: Row(
                    children: [
                      const Icon(Icons.logout, color: Colors.red),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.logout,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
