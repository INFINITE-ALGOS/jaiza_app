import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:law_education_app/conts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'audio_message_player_widget.dart';

// Note online status must get check

class Chat extends StatefulWidget {
  final String peerId;
  final String type='cross';

  const Chat({Key? key, required this.peerId, required type})
      : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String timeAgoSinceDate(var dateString, {bool numericDates = true}) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} ${'yearAgo'}';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return (numericDates) ? '1yearAgo' : 'lastYear';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return '${(difference.inDays / 365).floor()} ${'monthsAgo'}';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return (numericDates) ? '1monthAgo' : 'lastMonth';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return '${(difference.inDays / 7).floor()} ${'weeksAgo'}';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1weekAgo' : 'lastWeek';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} ${'daysAgo'}';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1dayAgo' : 'yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} ${'hoursAgo'}';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1hourAgo' : 'anHourAgo';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} ${'minutesAgo'}';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1minuteAgo' : 'aminuteAgo';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} ${'secondsAgo'}';
    } else {
      return 'justNow';
    }
  }

  String peerName = "", peerNumber = "";

  void get_Peer_Name_And_Number() {
    if (widget.type == "cross") {
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.peerId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            peerName = documentSnapshot.get('name');
            peerNumber = documentSnapshot.get('phoneNo');
          });
        }
      });
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    if (await canLaunch('tel:$phoneNumber')) {
      await launch('tel:$phoneNumber');
    } else {
      throw 'Could not make phone call';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    get_Peer_Name_And_Number();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back icon to white
        ),
        backgroundColor: primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            Column(
              children: [
                Text(
                  peerName,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('user status')
                      .doc(widget.peerId)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DocumentSnapshot> snapshots) {
                    if (!snapshots.hasData) {
                      return Container();
                    }
                    if (snapshots.data!.exists) {
                      if (snapshots.data != null) {
                        if (snapshots.data!['isOnline']) {
                          return const Text(
                            "online",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        } else if (snapshots.data!['isOnline'] == false) {
                          return Text(
                            "lastSeen"
                            " : ${timeAgoSinceDate(snapshots.data!['lastSeen'])}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          );
                        }
                      }
                    }
                    return Container();
                  },
                ),
              ],
            ),
            widget.type == "fellow" || widget.type == "cross"
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: InkWell(
                      onTap: () {
                        _makePhoneCall(peerNumber);
                      },
                      child: const Icon(Icons.call, color: Colors.white),
                    ),
                  )
                : Container(
                    width: 60,
                  )
          ],
        ),
        centerTitle: true,
      ),
      body: ChatScreen(
        peerId: widget.peerId,
        type: widget.type,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;

  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  ///////////This var is for multiple app to display different chat ///////////
  /////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////
  final String type;

  const ChatScreen({Key? key, required this.peerId, required this.type})
      : super(key: key);

  @override
  State createState() => ChatScreenState(
        peerId: peerId,
      );
}

class ChatScreenState extends State<ChatScreen> {
  String? peerId;
  String? id;

  ChatScreenState({Key? key, required this.peerId});

  List<QueryDocumentSnapshot> listMessage = <QueryDocumentSnapshot>[];
  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';
  late SharedPreferences prefs;

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';
  List<String>? bothUser = ['', ''];
  int? unseenMessageNo;
  String recordFilePath = '';
  int i = 0;
  int? tempIndex;
  String peerAvatar = 'assets/images/logo.png', userAvatar = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isPlayingMsg = false, isRecording = false, isSending = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: null,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              /* // Sticker
              isShowSticker ? buildSticker() : Container(),*/

