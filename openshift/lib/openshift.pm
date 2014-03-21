package openshift;
use Dancer ':syntax';
use Dancer::Plugin::Database;
our $VERSION = '0.1';
get '/donation' => sub {
    "Hello, World!";
};

true;
