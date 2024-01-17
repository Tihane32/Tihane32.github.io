import 'parameters.dart';

extension GenExtension on String {
  int get gen {
    return seadmeteMap[this]["Seadme_generatsioon"];
  }

  String get nimi {
    return seadmeteMap[this]["Seadme_nimi"];
  }

  String get apiURL {
    return seadmeteMap[this]["api_url"];
  }

  String get cat {
    return seadmeteMap[this]["Seadme_cat"];
  }

  String get cloudKey {
    return seadmeteMap[this]["Cloud_key"];
  }

  String get username {
    return seadmeteMap[this]["Username"];
  }

  String get password {
    return seadmeteMap[this]["Password"];
  }

  String get olek {
    return seadmeteMap[this]["Seadme_olek"];
  }
}
