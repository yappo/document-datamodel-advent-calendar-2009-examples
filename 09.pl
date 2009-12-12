use strict;
use warnings;
use MyBookmark;

my $bookmark = MyBookmark->new;
do {
    $bookmark->set(
        user => 1 => { nickname => 'Yappo' }
    );
    $bookmark->set(
        user => 11 => { nickname => 'nekokak' }
    );
    $bookmark->set(
        user => 101 => { nickname => 'kan' }
    );
};

do {
    my $count = $bookmark->count(
        user => {
            where => [
                id => { '<' => 100 }
            ],
        }
    );
    print "Count: $count\n"; # Count: 2
};

do {
    $bookmark->set( bookmark => [1, 1] );
    $bookmark->set( bookmark => [2, 1] );
    $bookmark->set( bookmark => [3, 1] );
    $bookmark->set( bookmark => [4, 1] );
    $bookmark->set( bookmark => [1, 2] );
    $bookmark->set( bookmark => [2, 2] );
    $bookmark->set( bookmark => [3, 2] );
    $bookmark->set( bookmark => [4, 2] );
};

do {
    # url_id = 1 のレコード数
    warn $bookmark->count( bookmark => 1 );
    # url_id = 2 で user_id < 2 のレコード数
    warn $bookmark->count( bookmark => 1 => { where => [ user_id => { '<' => 2 } ] } );
    # user_id = 2 のレコード数
    warn $bookmark->count( bookmark => { index => { user_id => 2 } } );
};


END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
    $itr = $bookmark->get('bookmark');
    while (<$itr>) { $_->delete }
}
