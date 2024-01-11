
# Sisukord

- [Sisukord](#sisukord)
- [1. Shelly seadmete funktsioonid](#1-shelly-seadmete-funktsioonid)
  - [1.1 Seadmete graafikute funktsioonid](#11-seadmete-graafikute-funktsioonid)
    - [1.1.1 Generatsioon 1 seadmed](#111-generatsioon-1-seadmed)
      - [1.1.1.1 graafikGen1Lugemine](#1111-graafikgen1lugemine)
      - [1.1.1.2 graafikGen1Saatmine](#1112-graafikgen1saatmine)
      - [1.1.1.3 graafikGen1Filtreerimine](#1113-graafikgen1filtreerimine)
      - [1.1.1.4 graafikGen1ToGraafikGen2](#1114-graafikgen1tograafikgen2)
      - [1.1.1.5 graafikGen1Koostamine](#1115-graafikgen1koostamine)
    - [1.1.2 Generatsioon 2 seadmed](#112-generatsioon-2-seadmed)
      - [1.1.2.1 graafikGen2Lugemine](#1121-graafikgen2lugemine)
      - [1.1.2.2 graafikGen2ToGraafikGen1](#1122-graafikgen2tograafikgen1)
      - [1.1.2.3 graafikGen2SaatmineGraafikuga](#1123-graafikgen2saatminegraafikuga)
      - [1.1.2.4 graafikGen2DeleteAll](#1124-graafikgen2deleteall)
  - [1.2 Seadmete muud funktsioonid](#12-seadmete-muud-funktsioonid)
    - [1.2.1 lulitamine](#121-lulitamine)
    - [1.2.2 graafikGen1ToLulitusMap](#122-graafikgen1tolulitusmap)
- [Lisa funktsioonid](#lisa-funktsioonid)
  - [Lisa 1, mällu salvestamine](#lisa-1-mällu-salvestamine)
  - [Lisa 2](#lisa-2)
  - [Lisa 3](#lisa-3)
  - [Lisa 4](#lisa-4)
  - [Lisa 5 conf fail to map](#lisa-5-conf-fail-to-map)
- [2. Muutujate kujud](#2-muutujate-kujud)
  - [2.1 lulitus](#21-lulitus)
  - [2.2 seadmeteMap](#22-seadmetemap)
- [3. Shelly graafikute kujud](#3-shelly-graafikute-kujud)
  - [3.1 Generatsioon 1](#31-generatsioon-1)
  - [3.2 Generatsioon 2](#32-generatsioon-2)
- [4. Graafiku koostamis funktsioonid](#4-graafiku-koostamis-funktsioonid)
  - [4.1 keskmisehinna alusel graafiku loomine](#41-keskmisehinna-alusel-graafiku-loomine)
    - [4.1.1 keskmisehinna arvutus](#411-keskmisehinna-arvutus)
  - [4.2 Hinnapiiri alusel graafiku loomine](#42-hinnapiiri-alusel-graafiku-loomine)
- [5. Eleringi API-ga seotud funktioonid](#5-eleringi-api-ga-seotud-funktioonid)
  - [5.1 Eesti hetke elektrihinna saamine](#51-eesti-hetke-elektrihinna-saamine)
  - [5.2 Hinnapiiri alusel graafiku loomine](#52-hinnapiiri-alusel-graafiku-loomine)

# 1. Shelly seadmete funktsioonid

## 1.1 Seadmete graafikute funktsioonid

### 1.1.1 Generatsioon 1 seadmed

---

#### 1.1.1.1 graafikGen1Lugemine

File: [graafikGen1.dart](funktsioonid/graafikGen1.dart)

```dart
graafikGen1Lugemine(String id) async {
return List<dynamic>;
//Näiteks: [0055-3-on, 0050-012-on, 2100-01-on]
}
```

Loeb shelly api-st generatsioon 1 seadme graafiku.

id = seadme id, mille graafikut soovitakse saada.  

---

#### 1.1.1.2 graafikGen1Saatmine

File: [graafikGen1.dart](funktsioonid/graafikGen1.dart)

```dart
graafikGen1Saatmine(List<dynamic> graafik, String id) async {
}
```

Saadab graafiku generatsioon 1 seadmele

graafik = generatsioon 1 kujul graafik

id = seade, millele saadatakse graafik

---

#### 1.1.1.3 graafikGen1Filtreerimine

```dart
graafikGen1Filtreerimine(List<dynamic> graafik, List<int> paevad){
return List<dynamic>;
//Näiteks: [0000-3-off, 0800-3-on, 1100-3-off]
}
```

Võtab generatsiooni 1 graafikust, ainult soovitud päevade graafikud.

graafik = olemas olev generatsioon 1 kujul graafik.
paevad = paevad mille graafikuid soovitakse.

---

#### 1.1.1.4 graafikGen1ToGraafikGen2

```dart
graafikGen1ToGraafikGen2(List<dynamic> graafik) {
return List<dynamic>;
//Näiteks: [{"enable":true,"timespec":"0 0 0 * * WED","calls":[{"method":"Switch.Set","params":{"id":0,"on":true}}]}, {"enable":true,"timespec":"0 0 7 * * WED","calls":[{"method":"Switch.Set","params":{"id":0,"on":false}}]}, {"enable":true,"timespec":"0 0 14 * * WED","calls":[{"method":"Switch.Set","params":{"id":0,"on":true}}]}]
}
```

Teeb generatsioon 1 graafiku generatsioon 2 graafiku saatmise kujule.

graafik = olemas olev generatsioon 1 kujul graafik.

---

#### 1.1.1.5 graafikGen1Koostamine

```dart
graafikGen1Koostamine(Map<int, dynamic> lulitus, int paev) {
  return List<String>;
  //Näiteks: [0000-3-off, 0800-3-on, 1100-3-off]
}
```

Koostab lulitus map-ist graafiku generatsioon 1 kujul.

lulitus = lulitus map, mis tuleb lulitusgraafiku koostamisest.

paev = nadalapaev, mille graafikut koostatakse.

---

### 1.1.2 Generatsioon 2 seadmed

#### 1.1.2.1 graafikGen2Lugemine

```dart
graafikGen2Lugemine(String id) asnyc{
return List<dynamic>;
//Näiteks: [{id: 1, enable: true, timespec: 0 0 0 * * WED, calls: [{method: Switch.Set, params: {id: 0, on: true}}]}, {id: 2, enable: true, timespec: 0 0 7 * * WED, calls: [{method: Switch.Set, params: {id: 0, on: false}}]}, {id: 3, enable: true, timespec: 0 0 14 * * WED, calls: [{method: Switch.Set, params: {id: 0, on: true}}]}, {id: 4, enable: true, timespec: 0 0 16 * * WED, calls: [{method: Switch.Set, params: {id: 0, on: false}}]}, {id: 5, enable: true, timespec: 0 0 21 * * WED, calls: [{method: Switch.Set, params: {id: 0, on: true}}]}]
}
```

Loeb shelly api-st generatsioon 2 seadme graafiku

id = seadme, mille graafikut soovitakse saada id.

---

#### 1.1.2.2 graafikGen2ToGraafikGen1

```dart
graafikGen2ToGraafikGen1(List<dynamic> graafik){
return List<dynamic>;
//Näiteks: [0000-3-off, 0800-3-on, 1100-3-off]
}
```

Teeb generatsioon 2 graafiku generatsioon 1 graafiku kujule

graafik = olemas olev generatisoon 2 kujul graafik.

---

#### 1.1.2.3 graafikGen2SaatmineGraafikuga

```dart
graafikGen2SaatmineGraafikuga(List<dynamic> graafikGen2, String key) async {
}
```

Saadab generatsioon 2 seadmele graafiku.
Graafik peab olema kujul mis tuleb graafikGen1ToGraafikGen2 funktsioonist.

graafik = graafik kujul, mis tuleb graafikGen1ToGraafikGen2 funktsioonist.

---

#### 1.1.2.4 graafikGen2DeleteAll

```dart
graafikGen2DeleteAll(String id) async {
}
```

Kustutab generatsioon 2 seadme kogu graafiku
id = seadme id

---

## 1.2 Seadmete muud funktsioonid

### 1.2.1 lulitamine

```dart
lulitamine(String seade) async{
}
```

Seade lulitatakse sisse voi valja

Seade = seadme id, mida lulitatakse

---

### 1.2.2 graafikGen1ToLulitusMap

```dart
graafikGen1ToLulitusMap(Map<int, dynamic> lulitus, List<dynamic> graafik) {
  return Map<int, dynamic>;
  //Näiteks: {0: [00.00, 44.85, false], 1: [01.00, 64.69, false], 2: [02.00, 55.95, false], 3: [03.00, 57.31, false], 4: [04.00, 46.48, false], 5: [05.00, 69.42, false], 6: [06.00, 97.65, true], 7: [07.00, 139.56, false], 8: [08.00, 159.37, false], 9: [09.00, 162.35, false], 10: [10.00, 143.5, false], 11: [11.00, 117.0, false], 12: [12.00, 105.44, false], 13: [13.00, 103.47, false], 14: [14.00, 94.79, false], 15: [15.00, 109.49, false], 16: [16.00, 116.75, false], 17: [17.00, 138.96, false], 18: [18.00, 171.72, false], 19: [19.00, 203.87, false], 20: [20.00, 200.04, false], 21: [21.00, 110.04, false], 22: [22.00, 120.01, false], 23: [23.00, 35.08, true]}
}
```

Generatsioon 1 graafik muudab lulitus map-i lülitused true-ks või false-ks.

lulitus = olemasolev lulitus map.

graafik = generatsioon 1 kujul graafik.

---

# Lisa funktsioonid

## Lisa 1, mällu salvestamine

```dart
salvestaSeadistus(
    String parameetriNim, double parameeter, Map<String,bool> valitudSeadmed) async {
}

```

Salvestab mällu iga valitud seadme kohta parameetri

---

## Lisa 2

```dart
int getCurrentDayOfWeek() {
return int;
}
```

Annab tänase nädalapäeva numbri.

## Lisa 3

```dart
SalvestaUusGrupp(String gruppiNimi, Map<String, bool> valitudSeadmed) async {
}
```

Salvestab uue gruppi seadme mällu, et gruppimappi alglaadimisel väärtustada, samas kirjutab üle ka kõiki seadmeid hõlmava gruppi seadmetemapi kõigi keydega

## Lisa 4

```dart
saaGrupiOlek(String gruppiNimi) {
  return olek;
}

```

Määrab gruppile oleku, loogikaga:
 kui vähemalt 1 seade "Offline" siis on grupp "Offline"
 kui kõik seadmed on "on" siis on grupp "on"
 kui kumbki tingimus ei ole täidetud on grupp "off"

## Lisa 5 conf fail to map

```dart
Future<Map<String, Map<String, dynamic>>> saaShellyConf() async {
  return confShelly;
}
```

saadab tagsi conf failist alusel kooostatud conf mapi

# 2. Muutujate kujud

## 2.1 lulitus

```dart
Map<int, dynamic> lulitus;

lulitus = int: [String, double, bool];

lulitus = koht: [kell, elektrihind, on/off];
```

Näiteks:

```dart
lulitus = {0: [00.00, 44.85, false], 1: [01.00, 64.69, false], 2: [02.00, 55.95, false], 3: [03.00, 57.31, false], 4: [04.00, 46.48, false], 5: [05.00, 69.42, false], 6: [06.00, 97.65, true], 7: [07.00, 139.56, false], 8: [08.00, 159.37, false], 9: [09.00, 162.35, false], 10: [10.00, 143.5, false], 11: [11.00, 117.0, false], 12: [12.00, 105.44, false], 13: [13.00, 103.47, false], 14: [14.00, 94.79, false], 15: [15.00, 109.49, false], 16: [16.00, 116.75, false], 17: [17.00, 138.96, false], 18: [18.00, 171.72, false], 19: [19.00, 203.87, false], 20: [20.00, 200.04, false], 21: [21.00, 110.04, false], 22: [22.00, 120.01, false], 23: [23.00, 35.08, true]}
```

---

## 2.2 seadmeteMap

```dart
Map<String, dynamic> seadmeteMap;

seadmeteMap = String : {String: String, String: String, String: int, String: String, String: String,String: String, String: String};
//Seadme_generatsioon on ainuke int
seadmeteMap = Seadme_ID : {Seadme_nimi, Seadme_pistik, Seadme_generatsioon, api_url, Seadme_pilt, Cloud_key, Seadme_olek, Graafik}
```

Näiteks:

```dart
1234abc: {Seadme_nimi: Shelly Pro PM, Seadme_pistik: Shelly Pro PM, Seadme_generatsioon: 2, api_url: api, Seadme_pilt: assets/boiler1.jpg, Cloud_key: 422aaasfww, Seadme_olek: on, Graafik: jah}, 1234bvc: {Seadme_nimi: Shelly Plug S, Seadme_pistik: Shelly Plug S, Seadme_generatsioon: 1, api_url: api, Seadme_pilt: assets/boiler1.jpg, Cloud_key: 2335djgs, Seadme_olek: on, Graafik: jah}
```

# 3. Shelly graafikute kujud

## 3.1 Generatsioon 1

Generatsioon 1 graafik edastatakse Shelly poolt järgneval kujul:

>0800-3-on

Graafikut tõlgendatakse järgnevalt:

>kell-nädalapäev-lülitus

ehk antud juhul "0800" on kell, "3" on nädalapäev ja "on" on lülitus. Teisisõnu neljapäeval kell 8:00 lülitatakse seade sisse.

## 3.2 Generatsioon 2

Generatsioon 2 graafik edastatakse Shelly poolt järgneval kujul:

>id: 1, enable: true, timespec: 0 0 21 ** WED, calls: [{method: Switch.Set, params: {id: 0, on: true}}]

Graafikut tõlgendatakse järgnevalt:

>timespec - lülituse hetk
on - lülitus

ehk antud juhul "0 0 21" on kell, "WED" on nädalapäev ja "true" on sisselülitus. Teisisõnu kolmapäeval kell 21:00 lülitatakse seade sisse.

# 4. Graafiku koostamis funktsioonid

## 4.1 keskmisehinna alusel graafiku loomine

### 4.1.1 keskmisehinna arvutus

```dart

keskmineHindArvutaus(Map<int, dynamic> lulitus) {
 return double;
}

```

saadab tagasi keskmise hinna

---

## 4.2 Hinnapiiri alusel graafiku loomine

```dart

f

```

xxxx

---

# 5. Eleringi API-ga seotud funktioonid

## 5.1 Eesti hetke elektrihinna saamine

File: [hetke_hind.dart](funktsioonid/hetke_hind.dart)

```dart


Future<double> getCurrentPrice() async {
  return CurrentPrice;
}

```

Saadab tagasi Eesti hetke elektrihinna ilma käibemaksuta.
Ühikuks on €/MWh.

---

## 5.2 Hinnapiiri alusel graafiku loomine

```dart

f

```

xxxx

---
