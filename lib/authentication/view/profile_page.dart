import 'dart:io';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/authentication/view/edit_profile_page.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/navigation/routes.dart';
import 'package:acs_upb_mobile/resources/storage_provider.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/icon_text.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _signOut(BuildContext context) async {
    AuthProvider authProvider =
        Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut(context);
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  AppDialog _deletionConfirmationDialog(BuildContext context) => AppDialog(
        icon: Icon(Icons.warning, color: Colors.red),
        title: S.of(context).actionDeleteAccount,
        message: S.of(context).messageDeleteAccount +
            ' ' +
            S.of(context).messageCannotBeUndone,
        actions: [
          AppButton(
            key: ValueKey('delete_account_button'),
            text: S.of(context).actionDeleteAccount.toUpperCase(),
            color: Colors.red,
            width: 130,
            onTap: () async {
              AuthProvider authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              bool res = await authProvider.delete(context: context);
              if (res) {
                _signOut(context);
              }
            },
          )
        ],
      );

  Widget _deleteAccountButton(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticatedFromCache || authProvider.isAnonymous) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconText(
          onTap: () async {
            showDialog(context: context, builder: _deletionConfirmationDialog);
          },
          icon: Icons.delete,
          text: S.of(context).actionDeleteAccount,
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .apply(color: Colors.red, fontWeightDelta: 1)),
    );
  }

  Widget _accountNotVerifiedFooter(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticatedFromCache || authProvider.isAnonymous) {
      return Container();
    }

    return FutureBuilder(
      future: authProvider.isVerifiedFromService,
      builder: (BuildContext context, AsyncSnapshot<bool> snap) {
        if (!snap.hasData || snap.data) {
          return Container();
        }
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconText(
            align: TextAlign.center,
            icon: Icons.error_outline,
            text: S.of(context).messageEmailNotVerified,
            actionText: S.of(context).actionSendVerificationAgain,
            style: Theme.of(context)
                .textTheme
                .subtitle2
                .copyWith(fontWeight: FontWeight.w400),
            onTap: () => authProvider.sendEmailVerification(context: context),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    StorageProvider storageProvider =
        Provider.of<StorageProvider>(context, listen: true);
    return AppScaffold(
      actions: [
        AppScaffoldAction(
            icon: Icons.edit,
            onPressed: () {
              AuthProvider authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              if (authProvider.isAuthenticatedFromCache &&
                  !authProvider.isAnonymous) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()));
              }
            })
      ],
      title: S.of(context).navigationProfile,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: authProvider.currentUser,
            builder: (BuildContext context, AsyncSnapshot<User> snap) {
              String userName;
              String userGroup;
              String picturePath;
              if (snap.connectionState == ConnectionState.done) {
                User user = snap.data;
                if (user != null) {
                  userName = user.firstName + ' ' + user.lastName;
                  userGroup = user.group;
                  picturePath = user.picture;
                } else {
                  picturePath = ' ';
                }
                return Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(),
                    ),
                    FutureBuilder<ImageProvider<dynamic>>(
                      future: storageProvider.imageFromPath(picturePath),
                      builder: (context,
                          AsyncSnapshot<ImageProvider<dynamic>> snapshot) {
                        var image;
                        debugPrint(
                            'image : ' + snapshot.connectionState.toString());
                        if (snapshot.connectionState == ConnectionState.done) {
                          image = snapshot.data;
                        } else {
                          debugPrint(
                              'image : in else ' + snapshot.hasData.toString());
                          image = AssetImage(
                              'assets/illustrations/undraw_profile_pic.png');
                        }

                        return GestureDetector(
                          onDoubleTap: () async {
                            final pickedFile = await ImagePicker()
                                .getImage(source: ImageSource.gallery);
                            StorageReference storageReference = FirebaseStorage
                                .instance
                                .ref()
                                .child('profile_picture/test');
                            StorageUploadTask uploadTask =
                                storageReference.putFile(File(pickedFile.path));
                            if (user != null) {}
                            await uploadTask.onComplete;
                            setState(() {
                              image = Image.file(File(pickedFile.path));
                            });
                          },
                          child:
                              CircleAvatar(radius: 95, backgroundImage: image),
                        );
                      },
                    ),
                    SizedBox(height: 8),
                    Text(
                      userName ?? S.of(context).stringAnonymous,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .apply(fontWeightDelta: 2),
                    ),
                    if (userGroup != null)
                      Column(
                        children: [
                          SizedBox(height: 4),
                          Text(userGroup,
                              style: Theme.of(context).textTheme.subtitle1),
                        ],
                      ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        _signOut(context);
                      },
                      child: Text(
                          authProvider.isAnonymous
                              ? S.of(context).actionLogIn
                              : S.of(context).actionLogOut,
                          style: Theme.of(context)
                              .accentTextTheme
                              .subtitle2
                              .copyWith(fontWeight: FontWeight.w500)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(),
                    ),
                    _deleteAccountButton(context),
                    _accountNotVerifiedFooter(context),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
