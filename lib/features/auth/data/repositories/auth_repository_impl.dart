import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:users_hub/features/auth/domain/repositories/auth_repository.dart';
import 'package:users_hub/features/profile/domain/entities/user.dart' as domain;
import 'package:users_hub/features/profile/domain/repositories/profile_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final ProfileRepository _profileRepository; // 👈 inject this
  // bool _isGoogleSignInInitialized = false;
  // GoogleSignInAccount? _currentUser;

  AuthRepositoryImpl(
    this._firebaseAuth,
    this._googleSignIn,
    this._profileRepository,
  );
  //  {
  //   _initializeGoogleSignIn();
  // }

  // Initialize GoogleSignIn asynchronously
  // Future<void> _initializeGoogleSignIn() async {
  //   try {
  //     await _googleSignIn.initialize(serverClientId: '1014340416116-o2bfs3b89quce5a4cuflgqhce920j3j5.apps.googleusercontent.com');
  //     _isGoogleSignInInitialized = true;
  //     print("GoogleSignIn initialized");
  //   } catch (e) {
  //     print('Failed to initialize Google Sign-In: $e');
  //   }
  // }

  // Future<void> _ensureGoogleSignInInitialized() async {
  //   if (!_isGoogleSignInInitialized) {
  //     await _initializeGoogleSignIn();
  //   }
  // }

  // @override
  // Stream<User?> authStateChanges() {
  //   return _firebaseAuth.authStateChanges();
  // }

  // Sign in with Google
  @override
  Future<User?> signInWithGoogle() async {
    //await _ensureGoogleSignInInitialized();

    try {
      // Authenticate user (throws exceptions if fails)
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate(
      //  scopeHint: ['email'],
      );

      // _currentUser = googleUser;

      // Get authorization for scopes
      //  final authClient = _googleSignIn.authorizationClient;
      //  final authorization = await authClient.authorizationForScopes(['email']);

      // Get Firebase auth tokens
      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        //     accessToken: authorization?.accessToken,
      );

      // Sign in to Firebase
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      final firebaseUser = userCredential.user;
    print('google signin response are${userCredential.user}');
      if (firebaseUser == null) return null;
      // Print user details
      final domainUser = domain.User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? '',
        email: firebaseUser.email ?? '',
        avatar: firebaseUser.photoURL ?? '',
        phoneno: firebaseUser.phoneNumber??''
);
//save profile locally
await _profileRepository.saveProfile(domainUser);
      // if (user != null) {
      //   print('Signed in successfully!');
      //   print('User UID: ${user.uid}');
      //   print('User Name: ${user.displayName}');
      //   print('User Email: ${user.email}');
      //   print('User Photo URL: ${user.photoURL}');
      // } else {
      //   print('No user signed in.');
      // }

      return firebaseUser;
    } on GoogleSignInException catch (e) {
      print(
        'Google Sign In error: code: ${e.code.name}, description: ${e.description}, details: ${e.details}',
      );
      return null;
    } catch (error) {
      print('Unexpected Google Sign-In error: $error');
      return null;
    }
  }

  // Attempt silent sign-in
  // Future<GoogleSignInAccount?> attemptSilentSignIn() async {
  //  // await _ensureGoogleSignInInitialized();

  //   try {
  //     final result = _googleSignIn.attemptLightweightAuthentication();
  //     if (result is Future<GoogleSignInAccount?>) {
  //       return await result;
  //     } else {
  //       return result as GoogleSignInAccount?;
  //     }
  //   } catch (error) {
  //     print('Silent sign-in failed: $error');
  //     return null;
  //   }
  // }

  // Sign out
  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      // _currentUser = null;
      // Clear profile from local DB
         print('User signed out successfully.');
    await _profileRepository.deleteProfile();
    
    print('User signed out and profile deleted from local DB.');

   
    } catch (error) {
      print('Sign out failed: $error');
    }
  }

  // GoogleSignInAccount? get currentUser => _currentUser;
  // bool get isSignedIn => _currentUser != null;
}
