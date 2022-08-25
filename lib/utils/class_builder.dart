import '../screens/screens2/patients.dart';
import '../screens/screens2/profile/profile.dart';
import '../screens/screens2/settings_page.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors =
    <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}

class ClassBuilder {
  static void registerClasses() {
    register<Profile>(() => Profile());
    register<CalendarPage>(() => CalendarPage());
    register<SettingsPage>(() => SettingsPage());
  }

  static dynamic fromString(String type) {
    if (_constructors[type] != null) return _constructors[type]!();
  }
}
