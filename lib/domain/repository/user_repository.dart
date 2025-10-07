import 'package:ic_batch3_flutter_classes/domain/models/user_profile.dart';

abstract class UserRepository {
  Future<UserProfile> fetchProfile({required String token});
}
