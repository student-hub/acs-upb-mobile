import 'dart:typed_data';

import 'package:acs_upb_mobile/authentication/model/user.dart';
import 'package:acs_upb_mobile/authentication/service/auth_provider.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:acs_upb_mobile/pages/filter/view/relevance_picker.dart';
import 'package:acs_upb_mobile/pages/portal/model/website.dart';
import 'package:acs_upb_mobile/pages/portal/service/website_provider.dart';
import 'package:acs_upb_mobile/resources/locale_provider.dart';
import 'package:acs_upb_mobile/resources/storage/storage_provider.dart';
import 'package:acs_upb_mobile/resources/theme.dart';
import 'package:acs_upb_mobile/resources/utils.dart';
import 'package:acs_upb_mobile/widgets/button.dart';
import 'package:acs_upb_mobile/widgets/circle_image.dart';
import 'package:acs_upb_mobile/widgets/dialog.dart';
import 'package:acs_upb_mobile/widgets/scaffold.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:acs_upb_mobile/widgets/upload_button.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:validators/validators.dart';

class WebsiteView extends StatefulWidget {
  // If [updateExisting] is true, this acts like an "Edit website" page starting
  // from the info in [website]. Otherwise, it acts like an "Add website" page.
  WebsiteView({Key key, this.website, this.updateExisting = false})
      : super(key: key) {
    if (updateExisting == true && website == null) {
      throw ArgumentError(
          'WebsiteView: website cannot be null if updateExisting is true');
    }
  }

  final Website website;
  final bool updateExisting;

  @override
  _WebsiteViewState createState() => _WebsiteViewState();
}

class _WebsiteViewState extends State<WebsiteView> {
  final formKey = GlobalKey<FormState>();

  WebsiteCategory selectedCategory;
  TextEditingController labelController;
  TextEditingController linkController;
  TextEditingController descriptionRoController;
  TextEditingController descriptionEnController;
  final RelevanceController relevanceController = RelevanceController();

  User user;

  ImageProvider imageWidget;
  TextEditingController imageFieldController = TextEditingController();
  UploadButtonController uploadButtonController;
  UploadButton uploadButton;

  Future<void> fetchUser() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    user = await authProvider.currentUser;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchUser();

    selectedCategory = widget.website?.category ?? WebsiteCategory.learning;
    labelController = TextEditingController(text: widget.website?.label ?? '');
    linkController = TextEditingController(text: widget.website?.link ?? '');

