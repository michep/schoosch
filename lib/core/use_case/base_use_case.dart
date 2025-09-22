abstract class BaseUseCase<R, P> {
  Future<R> invoke(P params);
}