class MyUserEntity { //model
  String userId;
  String email;
  String name;
  bool hasActiveCart;


  MyUserEntity({//constructor
    required this.userId,
    required this.email,    
    required this.name,
    required this.hasActiveCart,
  });

//we break classes down because db doesnt understand objects directly, hence we break and transform accordingly

Map<String, Object?> toDocument(){ //toDocument toJson upto u, remember map transitioning we talked about, this is that
  return {
    'userId':userId,
    'email':email,
    'name': name,
    'hasActiveCart' : hasActiveCart,
  };
}

static MyUserEntity fromDocument(Map<String, dynamic> doc){ //toDocument toJson upto u, remember map transitioning we talked about, this is that
  return MyUserEntity(
    userId: doc['userId'],
    email: doc['email'],
    name: doc['name'],
    hasActiveCart : doc['hasActiveCart'],
  );
}
}