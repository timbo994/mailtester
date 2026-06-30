import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/connection_status.dart';

final smtpStatusProvider =
    StateProvider<ConnectionStatus>((ref) => ConnectionStatus.idle);
