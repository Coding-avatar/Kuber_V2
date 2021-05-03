import 'dart:async';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kuber_starline/app_models/message_item.dart';
import 'package:kuber_starline/constants/project_constants.dart';
import 'package:kuber_starline/customs/custom_chat_bubble.dart';
import 'package:kuber_starline/customs/show_custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageItem> listOfChatMessages = List();
  TextEditingController chatMessageController;

  String authToken = "";
  String fcmToken = "";

  DatabaseReference databaseRef;
  StreamSubscription dbRef;
  FirebaseStorage firebaseStorage;
  // AudioCache audioCache = AudioCache();
  // AudioPlayer advancedPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    firebaseStorage = FirebaseStorage.instance;

    chatMessageController = TextEditingController();

    fetchUserDetails();
    // initAudioFiles();

    databaseRef = FirebaseDatabase().reference().child('messages');

    // getAllMessages();

    dbRef = databaseRef.onChildAdded.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      if (snapshot != null) {
        String sender = snapshot.value['sender'];
        String receiver = snapshot.value['receiver'];
        String messageBody = snapshot.value['message'];
        String read = snapshot.value['isread'];
        bool isRead = false;

        if (read != null && read.toLowerCase() != 'unread') {
          isRead = true;
        }

        if ((sender.toLowerCase() == 'admin' && receiver == authToken) ||
            (sender == authToken && receiver.toLowerCase() == 'admin')) {
          MessageItem messageItem =
              MessageItem(senderId: sender, body: messageBody, isRead: isRead);

          setState(() {
            listOfChatMessages.add(messageItem);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    dbRef.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/default_background.jpg"),
                    fit: BoxFit.cover),
                //color: Color(0xffbde7e6),

                // image: new DecorationImage(
                //   image: AssetImage(
                //     'images/casino_bg.jpg',
                //   ),
                //   fit: BoxFit.cover,
                //   colorFilter: ColorFilter.mode(
                //       Colors.black.withOpacity(0.2), BlendMode.dstATop),
                // ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 40, 0, 0),
                child: InkWell(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 26,
                  ),
                  onTap: () {
                    onBackPressed();
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 30, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/default_user.png',
                            height: 32,
                            width: 32,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'ADMIN SIR',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ],
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 80, 0, 80),
              height: MediaQuery.of(context).size.height,
              child: listOfChatMessages.isNotEmpty
                  ? buildChatListWidget()
                  : Center(
                      child: Text(
                        'No messages to show',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: chatBoxContainer(),
            )
          ],
        ),
      ),
      onWillPop: onBackPressed,
    );
  }

  Future<bool> onBackPressed() async {
    listOfChatMessages.clear();
    dbRef.cancel();
    Navigator.of(context).pop();
    return true;
  }

  Widget chatBoxContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 60,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: TextField(
              controller: chatMessageController,
              maxLines: null,
              onSubmitted: (value) => addChatToList(value, true),
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Colors.transparent)),
                border: new OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(10.0),
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(color: Colors.grey[800]),
                hintText: "Type in your text",
                fillColor: Colors.white70,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.attach_file_rounded,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    getImage();
                  },
                ),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          ClipOval(
            child: Material(
              shape: CircleBorder(),
              color: Colors.lightBlue, // button color
              child: InkWell(
                splashColor: Colors.red, // inkwell color
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.send_rounded,
                    size: 20,
                  ),
                ),
                onTap: () {
                  String message = chatMessageController.text.trim();
                  if (message.isNotEmpty) {
                    addChatToList(message, true);
                    // audioCache.play('assets/me-too-603-mp3.mp3');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  addChatToList(String body, bool playSound) {
    if (body.isNotEmpty) {
      // MessageItem messageItem = MessageItem(senderId: authToken, body: body);

      setState(() {
        chatMessageController.text = "";
      });

      databaseRef.push().set(
        {
          "message": body,
          // "timestamp": DateTime.now().millisecondsSinceEpoch,
          'sender': authToken,
          'receiver': 'Admin',
          'isread': 'Unread',
        },
      );
    }
  }

  void fetchUserDetails() {
    SharedPreferences.getInstance().then((sharedPrefs) {
      authToken = sharedPrefs.getString(Constants.SHARED_PREF_AUTH_TOKEN);
      fcmToken = sharedPrefs.getString(Constants.SHARED_PREF_FCM_TOKEN);
    });
  }

  Widget buildChatItem(int index) {
    MessageItem messageItem = listOfChatMessages.reversed.toList()[index];

    bool _isURL = Uri.parse(messageItem.body).isAbsolute;

    if (!_isURL) {
      return Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: messageItem.senderId == authToken
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              CustomChatBubble(
                text: messageItem.body,
                color: messageItem.senderId == authToken
                    ? Colors.orange
                    : Colors.green,
                isSender: messageItem.senderId == authToken,
                textStyle: TextStyle(color: Colors.white),
              ),
            ],
          ));
    } else {
      return Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: messageItem.senderId == authToken
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              ClipRRect(
                child: InkWell(
                  child: Image.network(
                    messageItem.body,
                    height: 120,
                    width: 120,
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    showDialog(
                        context: (context),
                        builder: (buildContext) {
                          return CustomAlertDialog(
                            contentPadding: EdgeInsets.all(2),
                            content: Container(
                                height: 200,
                                child: ClipRRect(
                                  child: Image.network(
                                    messageItem.body,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(24),
                                )),
                          );
                        });
                  },
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ));
    }
  }

  buildChatListWidget() {
    return ListView.builder(
        itemCount: listOfChatMessages.length,
        reverse: true,
        shrinkWrap: true,
        itemBuilder: (context, index) => buildChatItem(index));
  }

  void getAllMessages() {
    List<MessageItem> list = List();
    FirebaseDatabase().reference().child('messages').once().then((snapshot) {
      if (snapshot != null && snapshot.value != null) {
        Map snapShotData = snapshot.value;
        print('Fetched messages: ${snapShotData.toString()}');

        snapShotData.forEach((index, data) {
          String messageBody = data['message'];
          String sender = data['sender'];
          String receiver = data['receiver'];

          if (sender == authToken ||
              (sender.toLowerCase() == 'admin' && receiver == authToken)) {
            MessageItem messageItem = new MessageItem(
                body: messageBody, senderId: sender, isRead: true);
            list.add(messageItem);
          }
        });

        setState(() {
          listOfChatMessages = list;
        });
      }
    });
  }

  Future getImage() async {
    String imagePath = "";
    String fileName = "";
    File imageFile;

    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        imageFile = File(imagePath);
        fileName = imagePath.substring(
            imagePath.lastIndexOf('/'), imagePath.lastIndexOf('.'));
      });

      showDialog(
          context: context,
          builder: (buildContext) {
            return Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          });

      uploadImageToFirebase(imagePath, fileName).then((imageUrl) {
        addChatToList(imageUrl, false);
        // Pop the dialog
        Navigator.of(context).pop();
      });
    }
  }

  Future<String> uploadImageToFirebase(String filePath, String fileName) async {
    String timeStamp = (DateTime.now().millisecondsSinceEpoch).toString();

    String name = '$timeStamp-$fileName.png';
    Reference reference = FirebaseStorage.instance.ref().child(name);
    TaskSnapshot taskSnapshot = await reference.putFile(new File(filePath));
    return taskSnapshot.ref.getDownloadURL();
  }
}
