class UserModel{
  late String id;
  late String email;
  late Map<String, int> counters;


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

  // Map<String,int> counterMap(){
  //   return {
  //     cnt1_key: counters[0],
  //     cnt2_key: counters[1],
  //     cnt3_key: counters[2],
  //     cnt4_key: counters[3],
  //     cnt5_key: counters[4],
  //     cnt6_key: counters[5],
  //   };
  // }
}