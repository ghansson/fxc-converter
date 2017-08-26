use Module::Build;

Module::Build->new(
  module_name => 'FXC',
  dist_abstract => 'Currency converter based on ECBs reference rate feed',
  dist_author => 'Gunnar Hansson <gunnar@ghansson.com>',
  license => 'perl',
  requires => {
    'XML::LibXML' => '0',
    'LWP::UserAgent' => '0',
    'Docopt' => '0.03',
  },
)->create_build_script;
