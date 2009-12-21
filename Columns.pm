package Columns;
use strict;
use warnings;
use Data::Model::Schema sugar => 'mycolumns';


{
    # inflate setup
    use Data::Model::Schema::Inflate;
    use DateTime;

    inflate_type DateTime => {
        inflate => sub {
            DateTime->from_epoch( epoch => $_[0] );
        },
        deflate => sub {
            ref($_[0]) && $_[0]->isa('DateTime') ? $_[0]->epoch : $_[0];
        },
    };
    inflate_type DateTimeUTC => {
        inflate => sub {
            my $dt = DateTime->from_epoch( epoch => $_[0] );
            $dt->set_time_zone('UTC');
            $dt;
        },
        deflate => sub {
            ref($_[0]) && $_[0]->isa('DateTime') ? $_[0]->epoch : $_[0];
        },
    };
    inflate_type DateTimeJST => {
        inflate => sub {
            my $dt = DateTime->from_epoch( epoch => $_[0] );
            $dt->set_time_zone('Asia/Tokyo');
            $dt;
        },
        deflate => sub {
            ref($_[0]) && $_[0]->isa('DateTime') ? $_[0]->epoch : $_[0];
        },
    };
}


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
        alias => {
            epoch_dt => {
                inflate => 'DateTime',
            },
            epoch_dt_utc => {
                inflate => 'DateTimeUTC',
            },
            epoch_dt_jst => {
                inflate => 'DateTimeJST',
            },
        },

    };

1;
