package authentication;
use Dancer ':syntax';
our $VERSION="0.1";
use Net::OAuth2::Client;

  sub client {
  	Net::OAuth2::Client->new(
  		config->{client_id},
  		config->{client_secret},
  		site => 'https://graph.facebook.com',
  	)->web_server(
  	  redirect_uri => uri_for('/auth/facebook/callback')
  	);
  }

  # Send user to authorize with service provider
  get '/auth/facebook' => sub {
  	redirect client->authorize_url;
  };

  # User has returned with '?code=foo' appended to the URL.
  get '/auth/facebook/callback' => sub {
  
  	# Use the auth code to fetch the access token
  	my $access_token =  client->get_access_token(params->{code});

  	# Use the access token to fetch a protected resource
  	my $response = $access_token->get('/me');

  	# Do something with said resource...

  	if ($response->is_success) {
  	  return "Yay, it worked: " . $response->decoded_content;
  	}
  	else {
  	  return "Error: " . $response->status_line;
  	}
  };
true;
