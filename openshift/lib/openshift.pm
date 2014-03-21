package openshift;
use Dancer ':syntax';
use Dancer::Plugin::Database;
our $VERSION = '0.1';
#my $dbh = database({ driver => 'mysql', database=>'fundraiser',host=>$ENV{OPENSHIFT_MYSQL_DB_HOST},port=>$ENV{OPENSHIFT_MYSQL_DB_PORT},username=>'adminKcmiYjK',password=>'dP2tJsSDvSrz',connection_check_threshold=>10});
my $dbh = database();
get '/' => sub {
	template 'index';
};
get '/donation/create/volunteer' => sub{
	  my $sth = database->prepare(
            'CREATE TABLE volunteer ( phone_number TEXT PRIMARY KEY, name         TEXT, id           TEXT, amount       TEXT, role         TEXT, creator      TEXT );'
        );
        $sth->execute();
	  $sth = database->prepare(
            'CREATE TABLE donation ( id TEXT PRIMARY KEY, donor_phone TEXT, name TEXT, volunteer_phone TEXT, amount TEXT, receipt TEXT, time TEXT );'
        );
        $sth->execute();
    "Database Created";
};
get '/donation/view/list' => sub {

	my @row = $dbh->quick_select('donation', {  });
	print $#row;
	template 'display_donor_list', { table => \@row };
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
