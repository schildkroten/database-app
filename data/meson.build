subdir('scss')
subdir('ui')

sources += import('gnome').compile_resources(
  'database-app-resources',
  files('database-app.gresource.xml'),
  dependencies: [blueprints, scss],
  source_dir: meson.current_build_dir(),
)
