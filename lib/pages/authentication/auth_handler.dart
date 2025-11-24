import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AuthHandler extends ChangeNotifier {
  Session? session = supabase.auth.currentSession;
  User? user = supabase.auth.currentUser;
  bool loading = false;

  SupabaseStreamBuilder stream = supabase
      .from('chat_messages')
      .stream(primaryKey: ['id'])
      .eq('user_id', "");

  List<dynamic> messageList = [];

  List<dynamic> messages = [{}];
  int currentChat = -1;

  //Get User Display Name
  Future<String> getDisplayName() async {
    try {
      final data = await supabase
          .from('display_info')
          .select('display_name')
          .eq('user_id', user!.id);
      print(data);
      return data[0]["display_name"];
    } catch (e) {
      print(e);
      return "Null";
    }
  }

  //Upsert Display Name
  Future<String> updateDisplayName(String name) async {
    try {
      final data =
          await supabase.from('display_info').upsert({
            'display_name': name,
          }).select();
      return data[0]["display_name"];
    } catch (e) {
      print(e);
      return "Error";
    }
  }

  //Get user Email
  Future<String> getEmail() async {
    try {
      print(user!.email);
      return user!.email ?? "Null";
    } catch (e) {
      print(e);
      return "Null";
    }
  }

  //Change Password
  Future<void> changePassword(String password) async {
    try {
      final UserResponse res = await supabase.auth.updateUser(
        UserAttributes(password: password),
      );
      user = res.user;
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  //Create a new account
  Future<void> createAccount(String email, String password) async {
    await supabase.auth.signUp(email: email, password: password);
    user = supabase.auth.currentUser;
    notifyListeners();
  }

  //login to Existing account
  Future<void> login(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
    user = supabase.auth.currentUser;
    notifyListeners();
  }

  //Sign in with google
  /*signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(OAuthProvider.google);
  }*/

  //Logout
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  //Reset Chat
  Future<void> reset() async {
    currentChat = -1;
    notifyListeners();
  }

  //Fetch Messages
  Future<void> setChat({required int id}) async {
    messages = [{}];
    try {
      currentChat = id;
      final res = await supabase
          .from("chat_messages")
          .select("messages")
          .eq("id", currentChat);
      messages = res[0]["messages"];
      //print("chat set");
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat({required int id}) async {
    try {
      await supabase.from('chat_messages').delete().eq('id', id);
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  //Listen to data changes
  Future<void> listenMessages() async {
    stream = supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('user_id', user!.id);
  }

  SupabaseStreamBuilder streamFunction() {
    return stream = supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('user_id', user!.id);
  }

  //Insert Existing messages
  void insertMessage({required List<dynamic> insert}) {
    messages = insert;
    notifyListeners();
  }

  //Stream messages
  Stream<List<dynamic>> streamCurrentMessages() {
    if (user == null) {
      // If no user is logged in, return a stream that emits an empty list.
      return Stream.value([]);
    }
    return supabase
        .from('chat_messages') // Your table for chat conversations/rooms
        .stream(primaryKey: ['id']) // 'id' should be the PK of 'chat_messages'
        .eq('user_id', user!.id) // Filter by the current user's ID
        .order('created_at', ascending: false) // Optional: order chats
        .map((maps) => maps);
  }

  SupabaseStreamBuilder streamMessages({required id}) {
    return stream = supabase
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('id', id);
  }

  bool showIcon = false;
  void changeShowIcon(bool a) {
    showIcon = a;
    notifyListeners();
  }

  //Change loading indicator
  void changeLoadingIndicator(bool a) {
    loading = a;
    notifyListeners();
  }

  //Idek what this does
  void updateMessagesAndLoading(
    List<dynamic> newMessages,
    bool newLoadingStatus,
  ) {
    bool changed = false;
    if (messages != newMessages) {
      // Simple reference check; deep equality if needed
      messages = newMessages;
      changed = true;
    }
    if (loading != newLoadingStatus) {
      loading = newLoadingStatus;
      changed = true;
    }
    if (changed) {
      notifyListeners();
    }
  }

  //Create Message
  Future<void> createMessage(String message) async {
    //Check the chat id
    if (currentChat == -1) {
      messages = [
        {"role": "user", "content": message},
      ];
      try {
        //Insert a new table in Messages
        final res =
            await supabase.from("chat_messages").upsert({
              "name": message.length > 30 ? message.substring(0, 30) : message,
              "messages": messages,
              "loading": true,
            }).select();
        //Set the value of current chat
        currentChat = res[0]["id"];
        //set loading=true
        print("Success");
      } catch (e) {
        print(e);
      } finally {
        notifyListeners();
      }
    } else {
      //Add values to existing messages
      try {
        messages.add({"role": "user", "content": message});
        final res =
            await supabase
                .from("chat_messages")
                .update({"messages": messages, "loading": true})
                .eq("id", currentChat)
                .select();
        messages = res[0]["messages"];
        loading = true;
        print("Message added successfully");
      } catch (e) {
        print(e);
      } finally {
        notifyListeners();
      }
    }
  }
}
