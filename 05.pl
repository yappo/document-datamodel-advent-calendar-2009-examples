use strict;
use warnings;
use MyBookmark;

my $bookmark = MyBookmark->new;
$bookmark->set(
    user => 1 => { nickname => 'Yappo' }
);
$bookmark->set(
    user => 11 => { nickname => 'nekokak' }
);
$bookmark->set(
    user => 101 => { nickname => 'kan' }
);

print "COUNT: " . $bookmark->count('user') . "\n";

END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
}
