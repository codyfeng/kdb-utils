// Track active connections and limit the number of connections
//
// by Shen Feng, Jul 26 2017
//
// max_connections - max cocurrent connections from the same IP address
// white_list - list of IP addresses to ignore
// 
// Reference: https://github.com/AquaQAnalytics/TorQ/blob/master/code/handlers/trackclients.q
//

\d .connections

enabled:@[value;`enabled;1b]
max_connections:@[value;`max_connections;5]
white_list:@[value; `white_list; `]

// Table to track connections
connections:@[value;`connections;([w:`int$()]ip:`symbol$();u:`symbol$();a:`int$();startp:`timestamp$();lastp:`timestamp$())]

// close the earlist connection from the same IP address if connection count exceeds max_connections
check_max_connections:{
    { if[.connections.max_connections < x[`c];
        hclose each W:exec w from .connections.connections where lastp = x[`lastp];
        delete from `.connections.connections where w in W;
        -1 "too many connections from ",(string x[`ip]),", closing the earlist one" ]
    } each 0!select min lastp, c:count i by ip from .connections.connections where w>2, not ip in .connections.white_list;
  }
hit:{update lastp:.z.P from`.connections.connections where w=.z.w}
po:{[result;W]
    `.connections.connections upsert(W;`$"."sv string"i"$0x0 vs .z.a;.z.u;.z.a;.z.P;.z.P);
    check_max_connections[]; result
  }
pc:{[result;W] delete from `.connections.connections where w=W;result}

// Override kdb+ handlers
// Reference: https://github.com/simongarland/dotz/blob/master/dotz.q
if[enabled;
    .z.po:{.connections.po[x y;y]}@[value;`.z.po;{;}];
    .z.wo:{.connections.po[x y;y]}@[value;`.z.wo;{;}];
    .z.pc:{.connections.pc[x y;y]}@[value;`.z.pc;{;}];
    .z.wc:{.connections.pc[x y;y]}@[value;`.z.wc;{;}];
    .z.pg:{.connections.hit[];@[x;y]}@[value;`.z.pg;{.:}];
    .z.ps:{.connections.hit[];@[x;y]}@[value;`.z.ps;{.:}];
    .z.ws:{.connections.hit[];@[x;y]}@[value;`.z.ws;{{neg[.z.w]x;}}]; / default is echo
  ];

\d .
