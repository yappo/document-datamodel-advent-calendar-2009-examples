use strict;
use warnings;
use MyBookmark;
use DateTime;

my $bookmark = MyBookmark->new;

do {
    $bookmark->set( bookmark => [1, 1] );
    my $row = $bookmark->lookup( bookmark => [1, 1] );
    print "--- insert\n";
    print $row->create_at . "\n";
    print $row->create_dt . "\n";

    my $dt = DateTime->new( year => 1978, month => 3, day => 20 );
    $row->create_dt( $dt );
    print "--- update 1978/3/20\n";
    print $row->create_at . "\n";
    print $row->create_dt . "\n";
    $row->update;

    my $row2 = $bookmark->lookup( bookmark => [1, 1] );
    print "--- lookup 1978/3/20\n";
    print $row2->create_at . "\n";
    print $row2->create_dt . "\n";
    $row2->create_at( 0 );
    print "--- update 0\n";
    print $row2->create_at . "\n";
    print $row2->create_dt . "\n";
    $row2->update;

    my $row3 = $bookmark->lookup( bookmark => [1, 1] );
    print "--- lookup 0\n";
    print $row3->create_at . "\n";
    print $row3->create_dt . "\n";
};

END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
    $itr = $bookmark->get('bookmark');
    while (<$itr>) { $_->delete }
}
