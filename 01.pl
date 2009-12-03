use strict;
use warnings;
use MyBookmark;

my $bookmark = MyBookmark->new;

# id = 1, nickname = 'Yappo' で user テーブルにレコードを作成
$bookmark->set(
    user => 1 => {
        nickname => 'Yappo',
    },
);

# SELECT * FROM user WHERE id = 1; してレコードを一件取得
my $row = $bookmark->lookup( user => 1 );
print sprintf "ID: %d\nNICKNAME: %s\n", $row->id, $row->nickname;

# 取得したレコードを DELETE 文で削除
$row->delete;
