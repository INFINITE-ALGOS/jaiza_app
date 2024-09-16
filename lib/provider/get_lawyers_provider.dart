import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetLawyersProvider{
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  List<Map<String,dynamic>> initialLawyers=[];
  //List<Map<String,dynamic>> allLawyers=[];
  Future<void> getInitialLawyers()async{
    try{
      QuerySnapshot lawyerSnapshot = await firestore.collection('users')
          .where("type", isEqualTo: "lawyer")
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      initialLawyers= lawyerSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

    }
        catch(e){}
    
  }
  Future<List<Map<String,dynamic>>> getAllLawyers()async{
    try{
      QuerySnapshot lawyerSnapshot = await firestore.collection('users')
          .where("type", isEqualTo: "lawyer")
          .orderBy('rating', descending: true)
          .get();

      return lawyerSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

    }
    catch(e){
      return [];
    }
  }

}