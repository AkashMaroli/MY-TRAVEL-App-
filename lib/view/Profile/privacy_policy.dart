import 'package:flutter/material.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Privacy Policy'),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(13.0),
          child: Column(
            children: [
              Text(
                '''
          
Welcome to "Destinoz".We respect your privacy and are committed to protecting your personal information. This Privacy Policy outlines how we handle your data.
          
-----1. Information We Collect-----
          
We collect personal information, such as your name, email address, travel preferences and enhance your experience. All data is stored locally on your device.
          
-----2. Use of Your Information-----
          
We use your information to:
Personalize your app experience.
Communicate with you regarding confirmations, updates, and support.

-----3. Data Storage and Security-----
          
Your data is stored locally on your device. We implement reasonable security measures to protect your data, but no system is completely secure.
          
-----4. Your Choices-----
          
You can review, update, export, or delete your personal information through the app's settings at any time.
          
-----5. Children’s Privacy-----
          
Our app is for every person, and we do not knowingly collect data from them.
          
-----6. Contact Us-----
          
If you have any questions about this Privacy Policy, please contact us at [Your Contact Email].
By using the app, you agree to this Privacy Policy.''',
                style: TextStyle(fontSize: 14.5),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.black,
                indent: 40,
                endIndent: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
