import 'package:flutter/material.dart';
import 'package:loja_virtual/helpers/validators.dart';
import 'package:loja_virtual/models/user.dart';
import 'package:loja_virtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final User user = User.late();
  SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
        centerTitle: true,
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: formKey,
            child: Consumer<UserManager>(
              builder: (_, userManager, __) => ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Nome completo'),
                    enabled: !userManager.loading,
                    validator: (name) {
                      if (name == null || name.isEmpty)
                        return 'Campo obrigatório';
                      else if (name.trim().split(' ').length <= 1)
                        return 'Preencha seu nome completo';
                      return null;
                    },
                    onSaved: (name) => user.name = name!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !userManager.loading,
                    validator: (email) {
                      if (email == null || email.isEmpty)
                        return 'Campo obrigatório';
                      else if (!emailValid(email)) return 'E-mail inválido';
                      return null;
                    },
                    onSaved: (email) => user.email = email!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(hintText: 'Senha'),
                    obscureText: true,
                    enabled: !userManager.loading,
                    validator: (password) {
                      if (password == null || password.isEmpty)
                        return 'Campo obrigatório';
                      else if (password.length < 6) return 'Senha muito curta';
                      return null;
                    },
                    onSaved: (password) => user.password = password!,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration:
                        const InputDecoration(hintText: 'Repita a senha'),
                    obscureText: true,
                    enabled: !userManager.loading,
                    validator: (password) {
                      if (password == null || password.isEmpty)
                        return 'Campo obrigatório';
                      else if (password.length < 6) return 'Senha muito curta';
                      return null;
                    },
                    onSaved: (password) => user.confirmPassword = password!,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        disabledBackgroundColor:
                            Theme.of(context).primaryColor.withAlpha(100),
                      ),
                      onPressed: userManager.loading
                          ? null
                          : () {
                              if (formKey.currentState?.validate() ?? false) {
                                formKey.currentState?.save();
                                if (user.password != user.confirmPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Senhas não coincidem!'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                userManager.signUp(
                                  user: user,
                                  onSuccess: () => Navigator.of(context).pop(),
                                  onFail: (error) =>
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Falha ao cadastrar: $error'),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                );
                              }
                            },
                      child: userManager.loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Criar conta',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
