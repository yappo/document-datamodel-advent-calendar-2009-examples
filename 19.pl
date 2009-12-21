use strict;
use warnings;
use MyBookmark;
use MyDiary;

my $bookmark = MyBookmark->new;
my $diary    = MyDiary->new;

do {
    my $yappo = $bookmark->set( user => { nickname => 'Yappo' } );
    my $diary = $diary->set(
        diary => {
            user_id => $yappo->id,
        }
    );

    printf "create_at    : %s\n", $diary->create_at;
    printf "create_dt    : %s\n", $diary->create_dt;
    printf "create_dt_utc: %s\n", $diary->create_dt_utc;
    printf "create_dt_jst: %s\n", $diary->create_dt_jst;

    # create_dt_jst から生えてるメソッドを変えても Data::Model は検知できないので
    # 他のエイリアスに値が反映されないので、意図的に set しなおしてます
    $diary->create_dt_jst(
        $diary->create_dt_jst->
            set_year(2012)->set_month(12)->set_day(21)->
                set_hour(12)->set_minute(0)->set_second(0)
    );
    print "\nchange ddate\n";

    printf "create_at    : %s\n", $diary->create_at;
    printf "create_dt    : %s\n", $diary->create_dt;
    printf "create_dt_utc: %s\n", $diary->create_dt_utc;
    printf "create_dt_jst: %s\n", $diary->create_dt_jst;
};


END {
    my $itr = $bookmark->get('user');
    while (<$itr>) { $_->delete }
    $itr = $diary->get('diary');
    while (<$itr>) { $_->delete }
}