              // Input content
              buildInput(),
            ],
          ),
          buildLoading()
        ],
      ),
      /*onWillPop: onBackPress,*/
    );
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  ///////////////////////Below is Helper Func //////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  final FirebaseAuth auth = FirebaseAuth.instance;

  String getUid() {
    final User? user = auth.currentUser;
    return user!.uid;
    // here you write the codes to input the data into firestore
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void profilePic() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          userAvatar = documentSnapshot.get('profileUrl');
        });
      }
    });

    if (widget.type == "fellow") {
      FirebaseFirestore.instance
          .collection('users')
          .doc(peerId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            peerAvatar = documentSnapshot.get('profileUrl');
          });
        }
      });
    } else if (widget.type == "cross") {
      FirebaseFirestore.instance
          .collection('customer')
          .doc(peerId)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            peerAvatar = documentSnapshot.get('profileUrl');
          });
        }
      });
    } else if (widget.type == "worker") {
      setState(() {
        peerAvatar = "assets/images/logo.png";
      });
    }
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  ///////////////////////Below is Logic /////// ////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    id = getUid();
    profilePic();
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
    bothUser = [peerId.toString(), id.toString()];
    //getToken();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  String calculateGroupChatId(String id, String peerId) {
    final ids = [id, peerId];
    ids.sort(); // Sort the IDs alphabetically to ensure consistent order
    final encodedIds = utf8.encode(ids.join()); // Encode the IDs as UTF-8 bytes
    final hash =
        base64Url.encode(encodedIds); // Use base64 encoding for the hash
    return hash;
  }

  Future<void> readLocal() async {
    prefs = await SharedPreferences.getInstance();
    groupChatId = calculateGroupChatId(id.toString(), peerId.toString());

    print("group chat id is: $groupChatId");
    //FirebaseFirestore.instance.collection('users').doc(id).update({'chattingWith': peerId});

    setState(() {});
  }

  final CollectionReference userDetails =
      FirebaseFirestore.instance.collection('chat group');

  Future setUser() async {
    //////////////////////////////////////////////////////
    //////////////////////////////////////////////////////
    ///////////////For Cross App type is 1////////////////
    ///////////////For Same App type is 0/////////////////
    //////////////////////////////////////////////////////
    return await userDetails.doc(groupChatId).set({
      "id": FieldValue.arrayUnion(bothUser!),
      "time": Timestamp.now(),
      "type": widget.type.toString()
    });
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = audio
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type
          },
        );
      });

      // it increments the unseen message
      unseenMessageIncrementer();

      // user for my chats set
      setUser();

      listScrollController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);

      // var token;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      if (widget.type == "fellow") {
        firestore
            .collection('users')
            .doc(peerId)
            .get()
            .then((DocumentSnapshot peerSnapshot) {
          firestore
              .collection('users')
              .doc(id)
              .get()
              .then((DocumentSnapshot userSnapshot) {
            // todo to enable the sendnotification
            // sendNotification(peerSnapshot.get('token'), userSnapshot.get('name'));

            //doneNOtificaion
            //sendMessage(peerSnapshot.get('token'), userSnapshot.get('name'));
            print("user name: ${userSnapshot.get('name')}");
            print("token is: ${peerSnapshot.get('token')}");
          });
        });
      }
    } else {
      //Fluttertoast.showToast(msg: 'Nothing to send', backgroundColor: Colors.black, textColor: Colors.red);
    }
  }

  /*void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }*/

  /*  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      FirebaseFirestore.instance.collection('users').doc(id).update({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }*/

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  ///////////////////////Below is UI Message ////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  Widget buildSticker() {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
            color: Colors.white),
        padding: const EdgeInsets.all(5.0),
        height: 180.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi1', 2),
                  child: Image.asset(
                    'images/mimi1.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi2', 2),
                  child: Image.asset(
                    'images/mimi2.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi3', 2),
                  child: Image.asset(
                    'images/mimi3.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi4', 2),
                  child: Image.asset(
                    'images/mimi4.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi5', 2),
                  child: Image.asset(
                    'images/mimi5.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi6', 2),
                  child: Image.asset(
                    'images/mimi6.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Row(
              children: <Widget>[
                TextButton(
                  onPressed: () => onSendMessage('mimi7', 2),
                  child: Image.asset(
                    'images/mimi7.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi8', 2),
                  child: Image.asset(
                    'images/mimi8.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage('mimi9', 2),
                  child: Image.asset(
                    'images/mimi9.gif',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                )
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const Loading() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            color: Colors.white,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  pickImage(context);
                },
                color: primaryColor,
              ),
            ),
          ),
          widget.type == "worker"
              ? Container()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
                  child: GestureDetector(
                    onLongPress: () {
                      //startRecord();
                      setState(() {
                        isRecording = true;
                      });
                    },
                    onLongPressEnd: (details) {
                      //stopRecord();
                      setState(() {
                        isRecording = false;
                      });
                    },
                    child: const Icon(
                      Icons.mic,
                      color: primaryColor,
                    ),
                  ),
                ),
