import 'package:user_repository/src/entities/entities.dart';

export 'user.dart';


class MyUser { //model
  String userId;
  String email;
  String name;
  bool hasActiveCart;


  MyUser({//constructor
    required this.userId,
    required this.email,    
    required this.name,
    required this.hasActiveCart,
  });


  static final empty = MyUser(//used in the UI
    userId: '', 
    email: '', 
    name: '',
    hasActiveCart: false,
    );


    MyUserEntity toEntity() { //used for transforming db json to user and user to db json, basically takes object and transforms to entity object
      return MyUserEntity(
          userId: userId, 
          email: email, 
          name: name,
          hasActiveCart: hasActiveCart,
      );
    }

  
      static MyUser fromEntity(MyUserEntity entity) { //basically transforms to entity object i.e. json map to object which will be used within our app
      return MyUser(
          userId: entity.userId, 
          email: entity.email, 
          name: entity.name,
          hasActiveCart: entity.hasActiveCart,
      );
    }

    @override
  String toString() {
    return 'MyUser: $userId, $email, $name, $hasActiveCart';
  }
}

