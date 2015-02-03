export et=/c/Projects/EmailTracker
export nd=/c/Projects/EmailTracker/ext/is/nexusdomain

function vsto_upd() {
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Autofac/bin/Debug/VSTOContrib.Autofac.dll $et/plugins/outlook-vision/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Autofac/bin/Debug/VSTOContrib.Autofac.pdb $et/plugins/outlook-vision/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Outlook/bin/Debug/VSTOContrib.*.* $et/plugins/outlook-vision/packages/VSTOContrib.Outlook.0.15.0.122/lib/net40/
}

# Copy modifiedfiles from an ihance repository to the ihance VM
function cp_vision() {
	src=$(pwd)
	target=${src/\/c\/Projects\/ihance/\/s}

	git st | \
	awk -v src=$src -v target=$target \
		'{printf "cp -v \"%s/%s\" \"%s/%s\"", src, $2, target, $2}' | sh
}

# Copy ihance DLLs from the ihance VM to the local web repository
function cp_web_bin() {
	pushd /c/Projects/ihance/web > /dev/null
	cp -v /s/web/appserver/site/bin/Ihance.dll appserver/site/bin/
	cp -v /s/web/appserver/site/bin/Ihance.pdb appserver/site/bin/
	cp -v /s/web/logger/site/bin/Ihance.dll logger/site/bin/
	cp -v /s/web/logger/site/bin/Ihance.pdb logger/site/bin/
	cp -v /s/web/src/bin/Ihance.dll src/bin/
	cp -v /s/web/src/bin/Ihance.pdb src/bin/
	cp -v /s/web/website/site/bin/Ihance.dll website/site/bin/
	cp -v /s/web/website/site/bin/Ihance.pdb website/site/bin/
	popd > /dev/nu
}