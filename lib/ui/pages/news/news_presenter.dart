abstract class NewsPresenter {
  Stream<bool> get isLoadingStream;

  Future<void> loadData();
}
