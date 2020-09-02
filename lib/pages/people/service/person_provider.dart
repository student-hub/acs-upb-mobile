import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/view/person_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension PersonExtension on Person {
  static Person fromSnap(DocumentSnapshot snap) {
    return Person(
      name: snap.data['name'],
      email: snap.data['email'],
      phone: snap.data['phone'],
      office: snap.data['office'],
      position: snap.data['position'],
      photo: snap.data['photo'],
    );
  }
}

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future _data;

  Future getPeople() async {
    QuerySnapshot qn = await Firestore.instance.collection("people").getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    _data = getPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _data,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                        NetworkImage(snapshot.data[index].data["photo"]),
                      ),
                      title: Text(snapshot.data[index].data["name"]),
                      subtitle: Text(snapshot.data[index].data["email"]),
                      onTap: () => navigateToDetail(PersonExtension.fromSnap(snapshot.data[index])),
                    );
                  });
            }
          }),
    );
  }

  navigateToDetail(Person person) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      // TODO: Fix size for long position name
      builder: (BuildContext buildContext) {
        return PersonView(
          person: person,
        );
      },
    );
  }
}