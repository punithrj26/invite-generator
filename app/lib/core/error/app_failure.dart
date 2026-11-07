/// Every error a screen can see. Repositories throw these (D8); `message` is always safe to show.
sealed class AppFailure implements Exception {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure()
    : super("Can't reach the server. Check your connection and try again.");
}

final class UnauthenticatedFailure extends AppFailure {
  const UnauthenticatedFailure([super.message = 'Please sign in again.']);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, [this.fieldErrors = const {}]);

  /// API field path → message, e.g. `'email' → 'email must be an email'`.
  final Map<String, String> fieldErrors;
}

final class ForbiddenFailure extends AppFailure {
  const ForbiddenFailure([super.message = "You don't have access to this."]);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure() : super('This item no longer exists.');
}

final class ConflictFailure extends AppFailure {
  const ConflictFailure([super.message = 'This already exists.']);
}

final class RateLimitedFailure extends AppFailure {
  const RateLimitedFailure()
    : super('Too many attempts. Please wait a minute and try again.');
}

final class ServerFailure extends AppFailure {
  const ServerFailure({this.requestId})
    : super('Something went wrong on our side. Please try again.');

  /// Quote this to support; it matches the API log line.
  final String? requestId;
}
