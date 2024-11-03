// // lib/add_user_page.dart
// import 'package:flutter/material.dart';
// import 'user.dart';

// class AddUserPage extends StatefulWidget {
//   final Function(User) onUserAdded;

//   AddUserPage({required this.onUserAdded});

//   @override
//   _AddUserPageState createState() => _AddUserPageState();
// }

// class _AddUserPageState extends State<AddUserPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _ageController = TextEditingController();

//   void _addUser() {
//     if (_formKey.currentState!.validate()) {
//       final user = User(
//         name: _nameController.text,
//         email: _emailController.text,
//         age: int.parse(_ageController.text),
//       );
//       widget.onUserAdded(user);
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add User")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(labelText: "Name"),
//                 validator: (value) => value!.isEmpty ? "Enter a name" : null,
//               ),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(labelText: "Email"),
//                 validator: (value) =>
//                     value!.isEmpty ? "Enter an email" : null,
//               ),
//               TextFormField(
//                 controller: _ageController,
//                 decoration: InputDecoration(labelText: "Age"),
//                 keyboardType: TextInputType.number,
//                 validator: (value) =>
//                     value!.isEmpty ? "Enter an age" : null,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _addUser,
//                 child: Text("Add User"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'user.dart'; // Make sure to import the User model

class AddUserPage extends StatefulWidget {
  final Function(User) onUserAdded;

  const AddUserPage({super.key, required this.onUserAdded});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();

  void _submit() {
    final name = _nameController.text;
    final email = _emailController.text;
    final age = int.tryParse(_ageController.text);

    if (name.isNotEmpty && email.isNotEmpty && age != null) {
      final newUser = User(name: name, email: email, age: age);
      widget.onUserAdded(newUser);
      Navigator.of(context).pop(); // Go back to the user list screen
    } else {
      // Handle input validation
      print('Invalid input');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
