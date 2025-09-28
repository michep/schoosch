final class ChangeCompletionConfirmStatusParams {
  ChangeCompletionConfirmStatusParams({
    required this.completionId,
    required this.personId,
    required this.confirm,
  });

  final String completionId;
  final String personId;
  final bool confirm;
}