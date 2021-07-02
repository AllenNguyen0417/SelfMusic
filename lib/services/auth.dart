import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_firebase_project/models/user.dart';
import 'package:first_firebase_project/services/database.dart';
class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Create user obj based on FirebaseUser
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userFromFirebaseUser(user));
  }

  // Sign in anonymous
  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously(); // AuthResult has been changed to UserCredential
      User? user = result.user; // FirebaseUser has been changed to User
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  // Sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e);
      return null;
    }
  }

  // Register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // Create a new document for the user with the uid
      // await DatabaseService(uid: user!.uid).playlistCreate(null);
      return _userFromFirebaseUser(user);
    }
    catch(e){
      print(e);
      return null;
    }
  }

  // Sign out
  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}
