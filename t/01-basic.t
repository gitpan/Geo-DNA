use Test::More tests => 11;
use Data::Dumper;

BEGIN { use_ok( 'Geo::DNA' ) }

sub value_is_near {
    my ( $value, $comparator, $error ) = @_;
    $error ||= 0.005;
    return ( abs($comparator - $value) < $error );
}

use Geo::DNA qw(
    encode_geo_dna
    decode_geo_dna
    neighbours_geo_dna
);

my $geo = encode_geo_dna( -41.288889, 174.777222, precision => 22 );
ok( $geo eq 'etctttagatagtgacagtcta', "Wellington's DNA is correct" );

my ($lat, $lon) = decode_geo_dna( $geo );

ok( value_is_near( $lat, -41.288889 ), "Latitude converted back correctly." );
ok( value_is_near( $lon, 174.777222 ), "Longitude converted back correctly." );

$geo = encode_geo_dna( -41.283333, 173.283333, precision => 16 );
ok( $geo eq 'etcttgctagcttagt', "Nelson's DNA is correct" );

($lat, $lon) = decode_geo_dna( $geo );
ok( value_is_near( $lat, -41.283333, 0.5 ), "Latitude converted back correctly." );
ok( value_is_near( $lon, 173.283333, 0.5 ), "Longitude converted back correctly." );

$geo = encode_geo_dna( 7.0625, -95.677068 );
ok( $geo eq 'watttatcttttgctacgaagt', "Encoded successfully" );

my ( $new_lat, $new_lon ) = Geo::DNA::add_vector( -41.288889, 174.777222, 10.0, 10.0 );
ok( value_is_near( $new_lat, -31.288889 ), "New latitude is good" );
ok( value_is_near( $new_lon, -175.222777 ), "New longitude is good" );

my $neighbours = neighbours_geo_dna( 'etctttagatag' );
ok( $neighbours && scalar @$neighbours == 8, "Got back correct neighbours" );
