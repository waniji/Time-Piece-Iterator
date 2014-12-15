requires 'perl', '5.008001';
requires 'Time::Piece', '1.20';
requires 'Time::Seconds';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Exception';
};

