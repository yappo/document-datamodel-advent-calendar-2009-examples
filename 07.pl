use strict;
use warnings;
use MyBookmark;

my $bookmark = MyBookmark->new;
do {
    my $row = $bookmark->set(
        user => 1 => { nickname => 'Yappo' }
    );
    warn $row->nickname;
};

do {
    my $row = $bookmark->find_or_create(
        user => 11 => { nickname => 'nekokak' }
    );
    print $row->nickname . "\n";
    $row = $bookmark->find_or_create(
        user => 11 => { nickname => 'nekoya' }
    );
    print $row->nickname . "\n";
};

do {
    $bookmark->update(
        user => 1 => undef => { nickname => 'yusukebe' }
    );
    my $row = $bookmark->lookup( user => 1 );
    warn $row->nickname;

    $bookmark->update(
        user => {
            where => [ nickname => 'yusukebe' ],
        } => { nickname => 'youpy' }
    );
    $row = $bookmark->lookup( user => 1 );
    warn $row->nickname;

    $row->nickname('Yappo');
    $row->update;
    warn $row->nickname;
};

do {
    $bookmark->delete(
        user => 1
    );
    $bookmark->delete(
        user => {
            where => [ nickname => 'nekokak' ],
        },
    );
    $bookmark->delete(
        user => 1 => {
            where => [ nickname => 'Yappo' ],
        },
    );

    my $itr = $bookmark->get( 'user' );
    while (<$itr>) { warn $_->nickname }

};


END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
}
