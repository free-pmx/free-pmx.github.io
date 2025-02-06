#!/usr/bin/perl -pi.bak

# MAINTAINED: <https://free-pmx.github.io/snippets/pve-no-nag/pve-no-nag.pl>
# MAN PAGE: <https://free-pmx.github.io/snippets/pve-no-nag/pve-no-nag.1.roff>
# REPORT BUGS: <https://github.com/free-pmx/>
# LICENSE: GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.

use strict;
use warnings;

# original
my $o = quotemeta << 'EOF';
    checked_command: function(orig_cmd) {
	Proxmox.Utils.API2Request(
	    {
		url: '/nodes/localhost/subscription',
		method: 'GET',
		failure: function(response, opts) {
		    Ext.Msg.alert(gettext('Error'), response.htmlStatus);
		},
		success: function(response, opts) {
		    let res = response.result;
		    if (res === null || res === undefined || !res || res
			.data.status.toLowerCase() !== 'active') {
			Ext.Msg.show({
			    title: gettext('No valid subscription'),
			    icon: Ext.Msg.WARNING,
			    message: Proxmox.Utils.getNoSubKeyHtml(res.data.url),
			    buttons: Ext.Msg.OK,
			    callback: function(btn) {
				if (btn !== 'ok') {
				    return;
				}
				orig_cmd();
			    },
			});
		    } else {
			orig_cmd();
		    }
		},
	    },
	);
    },
EOF

# replacement
my $r = << 'EOF';
    checked_command: function(orig_cmd) {
	Proxmox.Utils.API2Request(
	    {
		url: '/nodes/localhost/subscription',
		method: 'GET',
		failure: function(response, opts) {
		    Ext.Msg.alert(gettext('Error'), response.htmlStatus);
		},
		success: function(response, opts) {
			orig_cmd();
		},
	    },
	);
    },
EOF

BEGIN { undef $/; } s/$o/$r/;
