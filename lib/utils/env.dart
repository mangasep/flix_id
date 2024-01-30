import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'secret.env')
final class Env {
  @EnviedField(varName: 'ACCESS_TOKEN_TMDB', obfuscate: true)
  static final String tmdbAccessToken = _Env.tmdbAccessToken;
}
