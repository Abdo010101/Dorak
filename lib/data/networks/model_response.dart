abstract class Result<T> {}

class Success<T> extends Result<T> {
  final T data;

  Success(this.data);
}

class Error<T> extends Result<T> {
  final String? errorMessage;

  Error({this.errorMessage});

  @override
  String toString() {
    return 'Error{errorMessage: $errorMessage}';
  }
}
