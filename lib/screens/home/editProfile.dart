import 'package:flutter/material.dart';
import 'package:gather_go/Models/ProfileOnScreen.dart';
import 'package:provider/provider.dart';
import 'package:gather_go/shared/build_appbar.dart';

import 'dart:io';
import 'package:gather_go/shared/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:gather_go/shared/contants.dart';
import 'package:gather_go/shared/textField.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<ProfileData>(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath: user.imageUrl,
            isEdit: true,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Full Name',
            text: user.name,
            onChanged: (name) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: user.email,
            onChanged: (email) {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'About',
            text: user.bio,
            maxLines: 5,
            onChanged: (about) {},
          ),
        ],
      ),
    );
  }
}
