import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hearthy_food/add_user_page.dart';
import 'package:path_provider/path_provider.dart';
import 'user.dart'; 

void main() {
  runApp(MyApp());
}

Future<List<User>> loadUsers() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/users.json');

  // Check if file exists; if not, copy from assets
  if (await file.exists()) {
    final data = await file.readAsString();
    final List<dynamic> jsonData = json.decode(data);
    return jsonData.map((json) => User.fromJson(json)).toList();
  } else {
    final data = await rootBundle.loadString('assets/users.json');
    await file.writeAsString(data); 
    final List<dynamic> jsonData = json.decode(data);
    return jsonData.map((json) => User.fromJson(json)).toList();
  }
}

Future<void> saveUsers(List<User> users) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/users.json');

  final data = json.encode(users.map((user) => user.toJson()).toList());
  await file.writeAsString(data);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSON Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserListScreen(),
    );
  }
}

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late Future<List<User>> users;

  @override
  void initState() {
    super.initState();
    users = loadUsers(); // Load users from writable directory
  }

  void _addUser(User user) async {
    final userList = await users;
    userList.add(user);
    await saveUsers(userList); // Save updated list
    setState(() {
      users = Future.value(userList); // Update future for the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddUserPage(onUserAdded: _addUser),
              ));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No users found"));
          } else {
            final userList = snapshot.data!;
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text('${user.email} - Age: ${user.age}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
