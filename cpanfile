requires 'perl', '5.008001';
requires 'Time::Piece';
requires 'Time::Seconds';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Exception';
};
