import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import '../../../authentication/model/user.dart';
import '../../../widgets/scaffold.dart';
import '../../../widgets/search_bar.dart';
import '../../classes/model/class.dart';
import '../service/post_provider.dart';
import 'class_page.dart';
import 'user_info_page.dart';

class Debounce {
  Debounce(
    this.delay,
  );

  Duration delay;
  Timer _timer;

  void call(final void Function() callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}

class FeedSearchPage extends StatefulWidget {
  const FeedSearchPage({final Key key}) : super(key: key);

  @override
  _FeedSearchPageState createState() => _FeedSearchPageState();
}

class _FeedSearchPageState extends State<FeedSearchPage> {
  String query;
  bool usersChip = true;
  bool classesChip = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);
    return AppScaffold(
      title: const Text('Search'),
      body: ListView(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Users'),
                onSelected: (final value) {
                  setState(() {
                    usersChip = value;
                  });
                },
                selected: usersChip,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: FilterChip(
                  label: const Text('Classes'),
                  onSelected: (final value) {
                    setState(() {
                      classesChip = value;
                    });
                  },
                  selected: classesChip,
                ),
              )
            ],
          ),
        ),
        SearchWidget(
          cancelCallback: () {
            setState(() {
              query = null;
            });
          },
          onSearch: (final value) {
            setState(() {
              query = value;
            });
          },
          searchClosed: false,
        ),
        if (query != null && usersChip == true) _usersSearch(_postProvider),
        if (query != null && classesChip == true) _classesSearch(_postProvider)
      ]),
    );
  }

  FutureBuilder<List<User>> _usersSearch(final PostProvider _postProvider) {
    return FutureBuilder(
      future: _postProvider.searchUsers(query),
      builder: (final context, final snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<User> users = snapshot.data;
        if (users == null || users.isEmpty) {
          return ListView(
            shrinkWrap: true,
            children: [
              const PrefTitle(title: Text('Users')),
              const Text('No users found')
            ],
          );
        }

        return ListView(
          shrinkWrap: true,
          children: [
            const PrefTitle(title: Text('Users')),
            ListView.builder(
              shrinkWrap: true,
              itemCount: users.length > 3 ? 3 : users.length,
              itemBuilder: (final BuildContext context, final int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<Map<dynamic, dynamic>>(
                        builder: (final context) =>
                            UserInfoPage(userId: users[index].uid),
                      ),
                    ),
                    child: Container(
                        child: Row(
                      children: [
                        FutureBuilder(
                          future: _postProvider
                              .getProfilePictureURL(users[index].uid),
                          builder: (final context, final snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return const Center(
                                child: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(placeholderImage),
                                ),
                              );
                            }

                            final String photoUrl = snapshot.data;
                            return CircleAvatar(
                              backgroundImage: photoUrl != null
                                  ? NetworkImage(photoUrl)
                                  : const NetworkImage(placeholderImage),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            users[index].displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  FutureBuilder<List<ClassHeader>> _classesSearch(
      final PostProvider _postProvider) {
    return FutureBuilder(
      future: _postProvider.searchClasses(query),
      builder: (final context, final snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<ClassHeader> classes = snapshot.data;
        if (classes == null || classes.isEmpty) {
          return ListView(
            shrinkWrap: true,
            children: [
              const PrefTitle(title: Text('Classes')),
              const Text('No classes found')
            ],
          );
        }

        return ListView(
          shrinkWrap: true,
          children: [
            const PrefTitle(title: Text('Classes')),
            ListView.builder(
              shrinkWrap: true,
              itemCount: classes.length > 3 ? 3 : classes.length,
              itemBuilder: (final BuildContext context, final int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<Map<dynamic, dynamic>>(
                        builder: (final context) => ClassPage(
                          className: classes[index].id,
                        ),
                      ),
                    ),
                    child: Container(
                        child: Row(
                      children: [
                        CircleAvatar(
                          child: FittedBox(
                              child: Text('${classes[index].acronym}')),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  classes[index].name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  classes[index].id,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
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
