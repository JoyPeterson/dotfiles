export et=/c/Projects/EmailTracker
export nd=/c/Projects/EmailTracker/ext/is/nexusdomain

function vsto_upd() {
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Autofac/bin/Debug/VSTOContrib.Autofac.dll $et/plugins/outlook-vision/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Autofac/bin/Debug/VSTOContrib.Autofac.pdb $et/plugins/outlook-vision/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Outlook/bin/Debug/VSTOContrib.*.* $et/plugins/outlook-vision/packages/VSTOContrib.Outlook.0.15.0.122/lib/net40/
}

function gelf_upd() {
    cp /c/Projects/github/NLog.GelfLayout/src/NLog.Layouts.GelfLayout/bin/Release/NLog.Layouts.GelfLayout.dll $et/plugins/outlook-vision/packages/NLog.GelfLayout.0.2.5492.28842/lib/net45
}

# Compile the vision binaries on the VM
function compile_vision() {
	ssh Administrator@jpeterson-ihanc "cd /c/src/source_home/web && src/compile.bash src"
}

# Copy modified files from an ihance VM to the local repository folder.
function cp_vision() {
	remote_folder=$1
	if [ "$remote_folder" != "web" ] && [ "$remote_folder" != "sit" ] && [ "$remote_folder" != "lib" ]; then
		echo "Usage: cp_vision (web|sit|lib)"
		return
	fi
	local_folder="IH${remote_folder}"
	ssh Administrator@jpeterson-ihanc "cd /c/src/source_home/$remote_folder && git st" \
	| awk '{printf "--include \"%s\" ", $2}' \
	| awk -v remote_folder=$remote_folder -v local_folder=$local_folder \
	  '{printf "rsync -amv %s--include \"*/\" --exclude=\"*\" \
	  Administrator@jpeterson-ihanc:/c/src/source_home/%s/ \
	  /c/Projects/ihance/%s/", \
	  $0, remote_folder, local_folder}' \
	| sh \
	| grep -v /$ # Do not display directory names.
}


# Run code coverage analysis for Outlook Plugin.
# $1 (optional) - Limits which tests are executed to a given Namespace or Class.
function coverage() {
	fixture=$1
	pushd $et/plugins/outlook-vision/build
	p ./BuildIt.ps1 -target 'Coverage' -test_fixture $fixture
	start $et/plugins/outlook-vision/build/Reports/CodeCoverage/index.htm
	popd
}


function cp_vision_config() {
	env=$1
	cp $et/plugins/outlook-vision/build/service.config_$env $APPDATA/Vision/service.config
}

function alpha() {
	cp_vision_config "alpha"
}

function beta() {
	cp_vision_config "beta"
}

function prod() {
	cp_vision_config "production"
}

function cp_MacTools() {
	pushd $et/tools/MacServerTools/MacTools/bin
	MACTOOLS_FILE=MacTools.tar.gz
	rm -rf $MACTOOLS_FILE
	rm -rf MacTools
	mkdir MacTools
	cp -r Release/* MacTools/
	cp ../deploy/* MacTools/
	rm -f MacTools/*.xml MacTools/*.pdb
	tar -czf $MACTOOLS_FILE MacTools
	rm -rf MacTools
	# Use unaliased version of cp so that we can overwrite the file silently
	\cp -fv $MACTOOLS_FILE \\\\hal\\IS.Share\\Employees\\jpeterson\\
	popd
}