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
                    
                    // 1. Nature, Purpose, and Duration
                    Text(
                      'Nature, Purpose, and Duration:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'This study aims to evaluate the feasibility of tracking stress, sleep, and physical activities using ecological momentary assessment (EMA) among graduate students and postdoctoral fellows at UCI. The study will last for approximately 3-5 months, during which you will be asked to complete daily EMA surveys.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    
                    // 2. Procedures, Risks, and Benefits
                    Text(
                      'Procedures, Risks, and Benefits:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '- **Procedures**: You will complete daily EMA surveys (~5 minutes), provide baseline information (~10-20 minutes), and participate in an exit assessment (~30 minutes).\n'
                      '- **Risks**: There may be brief emotional discomfort during the EMA surveys. Support contact details will be provided in case of any distress.\n'
                      '- **Benefits**: There are no direct benefits to participating in this study. However, your involvement may help in better understanding the relationship between stress, sleep, and physical activities.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    
                    // 3. Confidentiality and Data Handling
                    Text(
                      'Confidentiality and Data Handling:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'All collected data will be kept confidential. Your identifiable information will be replaced with anonymous data. Only authorized research team members will have access to your information, and no third-party access will be permitted. Data will be stored securely on a password-protected computer network at UCI.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    
                    // 4. Contact Information
                    Text(
                      'Contact Information:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'If you have any questions regarding the study or your rights as a participant, you may contact the lead researcher, Dr. Yuqing Guo, at (949) 824-9057 or via email at gyuqing@uci.edu. You can also reach out to the UCI Institutional Review Board for further information.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 16),
                    
                    // 5. Withdrawal Process
                    Text(
                      'Withdrawal Process:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Participation in this study is entirely voluntary. You have the right to withdraw from the study at any time without penalty. Should you choose to withdraw, please contact the research team using the information provided above.',
                      style: TextStyle(fontSize: 16),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Consent Acknowledgment
                    Text(
                      'Consent Acknowledgment:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'By agreeing to this consent form, you confirm that you have read and understood the nature, purpose, procedures, risks, and benefits of the study. You also agree to the confidentiality terms and acknowledge that participation is voluntary.',
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
