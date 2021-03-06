param($cmd, $theme)

. "$psscriptroot\..\lib\core.ps1"
. "$psscriptroot\..\lib\prompt.ps1"
. "$psscriptroot\..\lib\completion.ps1"
. "$psscriptroot\..\lib\theme.ps1"
. "$psscriptroot\..\lib\plugin.ps1"

$usage = "usage: pshazz init [theme]"

function init($theme_name) {
	$theme = theme $theme_name

	if(!$theme) {
		"ERROR: couldn't load theme '$theme_name' in $themedir"

		# try reverting to default theme
		if($theme_name -ne 'default') { $theme = theme 'default' }
		else { exit 1 } # already tried loading default theme, abort
	}

	$global:pshazz = @{ }
	$pshazz.theme = $theme
	$pshazz.completions = @{ }

	$theme.plugins | % {
		plugin:init $_
	}
}

if(!$cmd) { "pshazz: cmd missing"; $usage; exit 1 }

switch($cmd) {
	"init" {
		if(!$theme) { $theme = 'default' }
		init $theme
	}
	default: {
		"pshazz: unknown command: $cmd"; $usage; exit 1
	}
}