# Some tools for using AWStats in accordance with EU privacy laws

* `shuffle_last_octet.pl` is a Unix filter (a command-line program which reads
  from the standard input stream and writes to the standard output stream)
  which expects IP addresses in dotted quad notation in the first column of the
  data stream. It shuffles the rightmost quad consistently so that web log
  analyzsers such as AWStats can still generate meaningful statistics although
  the real IP address of visitors is not disclosed.
