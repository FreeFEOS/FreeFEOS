import '../interface/system_interface.dart';
import 'base.dart';

base mixin BaseEntry implements FreeFEOSInterface {
  @override
  FreeFEOSInterface get interface => SystemBase()();
}
