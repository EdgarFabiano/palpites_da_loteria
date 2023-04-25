
import 'package:flutter/material.dart';
import 'package:palpites_da_loteria/model/model_export.dart';

import '../../model/frequency_draw.dart';

abstract class AbstractSorteioGenerator {

  Future<FrequencyDraw> sortear(Contest contest, int gameSize, [DateTimeRange? dateTimeRange]);

}