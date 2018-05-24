// Some common utils 
//
// by Shen Feng, May 20 2016
//

\d .util

// get time from integer format, e.g. 113020010 -> 11:30:20.010
int2time:{"T"$-9#"00000000",string x}

// convert time to integer format, e.g. 11:30:20.010 -> 113020010
time2int:{x:`time$x;`int$(1e7*`hh$x)+(1e5*`mm$x)+(1e3*`ss$x)+(`int$x mod 1e3)}

// integer to date, e.g. 20160519 -> 2016.05.19
int2date:{"D"$string x}

// date to integer, e.g. 2016.05.19 -> 20160519
date2int:{x:`date$x;`int$(1e4*`year$x)+(1e2*`mm$x)+`dd$x}

// Check if this is a hdb process
isHdb:{$[@[value;`.Q.pf;`rdb]~`date;1b;0b]}

// Check if a variable is a keyed or non-keyed table
isTable:{if[98h=type x;:1b];if[99h=type x;:98h=type key x];0b}

// Convert symbol or symbol vector to string such that it can be put in sql
// e.g., h "select from tbl where sym in ",sym2str[`if1`if2`a1`a2]
sym2str:{"(`$\"",$[1<count x;"\";`$\"" sv string x;string first x],"\")"}

// transform time to unix epoch micro secs, e.g. 2016.01.01D10:20:30.0123456 -> 1451614830012345
time2unixus:{`long$((`timestamp$x) - 1970.01.01D8) div 1000}

// unix timestamp to time
unixus2time:{`timestamp$(08:00+`datetime$-10957+x%86400000000)}

// get handle of gateway (if using TorQ)
gw:{$[0<count s:.servers.getservers[`proctype;`gateway;()!();1b;1b]`w;rand s;s]}

// hex to uint, e.g. 0xFFFF -> 65535
hex2uint:{$[0<type u:reverse "j"$x;256 sv u;u]}

// hex to int, e.g. 0xFFFF -> -32768
hex2int:{$[(u:uint[x])<threshold:"j"$(256 xexp count x)%2;u;-1+threshold-u]}

// hex (ASCII) to string, e.g. 0x3738 -> "78"
hex2str:{rtrim[$[0<type s:"c"$x;s;enlist s]]}

\d .
