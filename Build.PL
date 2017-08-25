use Module::Build;

Module::Build->new(
  module_name => 'FXC',
  dist_abstract => 'Currency converter based on ECBs reference rate feed',
  license => 'perl',
  requires => {
    'XML::LibXML' => '0',
    'LWP::UserAgent' => '0',
  },
)->create_build_script;
