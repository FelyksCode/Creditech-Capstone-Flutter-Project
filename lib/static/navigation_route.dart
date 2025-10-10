enum NavigationRoute {
  login('/login'),
  mainRoute('/'),
  home('/home'),
  analytics('/analytics'),
  history('/history'),
  profile('/profile');

  const NavigationRoute(this.path);
  final String path;
}
