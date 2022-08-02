class SessionNotFound implements Exception {
String cause;
SessionNotFound(this.cause);
}

class ConnectionError implements Exception {
String cause;
ConnectionError(this.cause);
}

class JsonDecodingError implements Exception {
String cause;
JsonDecodingError(this.cause);
}

class AutenticationFailure implements Exception {
String cause;
AutenticationFailure(this.cause);
}