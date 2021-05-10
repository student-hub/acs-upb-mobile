import 'package:acs_upb_mobile/pages/people/model/person.dart';
import 'package:acs_upb_mobile/pages/people/service/person_provider.dart';
import 'package:acs_upb_mobile/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:acs_upb_mobile/generated/l10n.dart';
import 'package:provider/provider.dart';

class InfoProvider{
  Future<List<Person>> fetchPeopleSearched() async {
    try {
      //TODO (GabrielGavriluta) Filter people by text from SearchWidget - using PersonProvider?
      return null;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }
  Future<List<Person>> fetchClassesSearched(String uid) async {
    try {
      //TODO (GabrielGavriluta) Filter people by text from SearchWidget - using ClassProvider?
      return null;
    } catch (e) {
      print(e);
      AppToast.show(S.current.errorSomethingWentWrong);
      return null;
    }
  }
}