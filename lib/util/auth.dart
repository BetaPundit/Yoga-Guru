import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);
  Future<FirebaseUser> signUp(
      String email, String password, String fname, String lname);
  Future<String> getCurrentUser();
  Future<void> signOut();
}

class Auth implements BaseAuth {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final Firestore _firestore = Firestore.instance;

  Future<FirebaseUser> signIn(
    String email,
    String password,
  ) async {
    AuthResult user = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', user.user.email);
    prefs.setString('uid', user.user.uid);
    prefs.setString('displayName', user.user.displayName);
    prefs.setString('photoUrl', user.user.photoUrl);

    return user.user;
  }

  Future<FirebaseUser> signUp(
    String email,
    String password,
    String fname,
    String lname,
  ) async {
    AuthResult user = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = '$fname $lname';
    await user.user.updateProfile(updateInfo);

    FirebaseUser currentUser = await _firebaseAuth.currentUser();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', currentUser.email);
    prefs.setString('uid', currentUser.uid);
    prefs.setString('displayName', currentUser.displayName);
    prefs.setString('photoUrl', currentUser.photoUrl);

    return currentUser;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<FirebaseUser> updateCurrentUser({
    String displayName,
    String photoUrl,
  }) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    UserUpdateInfo updateInfo = UserUpdateInfo();
    if (displayName != null) updateInfo.displayName = displayName;
    if (photoUrl != null) updateInfo.photoUrl = photoUrl;
    await user.updateProfile(updateInfo);

    FirebaseUser currentUser = await _firebaseAuth.currentUser();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', currentUser.email);
    prefs.setString('uid', currentUser.uid);
    prefs.setString('displayName', currentUser.displayName);
    prefs.setString('photoUrl', currentUser.photoUrl);

    return currentUser;
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    return await _firebaseAuth.signOut();
  }
}
