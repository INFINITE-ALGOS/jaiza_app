import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetClientsProvider{
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  List<Map<String,dynamic>> initialClients=[];
  //List<Map<String,dynamic>> allLawyers=[];
  Future<void> getInitialClientss()async{
    try{
      QuerySnapshot clientSnapshot = await firestore.collection('users')
          .where("type", isEqualTo: "client")
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      initialClients= clientSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

    }
    catch(e){}

  }
  Future<List<Map<String,dynamic>>> getAllClients()async{
    try{
      QuerySnapshot clientSnapshot = await firestore.collection('users')
          .where("type", isEqualTo: "client")
          .orderBy('rating', descending: true)
          .get();

      return clientSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

    }
    catch(e){
      return [];
    }
  }

}