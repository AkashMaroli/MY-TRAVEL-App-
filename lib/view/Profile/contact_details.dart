import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';


class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Contact Information:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Email: akashpsa.dev@gmail.com',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Phone: +1234567890',
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              'Address: Indian',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20.0),
            Text(
              'Social Media:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                Icon(Icons.menu),
                SizedBox(width: 10.0),
                Text('Likedin: www.linkedin.com/in/akash-maroli-a53a502b0'),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(EvaIcons.menu),
                SizedBox(width: 10.0),
                Text('Github: https://github.com/kaashii-coder'),
              ],
            ),
            Row(
              children: <Widget>[
                Icon(EvaIcons.menu),
                SizedBox(width: 10.0),
                Text('Instagram: developer__field'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}