    final description = <String, String>{'en': '', 'ro': ''};
    if (widget.website != null) {
      description['en'] = widget.website.infoByLocale.containsKey('en')
          ? widget.website.infoByLocale['en']
          : '';
      description['ro'] = widget.website.infoByLocale.containsKey('ro')
          ? widget.website.infoByLocale['ro']
          : '';
    }
    descriptionRoController = TextEditingController(text: description['ro']);
    descriptionEnController = TextEditingController(text: description['en']);
    widget.website.getIconURL().then((value) => setState(() => {
          imageWidget = value != null
              ? NetworkImage(value)
              : const AssetImage('assets/icons/globe.png')
        }));
    uploadButtonController =
        UploadButtonController(imageWidget, onUpdate: () => setState(() => {}));
    uploadButton =
        UploadButton(imageFieldController, controller: uploadButtonController);
  }

  String buildId() {
    if (widget.updateExisting) return widget.website.id;
    final label = (labelController.text ?? '') == ''
        ? Website.labelFromLink(linkController.text)
        : labelController.text;
    // Sanitize label to obtain document ID
    return ReCase(label.replaceAll(RegExp('[^A-ZĂÂȘȚa-zăâșț0-9 ]'), ''))
        .snakeCase;
  }

  Website buildWebsite() {
    final String id = buildId();
    final String ownerUid =
        widget.updateExisting ? widget.website.ownerUid : user?.uid;

    return Website(
      id: id,
      ownerUid: ownerUid,
      isPrivate: relevanceController.private ?? true,
      editedBy: (widget.website?.editedBy ?? []) + [user?.uid],
      label: labelController.text,
      link: linkController.text,
      category: selectedCategory,
      infoByLocale: {
        'ro': descriptionRoController.text,
        'en': descriptionEnController.text
      },
      relevance: relevanceController.customRelevance,
      degree: relevanceController.degree ?? widget.website?.degree,
    );
  }

  Widget preview() {
    final website = buildWebsite();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Card(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.remove_red_eye_outlined,
                    color: Theme.of(context).formIconColor,
                  ),
                  const SizedBox(width: 12),
                  AutoSizeText(
                    '${S.current.labelPreview}:',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            child: WebsiteIcon(
                          website: website,
                          image: uploadButton.controller.currentImage,
                          onTap: () {
                            Utils.launchURL(website.link);
                          },
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: AutoSizeText(
                S.current.messageWebsitePreview,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  AppDialog deletionConfirmationDialog(BuildContext context) => AppDialog(
        icon: const Icon(Icons.delete_outlined),
        title: S.current.actionDeleteWebsite,
        message: S.current.messageDeleteWebsite,
        info: widget.website.isPrivate
            ? null
            : S.current.messageThisCouldAffectOtherStudents,
        actions: [
          AppButton(
            text: S.current.actionDeleteWebsite,
            width: 130,
            onTap: () async {
              Navigator.pop(context); // Pop dialog window

              final websiteProvider =
                  Provider.of<WebsiteProvider>(context, listen: false);
              final res = await websiteProvider.deleteWebsite(widget.website);
              if (res) {
                Navigator.pop(context); // Pop editing page
                AppToast.show(S.current.messageWebsiteDeleted);
              }
            },
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    Uint8List imageAsPNG;

    return AppScaffold(
      title: Text(widget.updateExisting
          ? S.current.actionEditWebsite
          : S.current.actionAddWebsite),
      actions: [
            AppScaffoldAction(
              text: S.current.buttonSave,
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  final websiteProvider =
                      Provider.of<WebsiteProvider>(context, listen: false);

                  bool res = false;
                  if (widget.updateExisting) {
                    res = await websiteProvider.updateWebsite(buildWebsite());
                  } else {
                    res = await websiteProvider.addWebsite(buildWebsite());
                  }
                  if (uploadButton.controller.newUploadedImageBytes != null) {
                    imageAsPNG = await Utils.convertToPNG(
                        uploadButton.controller.newUploadedImageBytes);
                    res = await websiteProvider.uploadWebsiteIcon(
                        buildWebsite(), imageAsPNG);
                  }
                  if (res) {
                    AppToast.show(widget.updateExisting
                        ? S.current.messageWebsiteEdited
                        : S.current.messageWebsiteAdded);
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ] +
          (widget.updateExisting
              ? [
                  AppScaffoldAction(
                    icon: Icons.more_vert_outlined,
                    items: {
                      S.current.actionDeleteWebsite: () => showDialog(
                          context: context, builder: deletionConfirmationDialog)
                    },
                    onPressed: () => showDialog(
                        context: context, builder: deletionConfirmationDialog),
                  )
                ]
              : <AppScaffoldAction>[]),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            preview(),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    uploadButton,
                    TextFormField(
                      controller: labelController,
                      decoration: InputDecoration(
                        labelText: S.current.labelName,
                        hintText: S.current.hintWebsiteLabel,
                        prefixIcon: const Icon(Icons.label_outlined),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                    DropdownButtonFormField<WebsiteCategory>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: S.current.labelCategory,
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      value: selectedCategory,
                      items: WebsiteCategory.values
                          .map(
                            (category) => DropdownMenuItem<WebsiteCategory>(
                              value: category,
                              child: Text(category.toLocalizedString()),
                            ),
                          )
                          .toList(),
                      onChanged: (selection) =>
                          setState(() => selectedCategory = selection),
                    ),
                    TextFormField(
                      controller: linkController,
                      decoration: InputDecoration(
                        labelText: '${S.current.labelLink} *',
                        hintText: S.current.hintWebsiteLink,
                        prefixIcon: const Icon(FeatherIcons.globe),
                      ),
                      validator: (value) {
                        if (!isURL(value, requireProtocol: true)) {
                          return S.current.warningInvalidURL;
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                    RelevanceFormField(
                      canBePrivate: true,
                      canBeForEveryone: true,
                      defaultPrivate: widget.website?.isPrivate ?? true,
                      controller: relevanceController,
                    ),
                    TextFormField(
                      controller: descriptionRoController,
                      decoration: InputDecoration(
                          labelText:
                              '${S.current.labelDescription} (${S.current.settingsItemLanguageRomanian.toLowerCase()})',
                          hintText: 'Cel mai popular motor de căutare.',
                          prefixIcon: const Icon(Icons.info_outlined)),
                      onChanged: (_) => setState(() {}),
                      minLines: 1,
                      maxLines: 5,
                    ),
                    TextFormField(
                      controller: descriptionEnController,
                      decoration: InputDecoration(
                          labelText:
                              '${S.current.labelDescription} (${S.current.settingsItemLanguageEnglish.toLowerCase()})',
                          hintText: 'The most popular search engine.',
                          prefixIcon: const Icon(Icons.info_outlined)),
                      onChanged: (_) => setState(() {}),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebsiteIcon extends StatelessWidget {
  const WebsiteIcon(
      {this.website, this.canEdit, this.size, this.image, this.onTap});

  final Website website;
  final bool canEdit;
  final double size;

  // If an image is not provided, the corresponding website icon is fetched from the storage, if available
  final ImageProvider image;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return FutureBuilder(
          future: StorageProvider.findImageUrl(website.iconPath),
          // Firebase Storage path
          builder: (context, snapshot) {
            ImageProvider oldImage;
            if (snapshot.hasData) {
              oldImage = NetworkImage(snapshot.data);
            }

            return CircleImage(
                label: website.label,
                tooltip: website.infoByLocale[LocaleProvider.localeString],
                image: oldImage ?? const AssetImage('assets/icons/globe.png'),
                enableOverlay: canEdit,
                circleSize: size,
                onTap: onTap);
          });
    } else {
      return CircleImage(
          label: website.label,
          tooltip: website.infoByLocale[LocaleProvider.localeString],
          image: image,
          enableOverlay: canEdit,
          circleSize: size,
          onTap: onTap);
    }
  }
}
