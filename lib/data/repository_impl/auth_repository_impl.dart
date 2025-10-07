import 'package:ic_batch3_flutter_classes/data/remote_datasource/auth_remote_data_source.dart';
import 'package:ic_batch3_flutter_classes/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.remoteDataSource});

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<void> requestLoginOtp({required String email}) {
    return remoteDataSource.requestLoginOtp(email: email);
  }

  @override
  Future<String> verifyLogin({required String email, required String otp}) {
    return remoteDataSource.verifyLogin(email: email, otp: otp);
  }
}