/*
          Container(
              height: 30,
              margin: EdgeInsets.fromLTRB(0, 5, 10, 5),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: isRecording
                        ? Colors.white
                        : Colors.black12,
                    spreadRadius: 4)
              ], color:  primaryColor, shape: BoxShape.circle),
              child: GestureDetector(
                onLongPress: () {
                  startRecord();
                  setState(() {
                    isRecording = true;
                  });
                },


                onLongPressEnd: (details) {
                  stopRecord();
                  setState(() {
                    isRecording = false;
                  });
                },





                child: Container(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 20,
                    )),
              )),
*/

          // Edit text
          isRecording
              ? Flexible(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.only(left: 30),
                      child: const Text(
                        "Recording ...",
                        style: TextStyle(color: primaryColor, fontSize: 18.0),
                      )),
                )
              : Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: TextField(
                        onSubmitted: (value) {
                          onSendMessage(textEditingController.text, 0);
                        },
                        style: const TextStyle(color: primaryColor, fontSize: 15.0),
                        controller: textEditingController,
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Type Your Message',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        focusNode: focusNode,
                      ),
                    ),
                  ),
                ),

          isRecording
              ? Container()
              :
              // Button send message
              Material(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () =>
                          onSendMessage(textEditingController.text, 0),
                      color: primaryColor,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(_limit)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage.addAll(snapshot.data!.docs);
                  unseenMessageSeen();
                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data!.docs[index]),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document.get('idFrom') == id) {
      // Right (my message)
      return GestureDetector(
        onLongPress: () {
          _handleLongPressDelete(document.id);
        },
        onLongPressEnd: (details) {
          _hideDeleteContainer();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            document.get('type') == 0
                // Text
                ? Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          document.get('content'),
                          style: TextStyle(color: Colors.black),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            DateFormat('dd MMM kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document.get('timestamp')))),
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 10.0,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                        right: 10.0),
                  )
                : document.get('type') == 1
                    // Image
                    ? Container(
                        child: OutlinedButton(
                          child: Material(
                            child: Image.network(
                              document.get("content"),
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                                      .toDouble()
                                              : null,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, object, stackTrace) {
                                return Material(
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                );
                              },
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            clipBehavior: Clip.hardEdge,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullPhoto(
                                  url: document.get('content'),
                                ),
                              ),
                            );
                          },
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(0))),
                        ),
                        margin: EdgeInsets.only(
                            bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                            right: 10.0),
                      )
                    // Sticker
                    : Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: Container(
                          width: 200.0,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: AudioBubble(
                            filepath: document.get('content'),
                            timeStamp: document.get('timestamp'),
                            peerSide: false,
                          ),
                        ),
                      ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Image.network(
                  userAvatar,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        value: loadingProgress.expectedTotalBytes != null &&
                                loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!.toDouble()
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, object, stackTrace) {
                    return Icon(
                      Icons.account_circle,
                      size: 35,
                      color: Colors.grey,
                    );
                  },
                  width: 35,
                  height: 35,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
            ),
          ],
        ),
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                /*  isLastMessageLeft(index)
                    ? Material(
                        child: Image.network(peerAvatar,loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color:  primaryColor,
                                value: loadingProgress.expectedTotalBytes != null &&
                                        loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(
                              Icons.account_circle,
                              size: 35,
                              color: Colors.grey,
                            );
                          },
                          width: 35,
                          height: 35,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),*/
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: widget.type == "fellow" || widget.type == "cross"
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Material(
                              borderRadius: BorderRadius.all(
                                Radius.circular(18.0),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                peerAvatar,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: primaryColor,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                                      .toDouble()
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, object, stackTrace) {
                                  return Icon(
                                    Icons.account_circle,
                                    size: 35,
                                    color: Colors.grey,
                                  );
                                },
                                width: 35,
                                height: 35,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Image.asset(
                            peerAvatar,
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                document.get('type') == 0
                    ? Container(
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              document.get('content'),
                              style: TextStyle(color: Colors.white),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                DateFormat('dd MMM kk:mm').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(document.get('timestamp')))),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      )
                    : document.get('type') == 1
                        ? Container(
                            margin: EdgeInsets.only(left: 10.0),
                            child: TextButton(
                              child: Material(
                                child: Image.network(
                                  document.get('content'),
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                          value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null &&
                                                  loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                                      .toDouble()
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, object, stackTrace) =>
                                      Material(
                                    child: Image.asset(
                                      'images/img_not_available.jpeg',
                                      width: 200.0,
                                      height: 200.0,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FullPhoto(
                                            url: document.get('content'))));
                              },
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(0))),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Container(
                              width: 200.0,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: AudioBubble(
                                  filepath: document.get('content'),
                                  timeStamp: document.get('timestamp'),
                                  peerSide: true),
                            ),
                          )
              ],
            ),

