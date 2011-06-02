package InTime;
use strict;
use warnings;

sub in_time {
  my ( $time , %args ) = @_;

  my ( $from, $to ) = ( $args{from}, $args{to} );

  if ( $from < $to ) {
    return 1 if ( $from <= $time && $time < $to );
  } elsif ( $from == $to ) {
    return 1 if $from == $time;
  } else {
    return 1 if ( $from <= $time || $time < $to );
  }

}

package main;
use strict;
use warnings;
use Test::More;

subtest 'normal case' => sub {
    ok(!InTime::in_time(9, from => 10, to => 20) , "before start time should not be in time.");
    ok(InTime::in_time(10, from => 10, to => 20), "start time should be in time.");
    ok(InTime::in_time(19, from => 10, to => 20), "before end time should be in time.");
    ok(!InTime::in_time(20, from => 10, to => 20), "before end time should not be in time.");
};

subtest 'reverse order case' => sub {
    ok(!InTime::in_time(19, from => 20, to => 10), "before start time should not be in time ( reverse )");
    ok(InTime::in_time(20, from => 20, to => 10), "start time should be in time ( reverse )");
    ok(InTime::in_time(9, from => 20, to => 10), "before end time should be in time ( reverse )");
    ok(!InTime::in_time(10, from => 20, to => 10), "end time should not be in time ( reverse )");
};

subtest 'in case from time equal to time' => sub {
    ok(InTime::in_time(10, from => 10, to => 10), "in case from time equal to time");
    ok(!InTime::in_time(9, from => 10, to => 10), "in case from time equal to time");
    ok(!InTime::in_time(11, from => 10, to => 10), "in case from time equal to time");
};

done_testing;
