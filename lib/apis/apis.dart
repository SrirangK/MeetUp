import 'package:MeetUp/models/chat_user.dart';
import 'package:MeetUp/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';



class APIS{
  // for authentication
  static FirebaseAuth auth =FirebaseAuth.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore =FirebaseFirestore.instance;

  //for accesing firebase storage
  static FirebaseStorage storage =FirebaseStorage.instance;


  //for storing slf information
  static late ChatUser me;

  //to return current user
  static User get user =>auth.currentUser!;

  // static List<ChatUser> _list = [];
  // static List<ChatUser> _searchList=[];
  // static bool _isSearching=false;


  //to check if user exist or not
  static Future<bool> userExist() async{
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for getting current user info
  static Future<void> getSelfInfo() async{
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if(user.exists){
        me=ChatUser.fromJson(user.data()!);
      }else{
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  //for creating a new user
  static Future<void> createUser  () async{
    final time=DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser=ChatUser(id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      status: '...',
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      interest: ' ',
    );
    return (await firestore.collection('users').doc(user.uid).set(chatUser.toJson()));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getmyUserId(){
    return firestore.collection('users').doc(user.uid).collection('my_users').snapshots();
  }
//for getting all users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getALLUsers(){
    return firestore
        .collection('users')
        .where('id',isNotEqualTo: user.uid ,)
        .snapshots();
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getsomeUsers(interest){
    return firestore
        .collection('users')
        // .where('name',isNotEqualTo: me.name)
        .where('interest',isEqualTo: interest ,)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUsersid(List<String> userIds){
    if(userIds.isNotEmpty) {
      return firestore
          .collection('users')
          .where('id', whereIn: userIds)
          .snapshots();
    }else{
      return firestore
          .collection('users')
          .where('id', isEqualTo: 'dummy')
          .snapshots();
    }
  }


  static Future<void> sendFirstmessage(ChatUser chatuser,String msg,Type type) async{
    await firestore
          .collection('users')
          .doc(chatuser.id)
          .collection('my_users')
          .doc(user.uid)
          .set({}).then((value) =>sendMessege(chatuser, msg, type));

  }

  //to update user info
  static Future<void> updateUserInfo() async{
     await firestore.collection('users').doc(user.uid).update({'name':me.name,'status':me.status,'interest':me.interest});
  }

  //update profile pic
  static Future<void> updateProfilePicture(File file) async{
    final extension=file.path.split('.').last;
    final ref=storage.ref().child('profile_pictures/${user.uid}.$extension');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$extension'));
    me.image=await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image':me.image});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserinfo(ChatUser chatuser){
    return firestore
          .collection('users')
          .where('id',isEqualTo: chatuser.id)
          .snapshots();

  }


//for getting msg of specific conversation
static String getConversationID(String id)=>user.uid.hashCode <=id.hashCode ?'${user.uid}_$id':'${id}_${user.uid}';
//chat screen api
  static Stream<QuerySnapshot<Map<String, dynamic>>> getALLMesseges(ChatUser user){
    return firestore
        .collection('chats/${getConversationID(user.id)}/messeges/')
        .orderBy('sent',descending: true)
        .snapshots();
  }

  //for sending msg
  static Future<void> sendMessege(ChatUser chatuser,String msg,Type type) async
  {
    //messege sending time also used as id
    final time=DateTime.now().millisecondsSinceEpoch.toString();
    //messege to send
    final Message message=Message(msg: msg,
                                  toId: chatuser.id,
                                  read: '',
                                  type: type,
                                  fromId: user.uid,
                                  sent: time);
    final ref=firestore.collection('chats/${getConversationID(chatuser.id)}/messeges/');
    await ref.doc(time).set(message.toJson());

  }


  static Stream<QuerySnapshot<Map<String, dynamic>>> getlastmessage(ChatUser user){
    return firestore
        .collection('chats/${getConversationID(user.id)}/messeges/')
        .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();

  }

  static Future<void> sendChatImage(ChatUser chatuser,File file) async {
    final extension=file.path.split('.').last;
    final ref=storage.ref().child('images/${getConversationID(chatuser.id)}/${DateTime.now().millisecondsSinceEpoch}.$extension');
    await ref.putFile(file, SettableMetadata(contentType: 'image/$extension'));
    final imageURL=await ref.getDownloadURL();
    await sendMessege(chatuser, imageURL, Type.image);
  }

  //delete message
  static Future<void> deleteMessage(Message message)async{
     await firestore
        .collection('chats/${getConversationID(message.toId)}/messeges/')
        .doc(message.sent)
        .delete();
      if(message.type==Type.image){
        await storage.refFromURL(message.msg).delete();
      }
  }
  static Future<bool> addChatUser(String name) async{
    final data=await firestore.collection('users').where('name',isEqualTo: name).get();
    if(data.docs.isNotEmpty && data.docs.first.id !=user.uid){
       firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id).set({});
      return true;
    }else{
      return false;
    }
  }


}