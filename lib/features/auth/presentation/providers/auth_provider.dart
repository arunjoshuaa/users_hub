import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:users_hub/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:users_hub/features/auth/domain/repositories/auth_repository.dart';
import 'package:users_hub/features/profile/presentation/providers/profile_providers.dart';

final authRepositoryProvider=Provider<AuthRepository>((ref){
    final googleSignIn = GoogleSignIn.instance;
     final profileRepository = ref.read(profileRepositoryProvider);
   // Initialize each time app starts
  googleSignIn.initialize(
    serverClientId: '1014340416116-o2bfs3b89quce5a4cuflgqhce920j3j5.apps.googleusercontent.com',
  );
  return AuthRepositoryImpl(FirebaseAuth.instance, googleSignIn,profileRepository,);
});

// final authStateProvider=StreamProvider<User?>((ref){
//   final authRepository=ref.watch(authRepositoryProvider);
//   return authRepository.authStateChanges();
// });

final signInWithGoogleProvider=FutureProvider<User?>((ref)async{
  final authRepository=ref.watch(authRepositoryProvider);
  return await authRepository.signInWithGoogle();
});


final signOutProvider = FutureProvider<void>((ref) async {
  final authRepository = ref.watch(authRepositoryProvider);
  await authRepository.signOut();
});