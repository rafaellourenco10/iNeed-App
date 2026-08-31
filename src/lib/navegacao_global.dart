// ============================================
// navegacao_global.dart — Navegação fora da árvore de widgets
// ============================================
// Permite navegar (ex: deslogar por sessão expirada) a partir de
// serviços que não têm BuildContext, como AuthServico.

import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> chaveNavegadorGlobal =
    GlobalKey<NavigatorState>();
