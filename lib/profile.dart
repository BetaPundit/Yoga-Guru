import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:yoga_guru/util/auth.dart';

class Profile extends StatefulWidget {
  final String email;
  final String uid;
  final String displayName;
  final String photoUrl;

  Profile({
    this.email,
    this.uid,
    this.displayName,
    this.photoUrl,
  });

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool _editMode = false;
  TextEditingController _displayNameController;
  String _titleText;
  String _displayName;
  String _photoUrl;
  File _image;

  @override
  void initState() {
    _displayNameController = TextEditingController(
      text: widget.displayName,
    );

    _titleText = 'Profile';

    _displayName = widget.displayName;
    _photoUrl = widget.photoUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_titleText),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              // Details Card
              Container(
                width: double.infinity,
                child: Card(
                  color: Colors.blueGrey[200],
                  margin: EdgeInsets.only(top: 60.0, bottom: 28.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28.0, 90.0, 28.0, 16.0),
                    child: SingleChildScrollView(
                      child: Container(
                        height: 460,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Display Name
                            Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    AnimatedSwitcher(
                                      duration: Duration(milliseconds: 100),
                                      child: _editMode
                                          ? _editNameWidget()
                                          : _displayNameWidget(
                                              _displayName,
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Level
                            CircularPercentIndicator(
                              radius: 120.0,
                              lineWidth: 13.0,
                              animation: true,
                              animationDuration: 600,
                              percent: 0.7,
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Colors.indigo[400],
                              center: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Level",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "40",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Streak
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Streak: ',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                                Text(
                                  '30',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ],
                            ),

                            // Bottom Options
                            Divider(
                              color: Colors.blueGrey[500],
                              indent: 24.0,
                              endIndent: 24.0,
                              thickness: 1.0,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Avatar
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70.0),
                    border: Border.all(
                      color: Colors.blueGrey[100],
                      width: 6.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2.0,
                      ),
                    ]),
                child: Stack(
                  children: <Widget>[
                    Hero(
                      tag: 'profile',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundImage: _editMode != true
                            ? _photoUrl == null
                                ? AssetImage(
                                    'assets/images/profile-image.png',
                                  )
                                : NetworkImage(
                                    _photoUrl,
                                  )
                            : _image == null
                                ? AssetImage(
                                    'assets/images/profile-image.png',
                                  )
                                : FileImage(_image),
                      ),
                    ),

                    // Edit Button
                    Positioned(
                      right: 0.0,
                      bottom: 0.0,
                      child: AnimatedContainer(
                        margin: EdgeInsets.fromLTRB(
                          0,
                          0,
                          _editMode ? 0 : 15,
                          _editMode ? 0 : 15,
                        ),
                        duration: Duration(milliseconds: 100),
                        height: _editMode ? 32 : 0,
                        width: _editMode ? 32 : 0,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100],
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: FloatingActionButton(
                          heroTag: null,
                          elevation: 0.0,
                          backgroundColor: Colors.blueGrey[100],
                          child: Icon(
                            Icons.edit,
                            color: Colors.blueGrey[700],
                            size: _editMode ? 19 : 0,
                          ),
                          onPressed: _getImage,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // Edit Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editMode
            ? _onConfirmUpdate(
                displayName: _displayNameController.text,
                photo: _image,
              )
            : _onEdit(context),
        child: Icon(
          _editMode ? Icons.done : Icons.edit,
          color: Colors.blueGrey[900],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _displayNameWidget(String displayName) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 200,
        padding: EdgeInsets.fromLTRB(0, 12.0, 3.0, 12.0),
        child: Text(
          displayName,
          style: TextStyle(
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }

  Widget _editNameWidget() {
    return Container(
      width: 200,
      child: TextField(
        autofocus: true,
        style: TextStyle(
          fontSize: 25,
        ),
        controller: _displayNameController,
        textAlign: TextAlign.center,
        decoration: InputDecoration(),
      ),
    );
  }

  Future<void> _onEdit(BuildContext context) async {
    setState(() {
      _editMode = !_editMode;
      _titleText = 'Update Profile';
    });
  }

  Future<void> _getPhotoUrl(File photo) async {
    Auth auth = Auth();
    if (photo != null) {
      String photoUrl = await auth.storeProfilePhoto(photo);
      _photoUrl = photoUrl;
    }
  }

  void _onConfirmUpdate({
    String displayName,
    File photo,
  }) async {
    Auth auth = Auth();
    var user = await auth.getCurrentUser();
    print(user);

    if (photo != null) await _getPhotoUrl(photo);

    var updatedUser = await auth.updateCurrentUser(
      displayName: displayName ?? displayName,
      photoUrl: _photoUrl ?? _photoUrl,
    );
    print(updatedUser.displayName);
    print(updatedUser.photoUrl);

    setState(() {
      _editMode = !_editMode;
      _displayName = updatedUser.displayName;
      _photoUrl = updatedUser.photoUrl;
      _titleText = 'Profile';
    });
  }

  Future _getImage() async {
    File image = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 256,
      maxWidth: 256,
    );
    print(image.toString());

    setState(() {
      _image = image;
    });

    // Code for image cropper

    // File croppedImage = await ImageCropper.cropImage(
    //   sourcePath: _image.path,
    //   aspectRatio: CropAspectRatio(
    //     ratioX: 1,
    //     ratioY: 1,
    //   ),
    //   // aspectRatioPresets: [
    //   //   CropAspectRatioPreset.square,
    //   // ],
    //   androidUiSettings: AndroidUiSettings(
    //     toolbarTitle: 'Image Cropper',
    //     toolbarColor: Colors.black,
    //     toolbarWidgetColor: Colors.white,
    //     initAspectRatio: CropAspectRatioPreset.square,
    //     lockAspectRatio: true,
    //   ),
    //   // iosUiSettings: IOSUiSettings(
    //   //   minimumAspectRatio: 1.0,
    //   // ),
    // );

    // print(croppedImage.toString());

    // setState(() {
    //   _image = croppedImage ?? _image;
    // });
  }
}
