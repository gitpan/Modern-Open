package Modern::Open;
######################################################################
#
# Modern::Open - Three-argument open and Autovivification support
#
# http://search.cpan.org/dist/Modern-Open/
#
# Copyright (c) 2014 INABA Hitoshi <ina@cpan.org>
######################################################################

$Modern::Open::VERSION = 0.01;

use 5.00503;
use strict;
local $^W = 1;
use Carp;
use Symbol;
use FileHandle;
use DirHandle;
use Fcntl;

sub _open(*$;$) {
    my $handle;

    if (defined $_[0]) {
        $handle = Symbol::qualify_to_ref($_[0], caller());
    }
    else {
        $handle = $_[0] = FileHandle->new;
    }

    if (@_ >= 4) {
        carp "Too many arguments for open";
    }
    elsif (@_ == 3) {
        my($mode,$filename) = @_[1,2];

        if ($mode eq '-|') {
            return CORE::open($handle,qq{$filename |});
        }
        elsif ($mode eq '|-') {
            return CORE::open($handle,qq{| $filename});
        }
        else {
            my $flags = {
            ''    => O_RDONLY,
            '<'   => O_RDONLY,
            '>'   => O_WRONLY | O_TRUNC | O_CREAT,
            '>>'  => O_WRONLY |O_APPEND | O_CREAT,
            '+<'  => O_RDWR,
            '+>'  => O_RDWR | O_TRUNC  | O_CREAT,
            '+>>' => O_RDWR | O_APPEND | O_CREAT,
            }->{$mode};
            return CORE::sysopen($handle,$filename,$flags);
        }
    }
    elsif (@_ == 2) {
        return CORE::open($handle,$_[1]);
    }
    else {
        carp "Not enough arguments for open";
    }

    return undef;
}

sub _opendir(*$) {
    my $handle;

    if (defined $_[0]) {
        $handle = Symbol::qualify_to_ref($_[0], caller());
    }
    else {
        $handle = $_[0] = DirHandle->new;
    }

    return CORE::opendir($handle,$_[1]);
}

sub _sysopen(*$$;$) {
    my $handle;

    if (defined $_[0]) {
        $handle = Symbol::qualify_to_ref($_[0], caller());
    }
    else {
        $handle = $_[0] = FileHandle->new;
    }

    if (@_ >= 5) {
        carp "Too many arguments for sysopen";
    }
    elsif (@_ == 4) {
        return CORE::sysopen($handle,$_[1],$_[2],$_[3]);
    }
    elsif (@_ == 3) {
        return CORE::sysopen($handle,$_[1],$_[2]);
    }
    else {
        carp "Not enough arguments for sysopen";
    }

    return undef;
}

sub _pipe(**) {
    my($handle0,$handle1);

    if (defined $_[0]) {
        $handle0 = Symbol::qualify_to_ref($_[0], caller());
    }
    else {
        $handle0 = $_[0] = FileHandle->new;
    }

    if (defined $_[1]) {
        $handle1 = Symbol::qualify_to_ref($_[1], caller());
    }
    else {
        $handle1 = $_[1] = FileHandle->new;
    }

    return CORE::pipe($handle0,$handle1);
}

sub _socket(*$$$) {
    my $handle;

    if (defined $_[0]) {
        $handle = Symbol::qualify_to_ref($_[0], caller());
    }
    else {
        $handle = $_[0] = FileHandle->new;
    }

    return CORE::socket($handle,$_[1],$_[2],$_[3]);
}

sub _accept(**) {
    my($handle0,$handle1);

    if (defined $_[0]) {
        $handle0 = Symbol::qualify_to_ref($_[0], caller());
    }
    else {
        $handle0 = $_[0] = FileHandle->new;
    }

    if (defined $_[1]) {
        $handle1 = Symbol::qualify_to_ref($_[1], caller());
    }

    return CORE::accept($handle0,$handle1);
}

sub import {
    if ($] < 5.006) {

        # avoid: Can't use string ("main::open") as a symbol ref while "strict refs" in use
        no strict 'refs';
        {
            # avoid: Prototype mismatch: sub main::open (*;$) vs (*$;$)
            local $SIG{__WARN__} = sub {};
            *{caller() . '::open'} = \&Modern::Open::_open;
        }
        *{caller() . '::opendir'}  = \&Modern::Open::_opendir;
        *{caller() . '::sysopen'}  = \&Modern::Open::_sysopen;
        *{caller() . '::pipe'}     = \&Modern::Open::_pipe;
        *{caller() . '::socket'}   = \&Modern::Open::_socket;
        *{caller() . '::accept'}   = \&Modern::Open::_accept;
    }
}

1;

__END__

=pod

=head1 NAME

  Modern::Open - Three-argument open and Autovivification support

=head1 SYNOPSIS

  use Modern::Open;

=head1 DESCRIPTION

Modern::Open provides three-argument open and autovivification support of
open, opendir, sysopen, pipe, socket, and accept, on perl 5.00503.
This is a module to help writing portable programs and modules across
recent and old versions of Perl.

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

=item * L<Perl Programming Documentation|http://perldoc.perl.org/functions/open.html> - open

=item * L<Modern Perl Programming|http://modernperlbooks.com/mt/2010/04/three-arg-open-migrating-to-modern-perl.html> - Three-arg open() (Migrating to Modern Perl)

=item * L<A blog about the Perl programming language|http://blogs.perl.org/users/buddy_burden/2013/06/pre-modern-perl-vs-post-modern-perl-fight.html> - Pre-Modern Perl VS Post-Modern Perl: FIGHT!

=item * L<404 Blog Not Found|http://blog.livedoor.jp/dankogai/archives/51176081.html> - perl - open my $fh, "comand |"; # isn't modern

=item * L<japerl|http://search.cpan.org/dist/japerl/> - CPAN

=item * L<ina|http://search.cpan.org/~ina/> - CPAN

=item * L<The BackPAN|http://backpan.perl.org/authors/id/I/IN/INA/> - A Complete History of CPAN

=back

=cut

