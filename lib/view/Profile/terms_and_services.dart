import 'package:flutter/material.dart';
import 'package:travelapp/custom_widgests/custom_text.dart';

class TermsAndServices extends StatelessWidget {
  const TermsAndServices({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const CustomText(text: 'Terms and Conditions'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text(
                    ''' Welcome to "Destinoz". By using our mobile application, you agree to these Terms and Service. Please read them carefully.
          
------ 1. Acceptance of Terms------
          
By accessing and using "Destinoz" ("the App"), you accept and agree to be bound by these terms. If you do not agree, please do not use the App.
          
------ 2. Use of the App------
          
Eligibility: There is no age restriction to use the App.
Personal Use: The App is intended for your personal use only.
------ 3. Local Data Storage------
          
Data Storage: All information, including personal data, is stored locally on your device. The App does not transmit or store data on external servers.
Data Responsibility: You are solely responsible for managing and securing your data.
------ 4. User Responsibilities------
          
          You agree not to:
          
Use the App for any illegal or unauthorized purpose.
Attempt to interfere with the proper working of the App.
------ 5. Intellectual Property------
          
All content and materials within the App are owned by [Your Company Name] and are protected by applicable intellectual property laws.
          
------ 6. Limitation of Liability------
          
_____pvt.Ltd is not liable for any damages resulting from your use of the App, including data loss or unauthorized access to your data stored locally.
          
------ 7. Changes to These Terms------
          
We may update these Terms and Service occasionally. Any changes will be reflected by the "Last Updated" date. Continued use of the App after changes implies acceptance of the new terms.
          
''')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
