use strict;
use warnings;
use MyBookmark;
use DateTime;

my $bookmark = MyBookmark->new;

do {
    $bookmark->set( bookmark => [1, 1] );
    my $row = $bookmark->lookup( bookmark => [1, 1] );
    print $row->create_at . "\n";

    my $dt = DateTime->new( year => 1978, month => 3, day => 20 );
    $row->create_at( $dt );
    print $row->create_at . "\n";
    $row->update;

    my $row2 = $bookmark->lookup( bookmark => [1, 1] );
    print $row2->create_at . "\n";
    $row2->create_at( 0 );
    print $row2->create_at . "\n";
    $row2->update;

    my $row3 = $bookmark->lookup( bookmark => [1, 1] );
    print $row3->create_at . "\n";
};

END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
    $itr = $bookmark->get('bookmark');
    while (<$itr>) { $_->delete }
}
