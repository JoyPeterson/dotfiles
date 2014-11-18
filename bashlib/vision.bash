export et=/c/Projects/EmailTracker
export nd=/c/Projects/EmailTracker/ext/is/nexusdomain

function vsto_upd() {
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Autofac/bin/Debug/VSTOContrib.Autofac.dll $et/plugins/outlook-vision/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Autofac/bin/Debug/VSTOContrib.Autofac.pdb $et/plugins/outlook-vision/packages/VSTOContrib.Autofac.0.15.0.122/lib/net40
    cp /c/Projects/Outlook/VSTOContrib/src/VSTOContrib.Outlook/bin/Debug/VSTOContrib.*.* $et/plugins/outlook-vision/packages/VSTOContrib.Outlook.0.15.0.122/lib/net40/
}