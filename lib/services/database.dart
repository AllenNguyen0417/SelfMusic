
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});
  final DatabaseReference userCollection = FirebaseDatabase.instance.reference();
}

String? getCurrentUID() {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  final uid = DatabaseService(uid: user!.uid);
  return uid.uid;
}

