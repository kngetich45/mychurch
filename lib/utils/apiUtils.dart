import 'package:bevicschurch/features/auth/authLocalDataSource.dart';
import 'package:bevicschurch/features/auth/authRemoteDataSource.dart';

class ApiUtils {
  static Future<Map<String, String>> getHeaders() async {
    String jwtToken = AuthLocalDataSource.getJwtToken();

    if (jwtToken.isEmpty) {
      try {
        jwtToken = await AuthRemoteDataSource().getJWTTokenOfUser(
            firebaseId: AuthLocalDataSource.getUserFirebaseId(),
            type: AuthLocalDataSource.getAuthType());
        await AuthLocalDataSource.setJwtToken(jwtToken);
      } catch (e) {}
    }

    return {"Authorization": 'Bearer $jwtToken'};
  }


    static Future<String> getHeadersDowload() async {
    String jwtToken = AuthLocalDataSource.getJwtToken();

    if (jwtToken.isEmpty) {
      try {
        jwtToken = await AuthRemoteDataSource().getJWTTokenOfUser(
            firebaseId: AuthLocalDataSource.getUserFirebaseId(),
            type: AuthLocalDataSource.getAuthType());
        await AuthLocalDataSource.setJwtToken(jwtToken);
      } catch (e) {}
    }

    return  "Bearer $jwtToken";
  }
}
