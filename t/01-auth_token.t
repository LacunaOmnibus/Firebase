#!perl
use 5.006;
use strict;
use lib '../lib';
use warnings FATAL => 'all';
use Test::More;
use JSON::XS;
use MIME::Base64;

BEGIN {
    use_ok( 'Firebase::Auth' ) || print "Bail out!\n";
}

my $tk = 'aca98axPOec';

my $firebase= Firebase::Auth->new ( secret =>$tk, admin => 'true' );

isa_ok($firebase, 'Firebase::Auth');

is ($firebase->secret , $tk, 'secret token added');


my $custom_data = {'auth_data', 'foo', 'other_auth_data', 'bar'};

my $token = $firebase->create_token ( $custom_data );
diag $token;

my ($header, $claims, $signature) = split(/\./, $token);

is $header, 'eyJhbGciOiAiSFMyNTYiLCAidHlwIjogIkpXVCJ9', 'encoded the data properly';

is decode_json(decode_base64($claims))->{admin}, 'true', 'claims encoded properly';


done_testing();