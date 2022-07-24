import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WebFirebaseAuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //WebFeirestoreService _webFeirestoreService =
  // Get.find<WebFeirestoreService>();
  //final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  UserData _userFromFirebase(User user) {
    /// modo anonimo nao retorna email e nome
    return UserData(
      uid: user.uid,

      /// retornado nulo no modo anonimo
      email: user.email ?? '',
      displayName: user.displayName ?? '',
      photoUrl: user.photoURL ?? '',
    );
  }

  Stream<UserData?> get onAuthStateChanged {
    return auth.authStateChanges().map((user) {
      //debugPrint(user.toString() + 'TESTE USER FIRE GET');
      if (user != null)
        return _userFromFirebase(user);
      else
        return null;
    });
    //auth.onAuthStateChanged.map(_userFromFirebase);
  }

  Future<UserData?> signInAnonymously() async {
    final UserCredential authResult = await auth.signInAnonymously();
    if (authResult.user != null) {
      return _userFromFirebase(authResult.user!);
    }
    return null;
  }

  Future<UserData?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult =
          await auth.signInWithCredential(credential);
      if (authResult.user != null) {
        /* await _webFeirestoreService.postUser(UserData(
            uid: authResult.user!.uid,
            email: authResult.user!.email ?? '',
            displayName: authResult.user!.displayName ?? ''));*/
        return _userFromFirebase(authResult.user!);
      } else
        return null;
    }
    return null;
  }

  Future<void> signOut() async {
    return auth.signOut();
  }

  UserData? currentUser() {
    final user = auth.currentUser;
    if (user != null) {
      /// ANONIMO nao retornar displayname
      if (user.displayName == null) {
        return null;
      }
      return _userFromFirebase(user);
    } else
      return null;
  }
}

class UserData {
  String uid;
  String email;
  String displayName;
  String photoUrl;

  UserData(
      {required this.uid,
      required this.email,
      required this.displayName,
      this.photoUrl = ''});

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        uid: json['uid'] as String,
        email: json['email'] as String,
        displayName: json['displayName'] as String,
        photoUrl: json['photoUrl'] as String,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl
      };

  @override
  String toString() => 'User: name: $displayName, email: $email, uid: $uid';
}
