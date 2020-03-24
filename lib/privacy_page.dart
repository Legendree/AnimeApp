import 'package:animist/drawer.dart';
import 'package:flutter/material.dart';
import 'package:animist/constants.dart';

class PolicyPage extends StatefulWidget {
  static String id = 'policy_page';
  @override
  _PolicyPageState createState() => _PolicyPageState();
}

class _PolicyPageState extends State<PolicyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AnimistDrawer(),
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xff181818),
            title: Text('PRIVACY & POLICY')),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(kPolicyIntro, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Information Collection and Use',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Text(kInfromationAndUse, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Log Data',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Text(kCookiesText, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Service Providers',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Text(kServiceText, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Security',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Text(kSecurityText, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Links to Other Sites',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Text(kLinksText, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Children’s Privacy',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Text(kChildrenPrivacy, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Changes to This Privacy Policy',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Text(kChangesText, style: TextStyle(color: Colors.white.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Contact Us',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  kContact
                ],
              ),
            ),
          ),
        ));
  }
}
