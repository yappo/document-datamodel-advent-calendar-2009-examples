use strict;
use warnings;
use MyBookmark;

*Data::Model::Driver::DBI::start_query = sub {
    my(undef , $sql, $columns) = @_;
    if (ref($columns) eq 'ARRAY') {
        $columns = join ', ', @{ $columns };
    }
    warn "----------\nSQL: $sql\n$columns\n----------\n";
};

my $bookmark = MyBookmark->new;
$bookmark->set(
    user => 1 => { nickname => 'Yappo' }
);
$bookmark->set(
    user => 11 => { nickname => 'nekokak' }
);

do {
    my $itr = $bookmark->get(
        user => 1
    );
    warn $itr->next->nickname;
};

do {
    my $itr = $bookmark->get(
        user => {
            index => {
                nickname => 'Yappo'
            }
        }
    );
    warn $itr->next->nickname;
};


do {
    my $itr = $bookmark->get(
        user => {
            where => [
                nickname => 'Yappo'
            ]
        }
    );
    warn $itr->next->nickname;
};

do {
    my $itr = $bookmark->get(
        user => {
            where => [
                nickname => [qw/ nekokak Yappo kan /]
            ]
        }
    );
    warn $itr->next->nickname;
};
do {
    my $itr = $bookmark->get(
        user => {
            where => [
                nickname => { 'IN' => [qw/ nekokak Yappo kan /] }
            ]
        }
    );
    while (<$itr>) { warn $_->nickname }
};
do {
    my $itr = $bookmark->get(
        user => {
            where => [
                nickname => { 'NOT IN' => [qw/ nekokak kan /] }
            ]
        }
    );
    while (<$itr>) { warn $_->nickname }
};

do {
    my $itr = $bookmark->get(
        user => {
            where => [
                id => { '<' => 10 }
            ]
        }
    );
    warn $itr->next->nickname;
};
do {
    my $itr = $bookmark->get(
        user => {
            where => [
                id => { '>' => 10 }
            ]
        }
    );
    warn $itr->next->nickname;
};

do {
    my $itr = $bookmark->get(
        user => {
            where => [
                nickname => \'IS NOT NULL',
            ]
        }
    );
    while (<$itr>) { warn $_->nickname }
};

do {
    my $itr = $bookmark->get(
        user => {
            where => [
                id => { '<' => 10 },
                nickname => 'Yappo',
            ]
        }
    );
    warn $itr->next->nickname;
};

do {
    my $itr = $bookmark->get(
        user => {
            where => [
                id => [ -and => { '<=' => 11 }, { '>=' => 1 } ]
            ]
        }
    );
    while (<$itr>) { warn $_->nickname }
};

do {
    my $itr = $bookmark->get(
        user => {
            where => [
                id => [ -and => 1, 2, 3 ]
            ]
        }
    );
    while (<$itr>) { warn $_->nickname }
};

do {
    my $itr = $bookmark->get(
        user => {
            where => [
                nickname => [ { '=' => 'Yappo' }, { '=' => 'nekokak' } ]
            ]
        }
    );
    while (<$itr>) { warn $_->nickname }
};

do {
    my $itr = $bookmark->get(
        user => {
            limit  => 1,
            offset => 1,
        }
    );
    while (<$itr>) { warn $_->nickname }
};


do {
    my $itr = $bookmark->get(
        user => {
            order => [ { id => 'DESC' } ]
        }
    );
    while (<$itr>) { warn $_->nickname }
};

do {
    my $itr = $bookmark->get(
        user => {
            order => [ { id => 'DESC' }, { nickname => 'ASC' } ]
        }
    );
    while (<$itr>) { warn $_->nickname }
};

do {
    my $dbh = $bookmark->get_driver('user')->r_handle;
    my $sth = $dbh->prepare_cached('SELECT COUNT(*) AS count FROM user');
    $sth->execute;
    my $count;
    $sth->bind_columns(undef, \$count);
    $count = 0 unless $sth->fetch;
    $sth->finish;
    warn "COUNT: $count";
};


END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
}

