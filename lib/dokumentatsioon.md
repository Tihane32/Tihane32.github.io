
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
- [Lisa funktsioonid](#lisa-funktsioonid)
- [2. Muutujate kujud](#2-muutujate-kujud)
  - [2.1 lulitus](#21-lulitus)
  - [2.2 seadmeteMap](#22-seadmetemap)

# 1. Shelly seadmete funktsioonid

## 1.1 Seadmete graafikute funktsioonid

### 1.1.1 Generatsioon 1 seadmed

---

#### 1.1.1.1 graafikGen1Lugemine

```dart
graafikGen1Lugemine(String id) async {
return List<dynamic>;
}
```

Loeb shelly api-st generatsioon 1 seadme graafiku.

id = seadme id, mille graafikut soovitakse saada.  

---

#### 1.1.1.2 graafikGen1Saatmine

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
}
```

Teeb generatsioon 1 graafiku generatsioon 2 graafiku saatmise kujule.

graafik = olemas olev generatsioon 1 kujul graafik.

---

#### 1.1.1.5 graafikGen1Koostamine

```dart
graafikGen1Koostamine(Map<int, dynamic> lulitus, int paev) {
  return List<String>;
}
```

Koostab lulitus map-ist graafiku.

lulitus = lulitus map, mis tuleb lulitusgraafiku koostamisest.

paev = nadalapaev, mille graafikut koostatakse.

---

### 1.1.2 Generatsioon 2 seadmed

#### 1.1.2.1 graafikGen2Lugemine

```dart
graafikGen2Lugemine(String id) asnyc{
return List<dynamic>;
}
```

Loeb shelly api-st generatsioon 2 seadme graafiku

id = seadme, mille graafikut soovitakse saada id.

---

#### 1.1.2.2 graafikGen2ToGraafikGen1

```dart
graafikGen2ToGraafikGen1(List<dynamic> graafik){
return List<dynamic>;
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

# Lisa funktsioonid

```dart
int getCurrentDayOfWeek() {
return int;
}
```

Annab tänase nädalapäeva numbri.

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

Map<String, dynamic> seadmeteMap;

seadmeteMap = [String: String, String: String, String: int, String: String, String: String,String: String, String: String];

seadmeteMap =
