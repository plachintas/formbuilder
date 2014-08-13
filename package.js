Package.describe({
  summary: "Formbuilder is a small graphical interface for letting users build their own webforms"
});

Package.on_use(function (api) {
  api.add_files('dist/formbuilder.js', 'client');
  api.add_files('dist/formbuilder.css', 'client');
});