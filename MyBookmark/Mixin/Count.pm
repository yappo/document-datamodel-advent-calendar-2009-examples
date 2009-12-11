package MyBookmark::Mixin::Count;
use strict;
use warnings;
use Data::Model::SQL;
use Data::Model::Driver::DBI;

sub register_method {
    +{
        count => \&count,
    };
}

sub count {
    my($self, $model, $key, $query) = @_;
    my $driver = $self->get_driver($model);
    my $schema = $self->get_schema($model);

    if (defined $key && ref($key) eq '') {
        # primary key は array-ref である必要がある
        $key = [ $key ];
    } elsif (ref($key) ne 'ARRAY') {
        $query = $key;
        undef $key;
    }
    unless (defined $query) {
        $query = {};
    } else {
        die "query should be hash-ref" unless ref($query) eq 'HASH';
    }

    my %q = (
        select => 'COUNT(*) AS count',
        from   => $model,
        %{ $query }
    );
    my $index = $q{index};
    my $sql_obj = Data::Model::SQL->new( %q );
    $driver->add_key_to_where($sql_obj, $schema->key, $key) if $key;
    $driver->add_index_to_where($schema, $sql_obj, $index) if $index;
    my $sql = $sql_obj->as_sql;

    # パラメータをバインドする為の前処理
    my @params;
    for my $i (1..scalar(@{ $sql_obj->bind })) {
        push @params, [ $sql_obj->bind_column->[$i - 1], $sql_obj->bind->[$i - 1] ];
    }

    my $sth;
    my $count = 0;
    eval {
        # SELECT する為の dbh を取得
        my $dbh = $driver->r_handle;
        $driver->start_query($sql, $sql_obj->bind); # クエリログ用
        $sth = $dbh->prepare($sql);
        # パラメータを bind する
        $driver->bind_params($schema, \@params, $sth);
        $sth->execute;
        $sth->bind_columns(undef, \$count);
        $count = 0 unless $sth->fetch;
        $sth->finish;
        $driver->end_query($sth); # クエリログ用
    };
    if ($@) {
        # エラーがあったらスタックトレース吐いて終了
        $driver->_stack_trace($sth, $sql, $sql_obj->bind, $@);
    }
    return $count;
}

1;

