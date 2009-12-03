use strict;
use warnings;
use MyBookmark;

my $bookmark = MyBookmark->new;

# 複合 primary key
do {
    # url_id = 1, user_id = 2 で bookmark テーブルにレコードを作成
    $bookmark->set(
        bookmark => [1, 2]
    );

    # SELECT * FROM bookmark WHERE url_id = 1 AND user_id = 2; してレコードを一件取得
    my $row = $bookmark->lookup( bookmark => [1, 2] );
    print sprintf "URL_ID: %d\nUSER_ID: %s\n", $row->url_id, $row->user_id;

    # index を使って検索
    # SELECT * FROM user WHERE user_id = 2; してレコードを取得
    my $itr = $bookmark->get(
        bookmark => {
            index => { user_id => 2 }
        }
    );
    $row = $itr->next; # 最初の1レコード目を取得
    print sprintf "URL_ID: %d\nUSER_ID: %s\n", $row->url_id, $row->user_id;

    # 取得したレコードを DELETE 文で削除
    $row->delete;
};


# unique
do {
    # id = 1, nickname = 'Yappo' で user テーブルにレコードを作成
    $bookmark->set(
        user => 1 => {
            nickname => 'Yappo',
        },
    );

    # id = 2, nickname = 'Yappo' で user テーブルにレコードを作成しようとする
    eval {
        $bookmark->set(
            user => 2 => {
                nickname => 'Yappo',
            },
        );
    };
    print "ERROR!\n" if $@;

    # SELECT * FROM user WHERE nickname = 'Yappo'; してレコードを取得
    my $itr = $bookmark->get(
        user => {
            index => { nickname => 'Yappo' }
        }
    );
    my $row = $itr->next; # 最初の1レコード目を取得
    print sprintf "ID: %d\nNICKNAME: %s\n", $row->id, $row->nickname;

    # 取得したレコードを DELETE 文で削除
    $row->delete;
};
