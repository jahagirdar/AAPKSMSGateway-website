package openshift;
use Dancer ':syntax';
use Dancer::Plugin::Database;
our $VERSION = '0.1';
my $dbh = database({ driver => 'mysql', database=>'fundraiser',host=>$ENV{OPENSHIFT_MYSQL_DB_HOST},port=>$ENV{OPENSHIFT_MYSQL_DB_PORT},username=>'adminKcmiYjK',password=>'dP2tJsSDvSrz',connection_check_threshold=>10});
#my $dbh = database();
get '/' => sub {
	template 'index';
};
get '/donation/view/list' => sub {

	my @row = $dbh->quick_select('donation', {  });
	#print $#row;
	template 'display_donor_list', { table => \@row };
};
get '/volunteer/view/list' => sub {

	my @row = $dbh->quick_select('volunteer', {  },{order_by=>'constituency');
	#print $#row;
	template 'display_volunteer_list', { table => \@row };
};
get '/pledge/view/list' => sub {

	my @row = $dbh->quick_select('pledge', {  });
	#print $#row;
	template 'display_pledge_list', { table => \@row };
};
get '/donation/view/:id' => sub {
	my $row = $dbh->quick_select('donation', { id => 42 });
	template 'display_donor', { widget => $row };
};
get '/donation/add' =>sub{

	$dbh->quick_insert('donation', { Name => params->{name},
			Donor_Phone=>params->{dn_phone},
			Volunteer_Phone=>params->{vol_phone},
			Donation_Time=>params->{don_time},
			amount=>params->{amount},
			Receipt=>params->{rec_number},
			phone_id=>params->{id}	});

};
get '/donation' => sub {
    "Hello, World!";
};

###########################
# AJAX Interface          #
###########################
set serializer => 'JSON';
 
get '/donation/json/lastUpload' => sub{
	my $sth=$dbh->prepare('SELECT max(phone_id) FROM donation;');
	$sth->execute();
my @row = $sth->fetchrow_array;
	debug(@row);
	my $r->{"id"}=$row[0];
	return $r;
};
post '/donation/json/add' => sub {
	#$data->{"phone"}=param('dn_phone');
	my $data=from_json(request->body);

	debug($data);
#	return params;
$dbh->quick_insert('donation', { Name => $data->{name},
		Donor_Phone=>$data->{dn_phone},
		Volunteer_Phone=>$data->{vol_phone},
		Donation_Time=>$data->{don_time},
		amount=>$data->{amount},
		Receipt=>$data->{receipt},
		phone_id=>$data->{id}	});
};

##################### Volunteer #####################

get '/volunteer/json/lastUpload' => sub{
	my $sth=$dbh->prepare('SELECT max(phone_id) FROM volunteer;');
	$sth->execute();
my @row = $sth->fetchrow_array;
	debug(@row);
	my $r->{"id"}=$row[0];
	return $r;
};
post '/volunteer/json/add' => sub {
	#$data->{"phone"}=param('dn_phone');
	my $data=from_json(request->body);

	debug($data);
#	return params;

my $row = $dbh->quick_select('volunteer', { phone_id => $data->{id} });
if($row->{'constituency'} eq undef ){
	$row->{'constituency'}='Karnataka';
}
$dbh->quick_insert('volunteer', { name => $data->{name},
		phone_number=>$data->{phone},
		limit=>$data->{limit},
		parent=>$data->{parent},
		role=>$data->{role},
		govtid=>$data->{govtid},
		constituency=>$row->{'constituency'},
		phone_id=>$data->{id}	});
};
##################### Pledge #####################

get '/pledge/json/lastUpload' => sub{
	my $sth=$dbh->prepare('SELECT max(phone_id) FROM pledge;');
	$sth->execute();
my @row = $sth->fetchrow_array;
	debug(@row);
	my $r->{"id"}=$row[0];
	return $r;
};
post '/pledge/json/add' => sub {
	#$data->{"phone"}=param('dn_phone');
	my $data=from_json(request->body);

	debug($data);
#	return params;
$dbh->quick_insert('pledge', {
		phone_number=>$data->{phone},
		Constituency=>$data->{candidate},
		amount=>$data->{amount},
		phone_id=>$data->{id}	});
};
true;
