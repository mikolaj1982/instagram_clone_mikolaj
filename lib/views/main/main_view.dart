import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone_mikolaj/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone_mikolaj/state/image_upload/models/file_type.dart';
import 'package:instagram_clone_mikolaj/views/components/constants/strings.dart';
import 'package:instagram_clone_mikolaj/views/components/dialogs/logout_dialog.dart';
import 'package:instagram_clone_mikolaj/views/components/post/create_new_post_view.dart';
import 'package:instagram_clone_mikolaj/views/tabs/user_posts/user_posts_view.dart';

// for when you are already logged in
class MainView extends ConsumerStatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.film),
                onPressed: () async {},
              ),
              IconButton(
                icon: const Icon(Icons.add_photo_alternate_outlined),
                onPressed: () async {
                  //pick image first
                  final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery).toFile();
                  if (imageFile == null) {
                    return;
                  }
                  if (!mounted) {
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreateNewPostView(
                        type: FileType.image,
                        fileToPost: imageFile,
                      ),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  final shouldLogout = await const LogoutDialog().present(context).then(
                        (value) => value ?? false,
                      );
                  if (shouldLogout) {
                    ref.read(authStateProvider.notifier).logOut();
                  }
                },
              ),
            ],
            title: const Text(Strings.appName),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.person),
                ),
                Tab(
                  icon: Icon(Icons.search),
                ),
                Tab(
                  icon: Icon(Icons.home),
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              UserPostsView(),
              Center(child: Text('Search')),
              Center(child: Text('Home')),
            ],
          ),
        ));
  }
}

extension ToFile on Future<XFile?> {
  Future<File?> toFile() => then((xFile) => xFile?.path).then((filePath) => filePath != null ? File(filePath) : null);
}
