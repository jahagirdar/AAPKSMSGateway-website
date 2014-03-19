package openshift;
use Dancer ':syntax';
use Dancer::Plugin::Database;
our $VERSION = '0.1';
my $dbh = database({ driver => 'mysql', database=>'fundraiser',host=>"mysql://$ENV{OPENSHIFT_MYSQL_DB_HOST}",port=>$ENV{OPENSHIFT_MYSQL_DB_PORT},username=>'adminKcmiYjK',password=>'dP2tJsSDvSrz',connection_check_threshold=>10});
get '/' => sub {
    template 'index';
};
get '/donation/view/list' => sub {
    
	my @row = $dbh->quick_select('donation', {  });
        template 'display_donor_list', { widget => \@row };
};
get '/donation/view/:id' => sub {
	my $row = $dbh->quick_select('donation', { id => 42 });
	template 'display_donor', { widget => $row };
};
post '/donation/add' =>sub{

    $dbh->quick_insert('donation', { Name => params->{name},
	   Donor_Phone=>params->{dn_phone},
  Volunteer_Phone=>params->{vol_phone},
Donation_Time=>params->{don_time},
Receipt=>params->{rec_number} });

};
get '/donation' => sub {
    "Hello, World!";
};

true;
