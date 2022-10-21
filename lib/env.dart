const bool isProduction = bool.fromEnvironment('dart.vm.product');

const debugConfig = {
  'baseUrl': 'https://bishalbudhathoki.me',
};

const releaseConfig = {
  'baseUrl': 'https://bishalbudhathoki.me',
};

const env = isProduction ? releaseConfig : debugConfig;