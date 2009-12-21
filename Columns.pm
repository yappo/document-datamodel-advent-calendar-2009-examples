package Columns;
use strict;
use warnings;
use Data::Model::Schema sugar => 'mycolumns';

column_sugar 'user.id'
    => int => {
        required => 1,
        unsigned => 1,
    };

column_sugar 'diary.id'
    => int => {
        required => 1,
        unsigned => 1,
    };

column_sugar 'global.epoch'
    => int => {
        required => 1,
        unsigned => 1,
    };

1;
