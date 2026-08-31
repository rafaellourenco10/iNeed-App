// ============================================
// tela_seguranca.dart — Segurança da conta
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../tema/cores.dart';
import '../../widgets/campo_texto.dart';
import '../../widgets/botao_primario.dart';
import '../../servicos/auth_servico.dart';

class TelaSeguranca extends StatelessWidget {
  const TelaSeguranca({super.key});

  Future<void> _confirmarExclusao(BuildContext context) async {
    final resultado = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _DialogoExcluirConta(),
    );

    if (resultado == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresApp.surface,
      appBar: AppBar(
        title: const Text('Segurança'),
        elevation: 0,
        backgroundColor: CoresApp.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zona de perigo',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: CoresApp.error,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CoresApp.error.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CoresApp.error.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Excluir conta',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Remove permanentemente seu cadastro, propostas, avaliações '
                    'e notificações — tanto o que você fez como cliente quanto '
                    'como prestador. Essa ação não pode ser desfeita.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CoresApp.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  BotaoPrimario(
                    texto: 'Excluir minha conta',
                    tipo: TipoBotao.perigo,
                    icone: Icons.delete_outline,
                    aoPresionar: () => _confirmarExclusao(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DialogoExcluirConta extends StatefulWidget {
  const _DialogoExcluirConta();

  @override
  State<_DialogoExcluirConta> createState() => _DialogoExcluirContaState();
}

class _DialogoExcluirContaState extends State<_DialogoExcluirConta> {
  final _senhaCtrl = TextEditingController();
  bool _mostrarSenha = false;
  bool _confirmando = false;
  String? _erro;

  @override
  void dispose() {
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _excluir() async {
    if (_senhaCtrl.text.isEmpty) {
      setState(() => _erro = 'Informe sua senha.');
      return;
    }

    setState(() {
      _confirmando = true;
      _erro = null;
    });

    final auth = Provider.of<AuthServico>(context, listen: false);
    final sucesso = await auth.excluirConta(senha: _senhaCtrl.text);

    if (!mounted) return;

    if (sucesso) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _confirmando = false;
        _erro = auth.erro ?? 'Não foi possível excluir a conta.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Excluir conta?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Essa ação é permanente. Confirme sua senha pra continuar.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: CoresApp.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          CampoTexto(
            dica: 'Sua senha',
            iconePrefixo: Icons.lock_outline,
            controlador: _senhaCtrl,
            obscurecerTexto: !_mostrarSenha,
            sufixo: IconButton(
              onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
              icon: Icon(
                _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                color: CoresApp.outline,
              ),
            ),
          ),
          if (_erro != null) ...[
            const SizedBox(height: 8),
            Text(_erro!, style: TextStyle(color: CoresApp.error, fontSize: 13)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _confirmando
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _confirmando ? null : _excluir,
          child: _confirmando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  'Excluir',
                  style: TextStyle(
                    color: CoresApp.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ],
    );
  }
}
