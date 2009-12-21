package MyDiary;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Schema sugar => 'mycolumns';
use Columns;

{
    # driver setup
    use Data::Model::Driver::DBI;
    my $driver = Data::Model::Driver::DBI->new(
        dsn => 'dbi:SQLite:dbname=mydiary.db', '', ''
    );
    base_driver $driver;
}

install_model diary => schema {
    key 'id';
    index user => [qw/ user_id id /];

    column 'diary.id';
    column 'user.id';
};

1;

