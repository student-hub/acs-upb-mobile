import 'dart:typed_data';

import 'package:acs_upb_mobile/pages/feed/view/user_info_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../authentication/service/auth_provider.dart';
import '../../../resources/utils.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/toast.dart';
import '../../../widgets/upload_button.dart';
import '../service/post_provider.dart';
import 'widgets/post_header.dart';

class PostCreatePage extends StatefulWidget {
  const PostCreatePage({final Key key, this.className, this.refreshCallback})
      : super(key: key);

  final String className;
  final void Function() refreshCallback;

  static const String routeName = '/post_create';

  @override
  _PostCreatePageState createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  final postBodyController = TextEditingController();
  final searchController = TextEditingController();
  UploadButtonController uploadButtonController;
  String className;
  bool showClassesBottomMenu = false;
  Future<List<String>> classes;
  Uint8List imageAsPNG;

  @override
  void initState() {
    super.initState();
    final PostProvider _postProvider =
        Provider.of<PostProvider>(context, listen: false);
    final AuthProvider _authProvider =
        Provider.of<AuthProvider>(context, listen: false);

    uploadButtonController =
        UploadButtonController(onUpdate: () => setState(() => {}));
    if (widget.className != null) {
      className = widget.className;
    }
    classes = _postProvider
        .fetchUserClassIds(_authProvider.currentUserFromCache?.uid);
  }

  @override
  Widget build(final BuildContext context) {
    final AuthProvider _authProvider = Provider.of<AuthProvider>(context);
    final PostProvider _postProvider = Provider.of<PostProvider>(context);

    final bool isPhotoLoaded =
        uploadButtonController?.newUploadedImageBytes != null;
    return AppScaffold(
      actions: [
        AppScaffoldAction(
          text: 'Post',
          onPressed: () async {
            if (postBodyController.text == '' ||
                postBodyController.text == null) {
              AppToast.show('Post content cannot be empty');
              return;
            }

            if (className == null) {
              AppToast.show('Please select a class');
              return;
            }

            if (uploadButtonController.newUploadedImageBytes != null) {
              imageAsPNG = await Utils.convertToPNG(
                  uploadButtonController.newUploadedImageBytes);
            }

            await _postProvider.savePost({
              'text': postBodyController.text,
              'class': className,
            }, image: imageAsPNG);

            if (widget.refreshCallback != null) {
              widget.refreshCallback();
            }

            // ignore: use_build_context_synchronously
            Navigator.of(context).pop();
          },
        )
      ],
      body: Column(
        children: [
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: [
                _postHeader(_postProvider, _authProvider),
                _postBody(),
                if (!isPhotoLoaded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: UploadButton(
                      label: 'Picture',
                      controller: uploadButtonController,
                    ),
                  )
                else
                  _imageContainer(),
              ],
            ),
          ),
          if (showClassesBottomMenu) _classesBottomPannel(context),
        ],
      ),
    );
  }

  Padding _imageContainer() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          FittedBox(
              child:
                  Image.memory(uploadButtonController.newUploadedImageBytes)),
          IconButton(
            onPressed: () {
              setState(
                () {
                  uploadButtonController = UploadButtonController(
                      onUpdate: () => setState(() => {}));
                },
              );
            },
            icon: const Icon(Icons.delete),
            color: Colors.white,
          )
        ],
      ),
    );
  }

  SizedBox _classesBottomPannel(final BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      width: double.infinity,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 20,
            width: double.infinity,
            child: const Center(
              child: Text(
                'Classes',
                style: TextStyle(fontSize: 16),
              ),
            ),
            color: Theme.of(context).primaryColor,
          ),
          Expanded(
            child: FutureBuilder(
              future: classes,
              builder: (final context, final snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final List<String> classes = snapshot.data;
                return _classesBuilder(classes);
              },
            ),
          )
        ],
      ),
    );
  }

  ListView _classesBuilder(final List<String> classes) {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (final BuildContext context, final int index) {
        return GestureDetector(
          onTap: () => {
            setState(
              () => {className = classes[index], showClassesBottomMenu = false},
            )
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 4),
            child: Row(
              children: [
                CircleAvatar(
                  child: FittedBox(
                    child: Text(classes[index].split('-')[3]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    classes[index],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Padding _postBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextFormField(
          minLines: 5,
          maxLines: 15,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
              hintText: 'Enter text content...', border: OutlineInputBorder()),
          controller: postBodyController,
          validator: (final value) {
            if (value?.isEmpty ?? true) {
              return 'Please enter some content';
            }
            return null;
          }),
    );
  }

  Padding _postHeader(
      final PostProvider _postProvider, final AuthProvider _authProvider) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future: _postProvider.getProfilePictureURL(
                  _authProvider.currentUserFromCache?.uid),
              builder: (final context, final snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                      child: CircleAvatar(
                    backgroundImage: NetworkImage(placeholderImage),
                  ));
                }

                final String photoUrl = snapshot.data;
                return CircleAvatar(
                  backgroundImage: photoUrl != null
                      ? NetworkImage(photoUrl)
                      : const NetworkImage(placeholderImage),
                );
              }),
          _renderClass(_authProvider)
        ],
      ),
    );
  }

  Padding _renderClass(final AuthProvider _authProvider) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _authProvider.currentUserFromCache?.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          if (className != null)
            Row(
              children: [
                Text(
                  className,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      className = null;
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                  label: const Text(''),
                )
              ],
            )
          else
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add class'),
              onPressed: () {
                setState(() {
                  showClassesBottomMenu = !showClassesBottomMenu;
                });
              },
            )
        ],
      ),
    );
  }
}
