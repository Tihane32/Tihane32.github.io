
# Sisukord

- [Sisukord](#sisukord)
- [1. Shelly seadmete funktsioonid](#1-shelly-seadmete-funktsioonid)
  - [1.1 Seadmete graafikute funktsioonid](#11-seadmete-graafikute-funktsioonid)
    - [1.1.1 Generatsioon 1 seadmed](#111-generatsioon-1-seadmed)
      - [1.1.1.1 graafikGen1Lugemine](#1111-graafikgen1lugemine)
      - [1.1.1.2 graafikGen1Saatmine](#1112-graafikgen1saatmine)
      - [1.1.1.3 graafikGen1Filtreerimine](#1113-graafikgen1filtreerimine)
      - [1.1.1.4 graafikGen1ToGraafikGen2](#1114-graafikgen1tograafikgen2)
    - [1.1.2 Generatsioon 2 seadmed](#112-generatsioon-2-seadmed)
      - [1.1.2.1 graafikGen2Lugemine](#1121-graafikgen2lugemine)
      - [1.1.2.2 graafikGen2ToGraafikGen1](#1122-graafikgen2tograafikgen1)
      - [1.1.2.3 graafikGen2SaatmineGraafikuga](#1123-graafikgen2saatminegraafikuga)
      - [1.1.2.4 graafikGen2DeleteAll](#1124-graafikgen2deleteall)
  - [1.2 Seadmete muud funktsioonid](#12-seadmete-muud-funktsioonid)
    - [1.2.1 lulitamine](#121-lulitamine)
- [LISA FUNKTSIOONID](#lisa-funktsioonid)

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

Loeb shelly api-st generatsioon 1 seadme graafiku

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

# LISA FUNKTSIOONID

```dart
int getCurrentDayOfWeek() {
return int;
}
```

Annab tänase nädalapäeva numbri.
