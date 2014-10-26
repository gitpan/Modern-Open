package # hide from PAUSE(The [Perl programming] Authors Upload Server)
        Test::Simple;

use 5.00503;
use strict;
use vars qw($VERSION $tests $testno $ok);
$VERSION = 0.01;
$tests = 0;
$testno = 1;
$ok = 0;

BEGIN {
    $| = 1;
    $SIG{__DIE__} = sub { exit(255) };
}

END {
    exit((($tests-$ok)<=254) ? ($tests-$ok) : 254);
}

sub import {
    if ($_[1] eq 'tests') {
        $tests = $_[2];
        print "1..$tests\n";
    }
    else {
        die "Test::Simple requires 'tests', like 'use Test::Simple tests => 3;'\n";
    }
    no strict 'refs';
    *{caller() . '::ok'}  = \&ok;
}

sub ok {
    if ($_[0]) {
        print join(' - ',"ok $testno",$_[1]), "\n";
        $ok++;
    }
    else {
        print join(' - ',"not ok $testno",$_[1]), "\n";
    }
    $testno++;
}

1;

__END__

=pod

=head1 NAME

  Test::Simple - Test::Simple for perl 5.00503

=head1 SYNOPSIS

  use Test::Simple tests => 1;
  ok( $foo eq $bar, 'foo is bar' );

=head1 DESCRIPTION

Yet another implementation of Test::Simple for perl 5.00503.
Please see original Test::Simple's document to more information.
L<Test::Simple - Basic utilities for writing tests.|http://search.cpan.org/dist/Test-Simple/>

=head1 AUTHOR

INABA Hitoshi E<lt>ina@cpan.orgE<gt>

This project was originated by INABA Hitoshi.

=head1 LICENSE AND COPYRIGHT

This software is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=head1 SEE ALSO

=over 4

=item * L<Test::Simple - Basic utilities for writing tests.|http://search.cpan.org/dist/Test-Simple/> - CPAN

=item * L<ina|http://search.cpan.org/~ina/> - CPAN

=item * L<The BackPAN|http://backpan.perl.org/authors/id/I/IN/INA/> - A Complete History of CPAN

=back

=cut

