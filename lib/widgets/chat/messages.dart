import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futureSnapShot) {
          if (futureSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return StreamBuilder(
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, chatSnapShot) {
                if (chatSnapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatdoc = chatSnapShot.data.documents;
                return ListView.builder(
                    itemCount: chatdoc.length,
                    reverse: true,
                    itemBuilder: (context, index) => MessageBubble(
                          chatdoc[index]['text'],
                          chatdoc[index]['userName'],
                          chatdoc[index]['userImage'],
                          chatdoc[index]['userId'] == futureSnapShot.data.uid,
                          key: ValueKey(chatdoc[index].documentID),
                        ));
              });
        });
  }
}
