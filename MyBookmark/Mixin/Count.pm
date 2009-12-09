package MyBookmark::Mixin::Count;
use strict;
use warnings;
use Data::Model::SQL;

sub register_method {
    +{
        count => \&count,
    };
}

sub count {
    my($self, $model) = @_;

    my $dbh = $self->get_driver($model)->r_handle;
    my $sth = $dbh->prepare_cached('SELECT COUNT(*) AS count FROM ' . $model);
    $sth->execute;
    my $count;
    $sth->bind_columns(undef, \$count);
    $count = 0 unless $sth->fetch;
    $sth->finish;
    return $count;
}

1;

