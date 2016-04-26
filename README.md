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

Some IP addresses should not be altered, e.g. 127.0.0.1 for localhost.
You must enter these IP addresses (or entire subnets in CIDR notation) directy
as arguments to `__MATCH_IP`. No placesholders (whether variables, constants or
other function calls) are allowed there. This is a limitation of the Perl module
`Net::IP::Match`. On the upside, it is damn fast.

### How to use it

This script implements a filter, i.e. it reads from STDIN and writes to STDOUT. As usual on unixoid systems.

If you use [AWStats](http://www.awstats.org/), use the following line in your `awstats-www.conf` (or whatever your AWStats configuration file is called):

````sh
LogFile="cat /var/log/apache2/access.log | /usr/local/bin/shuffle_last_octet.pl |"
````

Preferably though, you use this script to anonymize IP addresses even before your web server writes them to disk:

[Apache](https://httpd.apache.org/docs/current/logs.html#piped) allows you to filter logging data like this:

```sh
CustomLog "| /usr/local/bin/shuffle_last_octet.pl > /var/log/apache2/access.log" common
```

When using other web server software, you can create a named pipe using `mkfifo` and log to that special file (analogous to the [log rotation solution described here](https://serverfault.com/a/216961)). The same approach should work with caching servers such as [Varnish](http://go2linux.garron.me/linux/2011/05/configure-varnish-logs-varnishnsca-logrotate-and-awstats-1014/).


### Limitations

This script handles IPv4 addresses only. Patches for IPv6 most welcome.


## zero_last_octet.pl

Do not use this if you want to use the processed data in AWStats or any other log analyzer.
`zero_last_octet.pl` is the older brother of `shuffle_last_octet.pl`. Really just a
`sed` one-liner, it zeros the last octet of all IPv4 addresses. This will skew your
statistics. You have been warned.


## anycat

`anycat` is example code taken from `IO::Uncompress::AnyUncompress` which was
written by Paul Marquess, pmqs at cpan.org.

It is a generalization for `cat`, `zcat`, `bzcat`, `lzcat`, and `xzcat`, so
it can read all the compressed files you might find on a server. I include it
here because it is not contained in all distributions of
`IO::Uncompress::AnyUncompress`, and I need it in many [AWStats](http://www.awstats.org/)
configurations, namely when I have a web server that switched compression
methods during its lifetime. In these cases, I put a line like the following into
`awstats-www.conf` (or whatever your AWStats configuration file is called):

````sh
  LogFile="/usr/local/bin/anycat /var/log/apache2/access.log-%YYYY-0%MM-0%DD-0* | /usr/local/bin/shuffle_last_octet.pl |"
````

