import 'package:flutter/material.dart';
import 'package:task3/userdatabase.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package
import 'userinfo.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  List<UserInfo> users = [];

  @override
  void initState() {
    //in the login page i load all the users to be displayed
    super.initState();
    _loadUsers();
  }

  void _loadUsers() async {
    List<UserInfo> userList = await UserDatabase.instance.getUsers();
    setState(() {
      users = userList;
    });
  }

  void _showAddUserDialog() async {
    String firstName = '';
    String lastName = '';
    DateTime? selectedDate;

    bool areInputsValid() {
      return firstName.length >= 2 &&
          lastName.length >= 2 &&
          selectedDate != null;
    }

    UserInfo? newUser = await showDialog<UserInfo>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'First Name'),
                onChanged: (value) {
                  firstName = value.trim();
                  setState(() {});
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Last Name'),
                onChanged: (value) {
                  lastName = value.trim();
                  setState(() {});
                },
              ),
              ElevatedButton(
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  ).then((date) {
                    if (date != null) {
                      setState(() {
                        selectedDate = date;
                      });
                    }
                  });
                },
                child: Text('Select Date'),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (areInputsValid()) {
                      var uuid = Uuid(); // Create an instance of the Uuid class
                      UserInfo newUser = UserInfo(
                        userId: uuid.v4(), // Generate the UUID
                        firstName: firstName,
                        lastName: lastName,
                        dateOfBirth: selectedDate!,
                      );

                      await UserDatabase.instance
                          .insertUser(newUser); // Save user to the database

                      setState(() {
                        //ta farjiyon aal ui
                        users.add(newUser);
                      });
                      Navigator.pop(context, newUser);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please enter valid information for all fields.')),
                      );
                    }
                  },
                  child: Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        );
      },
    );

    if (newUser != null) {
      // Do something with the newly added user, if needed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return _buildUserCard(users[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserCard(UserInfo user) {
    String initials = '${user.firstName[0]}${user.lastName[0]}'.toUpperCase();
    String formattedDate = DateFormat('dd/MM/yyyy').format(user.dateOfBirth);

    void _deleteUser() async {
      await UserDatabase.instance.deleteUser(user.userId); //i delete from DB

      setState(() {
        users.remove(user);
      });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                      'Date of Birth: $formattedDate'), // Use the formatted date
                ],
              ),
            ),
            IconButton(
              onPressed:
                  _deleteUser, // Call the _deleteUser method on button press yalli kamen btaamel delete men db
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
