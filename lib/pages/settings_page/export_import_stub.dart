// export_import_stub.dart

export 'export_import_web.dart' 
  if (dart.library.html) 'export_import_web.dart'
  if (dart.library.io) 'export_import_mobile.dart';
