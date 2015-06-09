# Some tools for using AWStats in accordance with EU privacy laws

## shuffle_last_octet.pl

### What it does

  `shuffle_last_octet.pl` is a Unix filter (a command-line program which reads
  from the standard input stream and writes to the standard output stream)
  which expects IP addresses in dotted quad notation in the first column of the
  data stream. It shuffles the rightmost quad consistently so that web log
  analyzsers such as AWStats can still generate meaningful statistics although
  the real IP address of visitors is not disclosed.

### Customizing

Some IP address should not be altered, e.g. 127.0.0.1 for localhost.
You must enter these IP addresses (or entire subnets in CIDR notation) directy
as arguments to __MATCH_IP. No placesholders (whether variables, constants or
other function calls) are allowed there. This is a limitation of the Perl module
`Net::IP::Match`. On the upside, it is damn fast.