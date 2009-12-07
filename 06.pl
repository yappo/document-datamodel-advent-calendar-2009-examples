use strict;
use warnings;
use MyBookmark;

my $bookmark = MyBookmark->new;
$bookmark->set(
    user => 1 => { nickname => 'Yappo' }
);
$bookmark->set(
    bookmark => [1, 1]
);

my $bookmark_row = $bookmark->lookup( bookmark => [1, 1] );
my $user_row     = $bookmark_row->user;
print "nickname = " . $user_row->nickname . "\n";

END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
}
