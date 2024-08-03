import 'package:afrosine/core/services/injection_container.dart';
import 'package:afrosine/src/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardUtils {
  const DashboardUtils._();

  // Each time our user data changes, the stream will be alerted by FirebaseFirestore
  // and the user data will be updated in the app.

  // We don't need to do this in layers like clean architecture because firebase has done that on their end
  // We just need to listen to the stream and update the user data in the app.

  static Stream<LocalUserModel> get userDataStream => sl<FirebaseFirestore>()
      .collection('users')
      .doc(sl<FirebaseAuth>().currentUser!.uid)
      .snapshots()
      .map((event) => LocalUserModel.fromMap(event.data()!));
}
