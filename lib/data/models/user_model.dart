class UserModel{
  late String id;
  late String email;
  late List<int> counters;


  UserModel({
    required this.id,
    required this.email,
    required this.counters,
  });


  UserModel.fromJsonMap({required Map<String, dynamic> map,required String uId}){
    id = uId;
    email = map["email"];
  }

  Map<String,dynamic> toMap(){
    return {
      "uId": id,
      "email": email,
    };
  }

  Map<String,int> counterMap(){
    return {
      'counter_1': counters[0],
      'counter_2': counters[1],
      'counter_3': counters[2],
    };
  }
}