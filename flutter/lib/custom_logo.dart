import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'consts.dart';
import 'models/platform_model.dart';

/// Logo personalizado (AMP-IT): ruta a imagen elegida en Ajustes.
/// Tiene prioridad sobre los assets incluidos.
String getCustomLogoPath() {
  try {
    return bind.mainGetLocalOption(key: kCommConfKeyCustomLogo);
  } catch (_) {
    return '';
  }
}

Future<void> setCustomLogoPath(String path) async {
  try {
    await bind.mainSetLocalOption(key: kCommConfKeyCustomLogo, value: path);
  } catch (_) {}
}

/// Abre el selector de imagen. Devuelve la ruta elegida o null.
Future<String?> pickCustomLogoImage() async {
  try {
    final res = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    final p = res?.files.single.path;
    if (p == null || p.isEmpty) return null;
    if (!File(p).existsSync()) return null;
    await setCustomLogoPath(p);
    return p;
  } catch (_) {
    return null;
  }
}

/// Widget con el logo personalizado, o null si no hay uno valido.
Widget? buildCustomLogoWidget() {
  try {
    final p = getCustomLogoPath();
    if (p.isEmpty) return null;
    final f = File(p);
    if (!f.existsSync()) return null;
    return Image.file(
      f,
      fit: BoxFit.contain,
      errorBuilder: (ctx, error, stackTrace) => const SizedBox.shrink(),
    );
  } catch (_) {
    return null;
  }
}
