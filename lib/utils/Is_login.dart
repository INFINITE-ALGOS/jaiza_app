import 'package:firebase_auth/firebase_auth.dart';

class IsLogin{
  final FirebaseAuth _auth=FirebaseAuth.instance;
   bool isLoggedIn=false;
  void isLogin(){
    if(_auth.currentUser!=null){
      isLoggedIn=true;
    }
  }
}