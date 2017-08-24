use Module::Build;

Module::Build->new(
  module_name => 'ExchangeRater',
  dist_abstract => 'Currency converter based on ECBs reference rate feed',
  dist_version => '0.1',
  license => 'perl',
  requires => {
    'XML::LibXML' => '0',
  },
)->create_build_script;
