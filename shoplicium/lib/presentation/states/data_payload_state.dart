class DataPayloadState {}

class InitialState extends DataPayloadState {}

class RequestingState extends DataPayloadState {}

class SuccessState extends DataPayloadState {}

class ErrorState extends DataPayloadState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}