import 'package:flutter/material.dart';
import 'RegisterInfo.dart';

class UserAgreementPage extends StatefulWidget {
  @override
  _UserAgreementPageState createState() => _UserAgreementPageState();
}

class _UserAgreementPageState extends State<UserAgreementPage> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Consent Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMILES Study Consent Form',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Purpose: The purpose of this study is to evaluate the feasibility of tracking stress, sleep, and physical activities using ecological momentary assessment (EMA) among graduate students and postdoctoral fellows at UCI.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Participation Details:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '- Eligibility: You must be 18 or older, a graduate student or postdoc in STEM or Health Science at UCI, not pregnant, own a smartphone with Wi-Fi access, and be willing to complete EMA surveys.\n'
                      '- Procedures: During the 3-5 month study, you will complete weekly EMA surveys (~5 minutes), provide baseline information (~10-20 minutes), and complete an exit assessment (~30 minutes).\n'
                      '- Data Collected: Health-related data, including sleep, physical activity, and stress levels, will be stored electronically on a secure, password-protected computer network at UCI.\n'
                      '- Risks: There may be brief emotional distress during EMA surveys. Contact details will be provided for support.\n'
                      '- Benefits: No direct benefits, but this study may increase awareness of the connections between stress, sleep, and physical activities.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Confidentiality:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Your identifiable information will be replaced with anonymous data. Only authorized research team members will have access, and no third-party access will be permitted. All data will be stored securely.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cost and Compensation:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'There are no costs or compensation for participation.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Contact Information:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'For questions about the study or your rights as a participant, contact the lead researcher, Dr. Yuqing Guo by (949) 824-9057 or gyuqing@uci.edu, or the UCI Institutional Review Board.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Consent Acknowledgment:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'By agreeing to this consent form, you confirm that you:\n'
                      '1. Understand the purpose, procedures, risks, and benefits of the study.\n'
                      '2. Agree to the confidentiality terms and data handling procedures.\n'
                      '3. Acknowledge that participation is voluntary and that you may withdraw at any time.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: 'I have read and fully understand the consent form and agree to its terms.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isChecked
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    }
                  : null, // Disable the button if not checked
              child: Text('Agree and Continue to Register'),
            ),
          ],
        ),
      ),
    );
  }
}
