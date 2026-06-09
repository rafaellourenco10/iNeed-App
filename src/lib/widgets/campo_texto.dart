// ============================================
// campo_texto.dart — Input field customizado do iNeed
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampoTexto extends StatelessWidget {
  final String? rotulo;
  final String? dica;
  final IconData? iconePrefixo;
  final Widget? sufixo;
  final bool obscurecerTexto;
  final TextEditingController? controlador;
  final TextInputType? tipoTeclado;
  final List<TextInputFormatter>? formatadores;
  final String? Function(String?)? validador;
  final int maxLinhas;
  final void Function(String)? aoMudar;

  const CampoTexto({
    super.key,
    this.rotulo,
    this.dica,
    this.iconePrefixo,
    this.sufixo,
    this.obscurecerTexto = false,
    this.controlador,
    this.tipoTeclado,
    this.formatadores,
    this.validador,
    this.maxLinhas = 1,
    this.aoMudar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (rotulo != null) ...[
          Text(
            rotulo!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controlador,
          obscureText: obscurecerTexto,
          keyboardType: tipoTeclado,
          inputFormatters: formatadores,
          validator: validador,
          maxLines: maxLinhas,
          onChanged: aoMudar,
          decoration: InputDecoration(
            hintText: dica,
            prefixIcon: iconePrefixo != null
                ? Icon(iconePrefixo, size: 22, color: Theme.of(context).colorScheme.outline)
                : null,
            suffixIcon: sufixo,
          ),
        ),
      ],
    );
  }
}
