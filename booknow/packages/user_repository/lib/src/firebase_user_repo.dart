import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_repo.dart';
import 'package:rxdart/rxdart.dart';


class FirebaseUserRepo implements UserRepository {
final FirebaseAuth _firebaseAuth;
final usersCollection = FirebaseFirestore.instance.collection('users');

FirebaseUserRepo({
  FirebaseAuth? firebaseAuth, //if firebaseAuth of type FirebaseAuth is empty 
}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;



  @override
  Stream<MyUser?> get user {
    return _firebaseAuth.authStateChanges().flatMap((firebaseUser) async* { //star means you're not going to get a return of something but going to yield a stream of something
      if(firebaseUser == null){
        yield MyUser.empty;
      } else {
        yield await usersCollection
        .doc(firebaseUser.uid)
        .get()
        .then((value) => MyUser.fromEntity(MyUserEntity.fromDocument(value.data()!)));
      }
  });
  } //then initialize _firebaseAuth with it otherwise choose an instance

  @override
  Future<void> signIn(String email, String password) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async{
    try{
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(email: myUser.email, password: password);
      myUser.userId = user.user!.uid; //setting my user's id to uid that was given to us by firebase authentication
      return myUser;

    }catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async{
   await _firebaseAuth.signOut();
  }

  @override
  Future<void> setUserData(MyUser myUser) async{
    try{
      await usersCollection
            .doc(myUser.userId) //we filter via ID
            .set(myUser.toEntity().toDocument()); //convert user object to a map

    }catch (e) {
      log(e.toString());
      rethrow;
    }
  }

}