
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _keepConnected = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF050505),
          gradient: RadialGradient(
            center: Alignment(0, -0.1),
            radius: 1.15,
            colors: [
              Color(0xFF260505),
              Color(0xFF0B0808),
              Color(0xFF050505),
            ],
            stops: [0, 0.48, 1],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/fitness_id_logo_noname.png',
                      height: 110,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'FITNESS ID',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'FitnessIdLogo',
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sua jornada fitness começa aqui',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFE57373),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 42),
                    const Text(
                      'SIGN IN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campo de e-mail.
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        hint: 'Seu e-mail',
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo de senha.
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      autofillHints: const [AutofillHints.password],
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration(
                        hint: 'Sua senha',
                        icon: Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Opções de acesso.
                    Row(
                      children: [
                        Checkbox(
                          value: _keepConnected,
                          activeColor: const Color(0xFFE50914),
                          onChanged: (value) {
                            setState(() {
                              _keepConnected = value ?? false;
                            });
                          },
                        ),
                        const Expanded(
                          child: Text(
                            'Manter-me conectado',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _isLoading
                              ? null
                              : _resetPassword,
                          child: const Text(
                            'Esqueceu sua senha?',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Botão de login com indicador de carregamento.
                    SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE50914),
                          foregroundColor: Colors.white,
                          elevation: 10,
                          shadowColor: Colors.redAccent.withValues(
                            alpha: 0.35,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'ENTRAR',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Não tem uma conta?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Cadastro será implementado na próxima etapa.
                    SizedBox(
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {
                          _showMessage(
                            'A tela de cadastro será implementada em seguida.',
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFE50914),
                          side: const BorderSide(
                            color: Color(0xFFE50914),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Separador do login social.
                    const Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.white12),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'CONECTAR-SE COM:',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.white12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Login com Google será conectado em seguida.
                    Center(
                      child: IconButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                _showMessage(
                                  'O login com Google será conectado '
                                  'na próxima etapa.',
                                );
                              },
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF171717),
                          fixedSize: const Size(68, 68),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Text(
                          'G',
                          style: TextStyle(
                            color: Color(0xFF4285F4),
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Estilo compartilhado pelos campos.
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.white54),
      filled: true,
      fillColor: const Color(0xFF191919),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 22,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
    );
  }

  // Login real com Firebase Authentication.
  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Preencha seu e-mail e sua senha.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;

      _showMessage('Login realizado com sucesso!');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      switch (e.code) {
        case 'invalid-email':
          _showMessage('O formato do e-mail é inválido.');
          break;
        case 'user-not-found':
        case 'invalid-credential':
        case 'wrong-password':
          _showMessage('E-mail ou senha incorretos.');
          break;
        case 'user-disabled':
          _showMessage('Esta conta está desativada.');
          break;
        case 'too-many-requests':
          _showMessage(
            'Muitas tentativas. Aguarde um pouco e tente novamente.',
          );
          break;
        case 'network-request-failed':
          _showMessage('Falha de conexão. Verifique sua internet.');
          break;
        default:
          _showMessage('Não foi possível entrar. Tente novamente.');
      }
    } catch (_) {
      if (!mounted) return;

      _showMessage('Ocorreu um erro inesperado durante o login.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Envia o e-mail de recuperação de senha.
  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _showMessage('Informe seu e-mail para recuperar a senha.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      _showMessage(
        'Se a conta existir, você receberá as instruções por e-mail.',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      switch (e.code) {
        case 'invalid-email':
          _showMessage('O formato do e-mail é inválido.');
          break;
        case 'too-many-requests':
          _showMessage(
            'Muitas tentativas. Aguarde um pouco e tente novamente.',
          );
          break;
        case 'network-request-failed':
          _showMessage('Falha de conexão. Verifique sua internet.');
          break;
        default:
          _showMessage(
            'Não foi possível solicitar a recuperação. Tente novamente.',
          );
      }
    } catch (_) {
      if (!mounted) return;

      _showMessage('Ocorreu um erro ao solicitar a recuperação.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Exibe mensagens na parte inferior da tela.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
