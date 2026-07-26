enum Person {
  student,
  parent,
  teacher,
  admin,
  unknown,
}

const Person momen = Person.admin;
const Person adel = Person.teacher;
const Person osama = Person.admin;
const bool isAdelAdmin = adel == Person.admin ? true : false;

Person convertStringToEnum(String value) {
  if (value == 'st') {
    return Person.student;
  } else if (value == 'pa') {
    return Person.parent;
  } else if (value == 'te') {
    return Person.teacher;
  } else if (value == 'ad') {
    return Person.admin;
  } else {
    return Person.unknown;
  }
}

String convertEnumToString(Person value) {
  switch (value) {
    case Person.student:
      return 'st';
    case Person.parent:
      return 'pa';
    case Person.teacher:
      return 'te';
    case Person.admin:
      return 'ad';
    default:
      return 'unknown';
  }
}

class UserModel {
  static const String collectionName = 'userslist';
  String? userId,
      userName,
      userEmail,
      type, // Type has to be one of these four strings ("st", "pa", "te", "ad")
      parentOrChildName,
      password,
      userImageUrl,
      subject,
      childId; // If type is 'pa'.
  Person? type1;
  int? level, age;
  List? mathGrades, scienceGrades, englishGrades, arabicGrades, weekAtt;

  UserModel(
      {this.userId,
      this.userName,
      this.userEmail,
      this.type,
      this.parentOrChildName,
      this.mathGrades,
      this.scienceGrades,
      this.englishGrades,
      this.arabicGrades,
      this.password,
      this.userImageUrl,
      this.subject,
      this.level,
      this.age,
      this.type1,
      this.weekAtt, this.childId});

  UserModel.fromFireStore(Map<String, dynamic> data)
      : this(
            userId: data['userId'],
            userName: data['userName'],
            userEmail: data['userEmail'],
            type: data['type'],
            parentOrChildName: data['parentOrChildName'],
            mathGrades: data['mathGrades'],
            scienceGrades: data['scienceGrades'],
            englishGrades: data['englishGrades'],
            arabicGrades: data['arabicGrades'],
            password: data['password'],
            userImageUrl: data['userImageUrl'],
            subject: data['subject'],
            level: data['level'],
            age: data['age'],
            weekAtt: data['weekAtt'], childId: data['childId']);

  Map<String, dynamic> toFireStore() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'type': type,
      'parentOrChildName': parentOrChildName,
      'mathGrades': mathGrades,
      'scienceGrades': scienceGrades,
      'englishGrades': englishGrades,
      'arabicGrades': arabicGrades,
      'password': password,
      'userImageUrl': userImageUrl,
      'subject': subject,
      'level': level,
      'age': age,
      'weekAtt': weekAtt,
      'childId': childId
    };
  }
}
