import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Info',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: UserPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<String> userName;

  @override
  void initState() {
    super.initState();
    userName = fetchUserName();
  }

  Future<String> fetchUserName() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'];
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        title: Text(
          'User Info',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 5,
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: userName,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(
                color: Colors.blue.shade700,
              );
            } else if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 18),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(30),
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, size: 50, color: Colors.blue.shade700),
                    SizedBox(height: 20),
                    Text(
                      'User Name:',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${snapshot.data}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
