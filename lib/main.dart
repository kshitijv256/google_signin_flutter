import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_options.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
Future<void> _handleSignOut() => googleSignIn.disconnect();

Future<void> currentUser() async {
  final GoogleSignInAccount? account = await googleSignIn.signIn();
  final GoogleSignInAuthentication authentication =
      await account!.authentication;

  final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken, accessToken: authentication.accessToken);

  final UserCredential authResult =
      await _auth.signInWithCredential(credential);
  final User? user = authResult.user;
  print(user!.displayName);
  print(user.displayName);
  print(user.displayName);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool status = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: (status)
              ? [
                  const SizedBox(
                    height: 20,
                  ),
                  Image(
                    image: NetworkImage(user!.photoURL!),
                  ),
                  Text(
                    'Username: ${user!.displayName}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Email: ${user!.email}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'Phone: ${user!.phoneNumber}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    'UID: ${user!.uid}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  ElevatedButton(
                    onPressed: (() => {
                          _handleSignOut,
                          _auth.signOut(),
                          setState(() {
                            debugPrint('Signed out');
                            status = false;
                          }),
                          reassemble()
                        }),
                    child: const Text('Sign out'),
                  ),
                ]
              : [
                  ElevatedButton(
                    onPressed: (() async => {
                          await currentUser(),
                          setState(() {
                            debugPrint('Signed in');
                            status = true;
                          }),
                        }),
                    child: const Text('Sign in with Google'),
                  ),
                ],
        ),
      ),
    );
  }
}
