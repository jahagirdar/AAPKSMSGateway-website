package openshift;
use Dancer ':syntax';
use Dancer::Plugin::Database;
our $VERSION = '0.1';
my $dbh = database({ driver => 'mysql', database=>'fundraiser',host=>"mysql://$ENV{OPENSHIFT_MYSQL_DB_HOST}",port=>$ENV{OPENSHIFT_MYSQL_DB_PORT},username=>'adminKcmiYjK',password=>'dP2tJsSDvSrz',connection_check_threshold=>10});
get '/' => sub {
    template 'index';
};
get '/donation/view/list' => sub {
    
	my @row = $dhb->quick_select('donor', {  });
        template 'display_donor_list', { widget => \@row };
};
get '/donation/view/:id' => sub {
	my $row = $dbh->quick_select('donor', { id => 42 });
	template 'display_donor', { widget => $row };
};
post '/donation/add' =>sub{

    $dbh->quick_insert('donor', { name => params->{name} });

};
get '/donation' => sub {
    "Hello, World!";
};

true;
