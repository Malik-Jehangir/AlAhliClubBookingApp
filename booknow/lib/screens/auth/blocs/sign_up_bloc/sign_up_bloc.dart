import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

final UserRepository _userRepository;

  SignUpBloc(this._userRepository) : super(SignUpInitial()) { //here SignUpBloc is a constructor where we pass a parameter as _userRepository
    
    
    on<SignUpRequired>((event, emit) async{
      emit(SignUpProcess());
        try{
          //Sign up and set user data to firebase's firestore
          MyUser myUser = await _userRepository.signUp(event.user, event.password);
          await _userRepository.setUserData(myUser); //updating database, myUser because we dont want to use same userId from event.user in our backend
          emit(SignUpSuccess());
        } catch (e){
          emit(SignUpFailure());
        }   

    });
  }
}
