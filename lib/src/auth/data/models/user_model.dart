import 'dart:convert';

import 'package:afrosine/core/utils/typedefs.dart';
import 'package:afrosine/src/auth/domain/entities/user.dart';

// LocalUserModel is a class that extends the User entity
// It is used to convert the data from the server to an Object that can be used in the app
// It is also used to convert the data from the app to a format that can be sent to the server
// It is a model because it is used to model the data to and from the server

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.userName,
    required super.favoriteRecipeIds,
  });

  const LocalUserModel.empty()
      : super(
          uid: '',
          email: '',
          userName: '',
          favoriteRecipeIds: const [],
        );

  LocalUserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          userName: map['userName'] as String,
          email: map['email'] as String,
          favoriteRecipeIds: List<String>.from(
            map['favoriteRecipeIds'] as List<dynamic>? ?? [],
          ),

          // When we convert something from Json to int/double, it may not work as expected especially if the value is from json.
          // So when working with numbers from database, we don't want to directly convert them to the type
          // We collect numbers as num before then convert to desired type
          // age: (map['age'] as num).toInt(),

          // for lists:

          // When we convert a list from json, we need to cast it to the type we want
          // We can't take it as "List<String>" because json doesn't know the type of the list and will always think it's a list of dynamic
          // So we collect it as "List<dynamic>" and cast it to the type we want

          // Take this as a list of dynamic and cast it to a list of strings
          // sampleStringListData :(map['sampleStringListData'] as List<dynamic>).cast<String>(),
          // Create a list of strings from the list of dynamic
          // sampleStringListData :List<String>.from(map['sampleStringListData'] as List<dynamic>)
        );

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? userName,
    List<String>? favoriteRecipeIds,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      userName: userName ?? this.userName,
      favoriteRecipeIds: favoriteRecipeIds ?? this.favoriteRecipeIds,
    );
  }

  // when we're sending data to the server and we need to convert the data the desired format
  // It is either a map or json depending on what the server accepts

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName,
      'favoriteRecipeIds': favoriteRecipeIds,
    };
  }

  String toJson() => jsonEncode(toMap());
}
