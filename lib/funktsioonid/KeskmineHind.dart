
import 'package:testuus4/funktsioonid/Elering.dart';

Future getKeskmineHind() async{
  var hinnagraafik = await getElering('täna');
  double keskmineHind = 0;
  for(var i=0;i<hinnagraafik.length;i++){
    
    keskmineHind = keskmineHind + hinnagraafik[i]['price'];
  }
  keskmineHind = keskmineHind/24;
} 