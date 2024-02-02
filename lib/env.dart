const bool isProduction = bool.fromEnvironment('dart.vm.product');

const debugConfig = {
  'baseUrl': 'https://bishalbudhathoki.tech',
};

const releaseConfig = {
  'baseUrl': 'https://bishalbudhathoki.tech',
};

const env = isProduction ? releaseConfig : debugConfig;
