import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:law_education_app/conts.dart';
import 'package:law_education_app/screens/chat/peer_model.dart';

import 'Chat.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyChats extends StatefulWidget {
  const MyChats({Key? key}) : super(key: key);

  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> with SingleTickerProviderStateMixin {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uId;
  List? id;
  String? peerId;
  String? userName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
    uId = getUid();
  }

  String getUid() {
    final User? user = auth.currentUser;
    return user!.uid;
    // here you write the codes to input the data into firestore
  }

  final int _limit = 20;
  final ScrollController listScrollController = ScrollController();
  bool isLoading = false;
  String messageIndex = "0";
  TabController? _tabController;
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          automaticallyImplyLeading: false,
          backgroundColor: primaryColor,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: <Widget>[
                  // List
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      child: StreamBuilder<QuerySnapshot>(
                        //todo (changed Type to Cross)
                        stream: FirebaseFirestore.instance
                            .collection('chat group')
                            .where("id", arrayContains: uId)
                            .where("type", isEqualTo: "cross")
                            //.orderBy('time')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          print("user Id $uId");

                          if (snapshot.hasError) {
                            print("error ${snapshot.error}");
                            return const Center(
                              child: Column(
                                children: [
                                  SelectableText("Something Went Wrong .")
                                ],
                              ),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            );
                          }

                          if (snapshot.data!.size != 0) {
                            List<Offset> pointList = <Offset>[];

                            return ListView.builder(
                              padding: const EdgeInsets.all(10.0),
                              itemBuilder: (context, index) {
                                print("user Id $uId");
                                print("yes user has data ");
                                DocumentSnapshot? document =
                                    snapshot.data?.docs[index];

                                //return buildItem(context, snapshot.data!.docs[index]);

                                id = List.from(document!.get('id'));
                                if (id![0] == uId) {
                                  peerId = id![1];
                                  print("user Id  :$uId");
                                  print("Peer Id : $peerId");
                                  return buildItem(
                                      context, snapshot.data!.docs[index]);
                                } else if (id![1] == uId) {
                                  peerId = id![0];
                                  print("user Id  :$uId");
                                  print("Peer Id : $peerId");
                                  return buildItem(
                                      context, snapshot.data!.docs[index]);
                                } else {
                                  return Container();
                                }
                              },
                              itemCount: snapshot.data?.docs.length,
                              controller: listScrollController,
                            );
                          } else if (snapshot.data!.size == 0) {
                            print("user Id $uId");
                            print("user data not found");
                            return Center(
                              child: Container(
                                child: const Text("No Previous Chat"),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  // Loading
                  Positioned(
                    child: isLoading ? const Loading() : Container(),
                  )
                ],
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: primary,
        //   foregroundColor: Colors.white,
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (BuildContext context) => const ShowAllUsers()));
        //
        //     // Respond to button press
        //   },
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () async {
          print(document.get('id'));
          print(document.id);
          id = List.from(document.get('id'));
          if (id![0] == uId) {
            peerId = id![1];
            print("user Id  :$uId");
            print("Peer Id : $peerId");
          } else if (id![1] == uId) {
            peerId = id![0];
            print("user Id  :$uId");
            print("Peer Id : $peerId");
          }

          // bool dataLoaded = false;
          String name = "";

          // here name is being called just to send it to the chat for its appbar title and for that we are loooking for the index
          // if the index is 0 (Friend Chat) and 1 (Customer Chat)
          // Two sepereate functions are used just because Customer and customer data is stored in two different collection in Firestore
          /*selectedIndex == 0 ?   name = await peerNameCustomer(peerId.toString()):
          name = await peerNameCustomer(peerId.toString());



          selectedIndex == 0 ? Navigator.push(context,new MaterialPageRoute(builder: (context) => CustomerChat( peerId: peerId.toString(),name : name,))) :
          Navigator.push(context,new MaterialPageRoute(builder: (context) => FriendChat( peerId: peerId.toString(),name : name,)));*/

          // if the index is 0 (Friend Chat) and 1 (Customer Chat)
          String type = "";
          selectedIndex == 0 ? type = "fellow" : type = "cross";
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                        peerId: peerId.toString(),
                        type: type,
                      )));
        },
        child: FutureBuilder<List<PeerUser>>(
          future: userData(selectedIndex),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(2, 7, 7, 7),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 25),
                          Container(
                            width: 120,
                            height: 20,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 25),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );

              //return Center(child: CircularProgressIndicator(color:  primary));
            }
            if (snapshot.hasData) {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.white,
                        thickness: 3,
                      );
                    },
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 7, 7, 7),
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(color: Colors.grey),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              snapshot.data![index].profileUrl),
                                          fit: BoxFit.contain,
                                        )),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data![index].username,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                FutureBuilder<bool>(
                                  future:
                                      dataExist(snapshot.data![index].userId),
                                  builder: (context, snapshots1) {
                                    print("data snapshot");
                                    print("data  ${snapshots1.data}");
                                    print(
                                        "Connnection  : ${snapshots1.connectionState}");
                                    if (snapshots1.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator(
                                          color: primaryColor);
                                    }

                                    if (snapshots1.hasData &&
                                        snapshots1.connectionState ==
                                            ConnectionState.done) {
                                      print("data exisit ${snapshots1.data}");
                                      if (snapshots1.data == true) {
                                        return StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('unseen Message')
                                              .doc(uId)
                                              .collection('unseen Message')
                                              .doc(snapshot.data![index].userId)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot>
                                                  snapshots) {
                                            if (snapshots.data != null) {
                                              if (snapshots.data!['unseen'] ==
                                                  0) {
                                                Container();
                                              } else {
                                                if (snapshots.data!['unseen'] >=
                                                    100) {
                                                  return Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: primaryColor),
                                                    child: const Center(
                                                      child: Text(
                                                        "99+",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    height: 25,
                                                    width: 25,
                                                    decoration:
                                                        const BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: primaryColor),
                                                    child: Center(
                                                      child: Text(
                                                        snapshots
                                                            .data!['unseen']
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            }

                                            return Container();
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    } else if (snapshots1.data == null) {
                                      return const CircularProgressIndicator(
                                          color: primaryColor);
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),

/*
                                messageIndex == "0" ? Container() : ,
*/
                              ],
                            ),
                            const Divider(
                              height: 1,
                              indent: 70,
                              color: Colors.black54,
                            )
                          ],
                        ),
                      );
                    });
              } else {
                print(snapshot.hasData);
                print(snapshot.connectionState);
                print(snapshot.error);
                print(snapshot.data!.length);
                return Center(
                  child: Container(child: const Text("No Chat")),
                );
              }
            } else if (snapshot.hasError) {
              return Text('Error : ${snapshot.error}');
            } else {
              return const Center(
                child: const CircularProgressIndicator(color: primaryColor),
              );
            }
          },
        ),
      ),
    );
  }

  Future indexMessage(String peer) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('unseen Message');
    users
        .doc(uId)
        .collection('unseen Message')
        .doc(peer)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        print("Message index is : ${data['unseen']}");

        if (data['unseen'] == 0) {
          messageIndex = "0";
        } else {
          if (data['unseen'] >= 100) {
            messageIndex = "99+";
          } else {
            messageIndex = data['unseen'].toString();
          }
        }
      } else {
        print("No data");
        messageIndex = "0";
      }
    });
  }

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////These Two FUNC are Used to just send name to Chat Screen ///////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
  Future<String> peerNameCustomer(String id) async {
    var name = '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot.get('name');
        });
      }
    });

    return name;
  }

  Future<String> peerNameWorker(String id) async {
    var name = '';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          name = documentSnapshot.get('name');
        });
      }
    });

    return name;
  }
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////

  Future<bool> dataExist(String uid) async {
    bool? exsist;
    try {
      print("No Error");
      await FirebaseFirestore.instance
          .collection('unseen Message')
          .doc(uId)
          .collection('unseen Message')
          .doc(uid)
          .get()
          .then((doc) {
        print(doc.exists);
        exsist = doc.exists;
      });
    } catch (e) {
      print("error fetching");
      exsist = false;
    }

    return exsist ?? false;
  }

  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////
  /////////////// This User Data code returns List ////////////////////////
  /////////////// But have a single document of Data //////////////////////
  /////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////
  Future<List<PeerUser>> userData(int tabViewIndex) async {
    List<PeerUser> list = [];
    DocumentReference usersCollection;

    // Here, the IF-ELSE statement is used to determine the collection based on the tabViewIndex
    if (tabViewIndex == 0) {
      usersCollection =
          FirebaseFirestore.instance.collection('users').doc(peerId);
      print("Customer collection selected");
    } else {
      usersCollection =
          FirebaseFirestore.instance.collection('customer').doc(peerId);
      print("User collection selected");
    }

    DocumentSnapshot documentSnapshot = await usersCollection.get();
    if (documentSnapshot.exists) {
      PeerUser model = PeerUser(
        documentSnapshot.id.toString(),
        documentSnapshot.get('name'),
        documentSnapshot.get('profileUrl'),
      );
      print("========");
      print("name is ${model.username}");
      print("profileUrl is ${model.profileUrl}");
      print("doc id is ${model.userId}");
      list.add(model);
    }

    return list;
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
    );
  }
}
