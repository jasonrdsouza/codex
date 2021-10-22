import 'dart:io';

import 'package:yaml/yaml.dart';

class Config {
  Map entries;

  Config(String filename)
      : entries = loadYaml(File(filename).readAsStringSync());

  Config.standard() : this('config.yaml');

  int port() => entries['port'];
  String dbPath() => entries['db'];
  String scribeUrl() => entries['scribe'];
  String staticDir() => entries['static_dir'];
}
