use strict;
use warnings;

{
    package TestQueue;
    use base 'Data::Model';
    use Data::Model::Schema;
    use Data::Model::Mixin modules => ['Queue::Q4M'];
    use Data::Model::Driver::Queue::Q4M;

    my $driver = Data::Model::Driver::Queue::Q4M->new(
        dsn => 'dbi:mysql:database=test'
    );
    base_driver $driver;

    install_model queue_test => schema {
        columns qw/ id job_name /;

        schema_options create_sql_attributes => {
            mysql => 'TYPE=Queue',
        };
    };
    install_model queue_test_1 => schema {
        columns qw/ id job_name /;

        schema_options create_sql_attributes => {
            mysql => 'TYPE=Queue',
        };
    };
    install_model queue_test_2 => schema {
        columns qw/ id job_name /;

        schema_options create_sql_attributes => {
            mysql => 'TYPE=Queue',
        };
    };
}
print join(";\n", TestQueue->as_sqls, '');
print "--------\n";

my $queue = TestQueue->new;

do {
    # queue を一つ作る
    $queue->set(
        queue_test => {
            id       => 1,
            job_name => 'get http://example.com/',
        },
    );

    # queue を読む
    my($q) = $queue->get('queue_test');
    warn $q->job_name;

    # こういう delete はできない
    $q->delete;

    # 直接 query を吐いて delete する
    $queue->delete('queue_test', {
        where => [
            id => 1,
        ],
    });

    # DELETE FROM queue_test; はこれ
    $queue->delete('queue_test', {});

};
do {
    $queue->set(
        queue_test => {
            id       => 1,
            job_name => 'get http://example.com/',
        },
    );

    my $ret = $queue->queue_running(
        queue_test => sub {
            my $row = shift;
            warn $row->id;
            warn $row->job_name;
            $queue->queue_abort;
        },
    );
    warn $ret;

    eval {
        my $ret = $queue->queue_running(
            queue_test => sub {
                die "abort"; # ここで queue_abort が呼ばれる
            },
        );
    };
    $@ and warn $@; # 'abort' と表示
    warn $ret;

    my $ret = $queue->queue_running(
        queue_test => sub {
            return; # ここで queue_end が呼ばれる
        },
    );
    warn $ret; # 処理した queue テーブル名を表示
};


exit;

=pod

do {
    # こいつは、 Q4M の queue_wait が終わるまでシグナルをトラップしない
    local $SIG{INT} = sub { warn "int" };
    $queue->queue_running( queue_test => sub {}, timeout => 5 );
};

do {
    # DBI のドキュメントを参考にしたよ
    # これはトラップする
    use POSIX ':signal_h';

    # シグナル設定
    my $mask = POSIX::SigSet->new( SIGINT );
    my $action = POSIX::SigAction->new(sub { warn "int" }, $mask);

    # local $SIG{INT} = sub {} 相当の事をするので、もともとのシグナルを覚えとく
    my $oldaction = POSIX::SigAction->new();
    sigaction(SIGINT, $action, $oldaction);

    $queue->queue_running( queue_test => sub {}, timeout => 5 );

    # もともとのシグナルに戻す
    sigaction(SIGINT, $oldaction);
};

do {
    # せいかい
    use Sys::SigAction qw( set_sig_handler );
    my $h = set_sig_handler( 'INT', sub { warn "int" }, { flags => SA_RESTART });
    $queue->queue_running( queue_test => sub {}, timeout => 5 );
};

=cut



END {
#    $queue->delete('queue_test', {});
    $queue->delete('queue_test_1', {});
    $queue->delete('queue_test_2', {});
}
