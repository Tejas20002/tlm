import 'application.dart';

class SharedPreferencesKeys {
  static const String prefUserToken = 'token';
  static const String prefUserId = 'id';
  static const String prefUserName = 'name';
  static const String prefUserEmail = 'email';
  static const String prefUserRole = 'role';
  static const String prefUserEmpCode = 'empCode';
  static const String prefUserStatus = 'status';
  static const String prefUserLoggedIn = 'loggedIn';
}

void setUserToken(String? value) {
  Application.sp?.putString(SharedPreferencesKeys.prefUserToken, value ?? "");
}

String? getUserToken() {
  return Application.sp?.getString(SharedPreferencesKeys.prefUserToken);
}

void setUserId(int? value) {
  Application.sp?.putInt(SharedPreferencesKeys.prefUserId, value ?? 0);
}

int? getUserId() {
  return Application.sp?.getInt(SharedPreferencesKeys.prefUserId);
}

void setUserName(String? value) {
  Application.sp?.putString(SharedPreferencesKeys.prefUserName, value ?? "");
}

String? getUserName() {
  return Application.sp?.getString(SharedPreferencesKeys.prefUserName);
}

void setUserEmail(String? value) {
  Application.sp?.putString(SharedPreferencesKeys.prefUserEmail, value ?? "");
}

String? getUserEmail() {
  return Application.sp?.getString(SharedPreferencesKeys.prefUserEmail);
}

void setUserRole(String? value) {
  Application.sp?.putString(SharedPreferencesKeys.prefUserRole, value ?? "");
}

String? getUserRole() {
  return Application.sp?.getString(SharedPreferencesKeys.prefUserRole);
}

void setUserEmpCode(String? value) {
  Application.sp?.putString(SharedPreferencesKeys.prefUserEmpCode, value ?? "");
}

String? getUserEmpCode() {
  return Application.sp?.getString(SharedPreferencesKeys.prefUserEmpCode);
}

void setUserStatus(int? value) {
  Application.sp?.putInt(SharedPreferencesKeys.prefUserStatus, value ?? 0);
}

int? getUserStatus() {
  return Application.sp?.getInt(SharedPreferencesKeys.prefUserStatus);
}
void setLoggedIn(bool value) {
  Application.sp?.putBool(SharedPreferencesKeys.prefUserLoggedIn, value ?? false);
}

bool isLoggedIn() {
  return Application.sp?.getBool(SharedPreferencesKeys.prefUserLoggedIn) ?? false;
}

void clearAllPreferences() {
  Application.sp?.clear();
}

void clearAllLogoutPreferences() {
  Application.sp?.remove(SharedPreferencesKeys.prefUserToken);
  Application.sp?.remove(SharedPreferencesKeys.prefUserId);
  Application.sp?.remove(SharedPreferencesKeys.prefUserName);
  Application.sp?.remove(SharedPreferencesKeys.prefUserEmail);
  Application.sp?.remove(SharedPreferencesKeys.prefUserRole);
  Application.sp?.remove(SharedPreferencesKeys.prefUserEmpCode);
  Application.sp?.remove(SharedPreferencesKeys.prefUserStatus);

  setLoggedIn(false);
}
