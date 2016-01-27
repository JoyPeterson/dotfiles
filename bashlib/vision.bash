export projects=/c/Projects

function vsto_upd() {
    cp $projects/github/VSTOContrib/src/VSTOContrib.Autofac/bin/Release/VSTOContrib.Autofac.dll $projects/outlook-plugin/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp $projects/github/VSTOContrib/src/VSTOContrib.Autofac/bin/Release/VSTOContrib.Autofac.pdb $projects/outlook-plugin/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp $projects/github/VSTOContrib/src/VSTOContrib.Outlook/bin/Release/VSTOContrib.*.* $projects/outlook-plugin/packages/VSTOContrib.Outlook.0.15.0.122/lib/net40/
}

function gelf_upd() {
    cp $projects/github/NLog.GelfLayout/src/NLog.Layouts.GelfLayout/bin/Release/NLog.Layouts.GelfLayout.dll $projects/outlook-plugin/packages/NLog.GelfLayout.0.2.5492.28842/lib/net45
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
	start_dir=$(pwd)
	cd $projects/outlook-plugin/build
	if [ -n "$fixture" ]; then
		p ./BuildIt.ps1 -target 'Coverage' -test_fixture $fixture
	else
		p ./BuildIt.ps1 -target 'Coverage'
	fi

	start $projects/outlook-plugin/build/Reports/CodeCoverage/index.htm
	cd $start_dir
}


function cp_vision_config() {
	env=$1
	cp $projects/outlook-plugin/build/service.config_$env $APPDATA/Vision/service.config
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
	pushd $projects/mac-tools/MacTools/bin
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