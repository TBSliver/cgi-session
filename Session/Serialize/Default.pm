package CGI::Session::Serialize::Default;

# $Id$ 
use strict;
use Safe;
use Data::Dumper;

use vars qw($VERSION);

($VERSION) = '$Revision$' =~ m/Revision:\s*(\S+)/;


sub freeze {
    my ($self, $data) = @_;
    
    local $Data::Dumper::Indent   = 0;
    local $Data::Dumper::Purity   = 1;
    local $Data::Dumper::Useqq    = 0;
    local $Data::Dumper::Deepcopy = 1;
    local $Data::Dumper::Terse    = 0;
    local $Data::Dumper::Quotekeys= 0;
    local $Data::Dumper::Maxdepth = 5;

    
    my $d = new Data::Dumper([$data], ["D"]);
    return $d->Dump();    
}



sub thaw {
    my ($self, $string) = @_;    

    # To make -T happy
    my ($safe_string) = $string =~ m/^(.*)$/;
    
    my $D = undef;
    $D = eval ("$safe_string");
    if ( $@ ) {
        die $@;
    }

    return $D;
}


1;

=pod

=head1 NAME

CGI::Session::Serialize::Default - default serializer for CGI::Session

=head1 DESCRIPTION

This library is used by CGI::Session driver to serialize session data before storing
it in disk. 

=head1 METHODS

=over 4

=item freeze()

receives two arguments. First is the CGI::Session driver object, the second is the data to be
stored passed as a reference to a hash. Should return true to indicate success, undef otherwise, 
passing the error message with as much details as possible to $self->error()

=item thaw()

receives two arguments. First being CGI::Session driver object, the second is the string
to be deserialized. Should return deserialized data structure to indicate successs. undef otherwise,
passing the error message with as much details as possible to $self->error().

=back

=head1 WARNING

If you want to be able to store objects, consider using L<CGI::Session::Serialize::Storable> or
L<CGI::Session::Serialize::FreezeThaw> instead.

=head1 COPYRIGHT

Copyright (C) 2002 Sherzod Ruzmetov. All rights reserved.

This library is free software. It can be distributed under the same terms as Perl itself. 

=head1 AUTHOR

Sherzod Ruzmetov <sherzodr@cpan.org>

All bug reports should be directed to Sherzod Ruzmetov <sherzodr@cpan.org>. 

=head1 SEE ALSO

L<CGI::Session>
L<CGI::Session::Serialize::Storable>
L<CGI::Session::Serialize::FreezeThaw>

=cut
