import 'services.dart';

class Global {
  static final Map models = {
    Routine: (data) => Routine.fromData(data),
    Exercise: (data) => Exercise.fromData(data),
    User: (data) => User.fromData(data),
  };

  static final Collection<Routine> routinesRef =
      Collection<Routine>(path: 'routines');
  static final UserData<User> userData = UserData<User>(collection: 'users');
}
