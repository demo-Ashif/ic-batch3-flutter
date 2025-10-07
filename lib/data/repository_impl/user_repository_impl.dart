import 'package:ic_batch3_flutter_classes/data/remote_datasource/user_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/domain/models/user_profile.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required this.remoteDataSource});

  final UserRemoteDataSource remoteDataSource;

  @override
  Future<UserProfile> fetchProfile({required String token}) {
    return remoteDataSource.readProfile(token: token);
  }
}
