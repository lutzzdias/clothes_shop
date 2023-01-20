String getErrorString(String code) {
  switch (code) {
    case 'invalid-email':
      return 'Seu e-mail é inválido.';
    case 'email-already-exists':
      return 'Sua senha está incorreta.';
    case 'invalid-password':
      return 'Sua senha está incorreta.';
    case 'wrong-password':
      return 'Sua senha está incorreta.';
    default:
      return code;
  }
}
