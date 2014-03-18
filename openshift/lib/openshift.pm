package openshift;
use Dancer ':syntax';
use Dancer::Plugin::Database;
our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};
get '/donation/view/list' => sub {
    
	my @row = database->quick_select('donor', {  });
        template 'display_donor_list', { widget => \@row };
};
get '/donation/view/:id' => sub {
	my $row = database->quick_select('donor', { id => 42 });
	template 'display_donor', { widget => $row };
};
post '/donation/add' =>sub{

    database->quick_insert('donor', { name => params->{name} });

};
get '/donation' => sub {
    "Hello, World!";
};

true;
