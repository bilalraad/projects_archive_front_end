import 'package:projects_archiving/utils/enums.dart';

class Strings {
  static const addProject = 'إضافة مشروع';
  static const projectName = 'اسم المشروع';
  static const graduationYear = 'سنة التخرج';
  static const studentName = 'اسم الطالب';
  static const supervisorName = 'اسم المشرف';
  static const level = 'المستوى الجامعي';
  static const keywords = 'الكلمات الدالة';
  static const studentPhoneNumber = 'رقم هاتف الطالب';
  static const pdf = 'PDF';
  static const doc = 'DOC';
  static const selectYear = "اختر السنة";
  static const abstract = 'نبذة مختصرة';
  static const optionalWithBrackets = ' ( اختياري ) ';

  static String count(String? count) {
    return "العدد: ${count ?? 0}";
  }

  static String translateLevel(Level? level) {
    switch (level) {
      case Level.bachelor:
        return 'بكالريوس';
      case Level.master:
        return 'الماستر';
      case Level.phD:
        return 'الدكتوراة';
      default:
        return 'بكالريوس';
    }
  }
}
