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
        column 'id';
    };
}

my $queue = TestQueue->new;

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
