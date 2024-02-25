import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/common/style.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/provider/auth_provider.dart';
import 'package:story_app/data/provider/picture_provider.dart';
import 'package:story_app/data/provider/story_provider.dart';
import 'package:story_app/route/router.dart';
import 'package:story_app/utils/response_state.dart';
import 'package:story_app/utils/utils.dart';

class UploadPage extends StatefulWidget {
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PictureProvider(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.pop();
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.uploadTitle,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Consumer<PictureProvider>(
          builder: (context, provider, state) {
            return SingleChildScrollView(
              child: _buildContent(context, provider),
            );
          },
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer3<StoryProvider, AuthProvider, PictureProvider>(
            builder: (context, provider, auth, pict, state) {
              return ElevatedButton(
                onPressed: () => onSubmit(pict, provider, auth, context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightTheme.primary,
                  foregroundColor: lightTheme.onPrimary,
                ),
                child: provider.state == ResponseState.loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(AppLocalizations.of(context)!.shareButton),
              );
            },
          ),
        ),
      ),
    );
  }

  void onSubmit(
    PictureProvider pict,
    StoryProvider provider,
    AuthProvider auth,
    BuildContext context,
  ) async {
    if (descController.text.isNotEmpty && pict.imageFile != null) {
      if (provider.state == ResponseState.error && context.mounted) {
        showSnackBar(context, AppLocalizations.of(context)!.networkError);
      }
      final bytes = await pict.imageFile!.readAsBytes();
      ApiResponse response = await provider.addStory(
        token: auth.token!,
        desc: descController.text,
        fileName: pict.imageFile!.name,
        bytes: bytes,
      );
      if (context.mounted) showSnackBar(context, response.message);
      if (response.error == false && context.mounted) {
        provider.getAllStories(auth.token!);
        context.pop();
      }
      ;
    } else {
      String msg = '';
      if (descController.text.isEmpty) msg = AppLocalizations.of(context)!.captionWarning;
      if (pict.imageFile == null) msg = AppLocalizations.of(context)!.pictureWarning;
      showSnackBar(context, msg);
    }
  }

  Column _buildContent(BuildContext context, PictureProvider provider) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              child: provider.imagePath == null
                  ? Container(
                      color: Colors.black,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          color: Colors.white,
                          Icons.image,
                          size: 100,
                        ),
                      ),
                    )
                  : provider.state == ResponseState.loading
                      ? const Center(child: CircularProgressIndicator())
                      : Image.file(
                          File(provider.imagePath.toString()),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Placeholder();
                          },
                        ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => provider.onGalleryView(),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: const ClipOval(
                          child: Icon(Icons.image_outlined, size: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () => provider.onCameraView(),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child: const ClipOval(
                          child: Icon(Icons.camera_alt_outlined, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
          child: TextField(
            controller: descController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppLocalizations.of(context)!.captionDescription,
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(8.0),
            ),
            maxLines: null,
          ),
        ),
        const Divider(thickness: 0.5),
      ],
    );
  }
}
