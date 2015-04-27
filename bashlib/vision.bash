export et=/c/Projects/EmailTracker
export nd=/c/Projects/EmailTracker/ext/is/nexusdomain

function vsto_upd() {
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Autofac/bin/Debug/VSTOContrib.Autofac.dll $et/plugins/outlook-vision/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Autofac/bin/Debug/VSTOContrib.Autofac.pdb $et/plugins/outlook-vision/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Outlook/bin/Debug/VSTOContrib.*.* $et/plugins/outlook-vision/packages/VSTOContrib.Outlook.0.15.0.122/lib/net40/
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
function coverage() {
	pushd $et/plugins/outlook-vision/build
	p ./BuildIt.ps1 -target 'Coverage'
	start $et/plugins/outlook-vision/build/Reports/CodeCoverage/index.htm
	popd
}