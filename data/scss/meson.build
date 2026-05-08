scss_dependencies = files(
  'theme.scss',
)

scss = custom_target(
  'scss',
  input: files('main.scss'),
  output: ['style.css'],
  command: [
    find_program('sass', required: true),
    '@INPUT@',
    '@OUTPUT@',
  ],
  depend_files: scss_dependencies,
)
