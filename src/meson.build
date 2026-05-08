vala_sources += [
  'main.vala',
  'app.vala',
  'window.vala',
]

dependencies = [
  dependency('gtk4-layer-shell-0'),
  dependency('gio-unix-2.0'),
  dependency('glib-2.0'),
  dependency('libadwaita-1'),
  dependency('sqlite3'),
]

executable(
  meson.project_name(),
  sources: vala_sources + sources,
  dependencies: dependencies,
  install: true,
)
