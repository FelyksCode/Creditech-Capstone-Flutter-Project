enum NavigationRoute {
  mainRoute("/"),
  settingRoute("/setting"),
  loginRoute("/login");

  const NavigationRoute(this.name);
  final String name;
}
