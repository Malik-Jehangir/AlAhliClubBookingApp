import 'package:bloc/bloc.dart';
import 'package:booknow/app.dart';
import 'package:booknow/simple_bloc_observer,dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_repository/user_repository.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //to make sure everything is initialized
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);  
  Bloc.observer=SimpleBlocObserver();

  runApp( MyApp(FirebaseUserRepo())); // we cannot put UserRepository() here directly because it is an abstract class and abstract classes cannot be instantiated, but instead used FirebaseUserRepos which actually implements UserRepository
}
