use strict;
use warnings;
use MyBookmark;

{
    package Data::Model::Driver::DBI;

    no warnings 'redefine'; # sub の重複定義で warning を出さないよ
    sub start_query {
        my($self, $sql, $bind) = @_;
        my $params;
        if (ref($bind) eq 'HASH') {
            # insert or replace
            $params = join ', ', map { "$_ => $bind->{$_}" } keys %{ $bind };
        } elsif (ref($bind) eq 'ARRAY') {
            # select or update or delete
            $params = join ', ', @{ $bind };
        }

        print "--- QUERY DUMP START
SQL : $sql
BIND: $params
--- QUERY DUMP END
";
    }
}

my $bookmark = MyBookmark->new;
$bookmark->set(
    user => 1 => { nickname => 'Yappo' }
);
my $row = $bookmark->lookup( user => 1 );
$row->nickname('takefumi');
$row->update;
$row->delete;

END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
    $itr = $bookmark->get('bookmark');
    while (<$itr>) { $_->delete }
}
