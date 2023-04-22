import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorsfuse/models/audience.dart';
import 'package:sorsfuse/global/global.dart' as GLOBAL;

class AudienceRepository{
  Future<Map<String,dynamic>> save(Audience audience) async {
    var tmp_id="";
    Map<String,dynamic> _audience = audience.toMap();
    if (audience.audience_id != '') {
      print(audience.toMap());
      _audience['updated_at'] = DateTime.now().toUtc();
      _audience['updated_by'] = FirebaseAuth.instance.currentUser!.uid.toString();
      _audience['updated_by_name'] = FirebaseAuth.instance.currentUser!.displayName.toString();
      await FirebaseFirestore.instance.collection(GLOBAL.audienceCollection).doc(audience.audience_id).update(_audience);
      return {"status":"success","id":audience.audience_id};
    } else {
      try {
        _audience['created_at'] = DateTime.now().toUtc();
        _audience['created_by'] = FirebaseAuth.instance.currentUser!.uid.toString();
        _audience['created_by_name'] = FirebaseAuth.instance.currentUser!.displayName.toString();
        await FirebaseFirestore.instance.collection(GLOBAL.audienceCollection)
            .add(_audience)
            .then((docRef) {
          FirebaseFirestore.instance.collection(GLOBAL.audienceCollection).doc(docRef.id).update(
              {"audience_id": docRef.id});
          tmp_id = docRef.id;
        }).catchError((e) {
          print(e);
          return {"status": "failure", "message": e.toString()};
        });
        return {"status": "success", "id": tmp_id.toString()};
      } catch(e){
        return {"status":"failure","message":e.toString()+"Nothing to change"};
      }
    }

  }

  Future<bool> delete(audienceId) async {
    await FirebaseFirestore.instance.collection(GLOBAL.audienceCollection).doc(audienceId).delete().catchError((e){
      return false;
    });
    return true;
  }
}