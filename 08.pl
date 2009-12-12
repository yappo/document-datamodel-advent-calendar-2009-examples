use strict;
use warnings;
use MyBookmark;
use Data::Model::SQL;
use Data::Model::Driver::DBI;

my $bookmark = MyBookmark->new;

do {
    my $sql = Data::Model::SQL->new(
        select => [qw/ id nickname /], # 取り出すカラム
        from   => 'user',              # テーブル名
        where  => [                    # 検索条件
            id       => { '<=' => 100 },
            nickname => 'Yappo'
        ],
        limit  => 10,
    );

    # 組み立てた SQL を出力
    # SELECT id, nickname FROM user WHERE (id <= ?) AND (nickname = ?) LIMIT 10
    print $sql->as_sql . "\n";

    # bind されたカラム名 を取り出す
    # id, nickname
    print join(", ", @{ $sql->bind_column }) . "\n";

    # bind された値を取り出す
    # 100, Yappo
    print join(", ", @{ $sql->bind }) . "\n";
};

do {
    my $sql = Data::Model::SQL->new(
        select => [qw/ id nickname /], # 取り出すカラム
        from   => 'user',              # テーブル名
        where  => [                    # 検索条件
            id       => { '<=' => 100 },
        ],
        limit  => 10,
    );

    # user テーブルのスキーマ定義を取り出して index カラムの設定をする
    my $schema = $bookmark->get_schema('user');
    # nickname index を Yappo で絞り込み
    Data::Model::Driver::DBI->add_index_to_where($schema, $sql, { nickname => 'Yappo' });

    # 組み立てた SQL を出力
    # SELECT id, nickname FROM user WHERE (id <= ?) AND (nickname = ?) LIMIT 10
    print $sql->as_sql . "\n";

    # bind されたカラム名 を取り出す
    # id, nickname
    print join(", ", @{ $sql->bind_column }) . "\n";

    # bind された値を取り出す
    # 100, Yappo
    print join(", ", @{ $sql->bind }) . "\n";
};

do {
    my $sql = Data::Model::SQL->new(
        select => [qw/ url_id user_id /], # 取り出すカラム
        from   => 'bookmark',             # テーブル名
    );

    # bookmark テーブルのスキーマ定義を取り出して primary key 検索の設定をする
    my $schema = $bookmark->get_schema('bookmark');
    # url_id = 1 AND user_id = 2 で絞り込み
    Data::Model::Driver::DBI->add_key_to_where($sql, $schema->key, [ 1, 2 ]);

    # 組み立てた SQL を出力
    # SELECT url_id, user_id FROM bookmark WHERE (url_id = ?) AND (user_id = ?)
    print $sql->as_sql . "\n";

    # bind されたカラム名 を取り出す
    # url_id, user_id
    print join(", ", @{ $sql->bind_column }) . "\n";

    # bind された値を取り出す
    # 1, 2
    print join(", ", @{ $sql->bind }) . "\n";
};