/*              // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm')
                          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(document.get('timestamp')))),
                      style: TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()*/
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  ///////////////////////Below is Unseen Message ///////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  CollectionReference users =
      FirebaseFirestore.instance.collection('unseen Message');

  Future unseenMessageIncrementer() async {
    users.doc(peerId).collection('unseen Message').doc(id).get().then(
        (DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        unseenMessageNo = data['unseen'];
      } else {
        unseenMessageNo = 0;
      }
    }).then((value) => {
          users
              .doc(peerId)
              .collection('unseen Message')
              .doc(id)
              .set({
                'unseen': unseenMessageNo! + 1, // id of sender at that point
              })
              .then((value) => print("User Added"))
              .catchError((error) => print("Failed to add user: $error"))
        });
  }

  Future unseenMessageSeen() async {
    users
        .doc(id)
        .collection('unseen Message')
        .doc(peerId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        users.doc(id).collection('unseen Message').doc(peerId).update({
          'unseen': 0,
        });
      }
    });
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  ///////////////////////Below is Notification ////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  String? token;
/*  getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    setState(() {
      token = token;
    });
    print(token);
  }*/

  /*sendNotification(String token, String senderName) async{
    String url='https://fcm.googleapis.com/fcm/send';
    Uri myUri = Uri.parse(url);
    await http.post(
      myUri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'You Have Recived A Message From $senderName',
            'title': 'A New Message',
            "sound" : "default"
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': '$token',
        },
      ),
    );

  }*/
  // void sendMessage(String recipientToken, String senderName) async {
  //   FirebaseApi firebaseApi = FirebaseApi();
  //   await firebaseApi
  //       .initNotification(); // Ensure notifications are initialized
  //   await firebaseApi.sendNotification(recipientToken, senderName);
  // }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  ///////////////////////Below is Image Upload //////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  Future<void> chooseGallery(BuildContext context) async {
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      imageFile = File(value!.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile().whenComplete(() {
          Navigator.pop(context);
        });
      }
    });
  }

  Future<void> chooseCamera(BuildContext context) async {
    await ImagePicker().pickImage(source: ImageSource.camera).then((value) {
      imageFile = File(value!.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile().whenComplete(() {
          Navigator.pop(context);
        });
      }
    });
  }

  void pickImage(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.cloud_upload),
                    title: const Text('Upload file'),
                    onTap: () {
                      if (kIsWeb) {
                      } else {
                        chooseGallery(context);
                      }
                    }),
                if (!kIsWeb)
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Take a photo'),
                    onTap: () => {chooseCamera(context)},
                  ),
              ],
            ),
          );
        });
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(imageFile!);

    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    } on FirebaseException {
      setState(() {
        isLoading = false;
      });
      //Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  /*void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }*/

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  ///////////////////////Below is Audio Message ////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  // void startRecord() async {
  //   bool hasPermission = await checkPermission();
  //   if (hasPermission) {
  //     recordFilePath = await getFilePath();

  //     RecordMp3.instance.start(recordFilePath, (type) {
  //       setState(() {});
  //     });
  //   } else {}
  //   setState(() {});
  // }

  // void stopRecord() async {
  //   bool s = RecordMp3.instance.stop();
  //   if (s) {
  //     setState(() {
  //       isSending = true;
  //     });
  //     await uploadAudio();

  //     setState(() {
  //       isPlayingMsg = false;
  //     });
  //   }
  // }

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
  }

  uploadAudio() {
    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}}.jpg');

    UploadTask task = firebaseStorageRef.putFile(File(recordFilePath));
    task.then((value) async {
      print('##############done#########');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      onSendMessage(strVal, 2);
    }).catchError((e) {
      print(e);
    });
  }

  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  ///////////////////////Below is Delete Message ////////////////////////////
  //////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////

  bool _showDeleteContainer = false;

  void _handleLongPressDelete(String docId) {
    setState(() {
      _showDeleteContainer = true;
    });

    // Show the delete bottom sheet
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 10,
              ),
              Divider(
                endIndent: 155,
                indent: 155,
                color: Colors.grey.shade400,
                thickness: 6,
              ),
              const SizedBox(
                height: 15,
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Delete Message',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                onTap: () {
                  // Handle the delete action here
                  // _hideDeleteContainer();
                  // Navigator.pop(context); // Close the bottom sheet

                  showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Are you sure?'),
                          content:
                              const Text('Do you want to delete this message?'),
                          actions: <Widget>[
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    primaryColor, // Change the background color here
                              ),
                              child: const Text('No'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                deleteMessage(docId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    primaryColor, // Change the background color here
                              ),
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _hideDeleteContainer() {
    setState(() {
      _showDeleteContainer = false;
    });
  }

  Future<void> deleteMessage(String documentId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(documentId)
        .delete();
  }
}

class FullPhoto extends StatelessWidget {
  final String url;

  const FullPhoto({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FULL PHOTO',
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FullPhotoScreen(url: url),
    );
  }
}

class FullPhotoScreen extends StatefulWidget {
  final String url;

  const FullPhotoScreen({Key? key, required this.url}) : super(key: key);

  @override
  State createState() => FullPhotoScreenState(url: url);
}

class FullPhotoScreenState extends State<FullPhotoScreen> {
  final String url;

  FullPhotoScreenState({Key? key, required this.url});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: PhotoView(imageProvider: NetworkImage(url)));
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.8),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      ),
    );
  }
}
