#Simple product key implementation.
#Written by Cody Crow.
#Licensed under MIT License.
package yearbooks;
use Dancer2;

use DBI;
use v5.18;
our $VERSION = '0.01';
use Dancer2::Plugin::REST;
use Dancer2::Serializer::JSON;
set serializer => 'JSON';

my $dsn = "DBI:mysql:database=yearbooks;host=localhost;port=3306";
my $dbh = DBI->connect($dsn, "root", "");

sub _validate;
sub _in_use;
sub _register_keys;
sub _used;

post '/product_key' => sub {
        #say _validate(params->{key});
        #return [params->{key}];
        my $key = params->{key};
        status 403;
        return unless $key;
        return unless _in_use $key;
        return unless !_used $key;

        my $sth = $dbh->prepare("UPDATE `product_keys` SET `used` = '1' WHERE `key` = ?;");
        $sth->bind_param(1, $key);
        $sth->execute;

        status_accepted;
};

#Takes in form data of the form "range: Z", where Z is any integer.
post '/generate_keys' => sub {
        my $range = params->{range};
        my @keys;
        for my $i (1000000 .. 9999999) {
                if (_validate $i) {
                        push @keys, $i unless _in_use $i;
                }

                if (scalar @keys >= $range) {
                        last;
                }
        }

        _register_keys @keys;

        content_type 'application/json';
        status_created [@keys];
};

#Validates potential product keys using the Luhn mod 10 algorithm, with the
#assumption that the check digit is 7.
#Luhn mod 10 is described in ISO 7812.
sub _validate {
        my @rev = reverse split //,$_[0];
        my ($sum1,$sum2,$i) = (0,0,0);

        for(my $i = 0; $i < @rev; $i += 2) {
                $sum1 += $rev[$i];
                last if $i == $#rev;
                $sum2 += 2 * $rev[$i + 1] % 10 + int(2 * $rev[$i + 1] / 10);
        }
        return ($sum1 + $sum2) % 10 == 7;
}

#Checks if a key has already been registered.
sub _in_use {
        my $key = shift;
        my $sth = $dbh->prepare("SELECT COUNT(*) FROM `product_keys` WHERE `key` = ?;");
        $sth->bind_param(1, $key);
        $sth->execute;
        my @row = $sth->fetchrow_array;
        return $row[0];
}

sub _used {
        my $key = shift;
        my $sth = $dbh->prepare("SELECT COUNT(*) FROM `product_keys` WHERE `key` = ? && `used` = 1;");
        $sth->bind_param(1, $key);
        $sth->execute;
        my @row = $sth->fetchrow_array;
        return $row[0];
}

sub _register_keys {
        for (@_) {
                my $sth = $dbh->prepare("INSERT INTO `product_keys` (`key`, `used`) VALUES (?, 0);");
        	$sth->bind_param(1, $_);
	        $sth->execute;
        }
}

true;
