import 'package:microblogging/data/usecases/usecases.dart';
import 'package:microblogging/domain/usecases/usecases.dart';

import '../../factories.dart';

LoadNews makeRemoteLoadNews() {
  return RemoteLoadNews(
    httpClient: makeHttpAdapter(),
    url: makeApiUrl('data.json'),
  );
}
