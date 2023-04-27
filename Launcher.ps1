function Set-AppOptionTitle {
    param (
	[string]$title
    )
    $AppOptions.Title = $title
}

function Get-Port {
    $PortToUse = 4460 .. 4480 | Get-Random

    $UsedPorts = Get-NetTCPConnection | Where-Object {$_.LocalPort -match '^44..$'} | Select-Object LocalPort

    if ($PortToUse -in $UsedPorts) { 
	Get-Port
    }
    
    Write-Host "Port $PortToUse"
    return $PortToUse
}

[Terminal.Gui.Application]::Init()
$Window 	= [Terminal.Gui.Window]::New()
$Window.Title 	= "PowerShell AWS"

$MenuItem 	= [Terminal.Gui.MenuItem]::New("_Exit", "Here is how you exit the app", {[Terminal.Gui.Application]::ShutDown()})
$MenuOption 	= [Terminal.Gui.MenuBarItem]::New("Boo", @($MenuItem))
$TopMenu 	= [Terminal.Gui.MenuBar]::New(@($MenuOption))
$Window.Add($TopMenu)


$AppMenu 	= [Terminal.Gui.FrameView]::New()
$AppMenu.Width 	= [Terminal.Gui.Dim]::Percent(25)
$AppMenu.Height = ([Terminal.Gui.Dim]::Fill() - 1)
$AppMenu.Y 	= 1
$AppMenu.Title 	= "AWS Resource"
#$AppMenu.Border.BorderStyle = "None"
$Window.Add($AppMenu)

$AppOptions 	   = [Terminal.Gui.FrameView]::New()
$AppOptions.Width  = [Terminal.Gui.Dim]::Fill()
$AppOptions.Height = 20
$AppOptions.Y 	   = 1
$AppOptions.X 	   = [Terminal.Gui.Pos]::Right($AppMenu)
#Populate when a resource is selected to "Resource Name Options - ie "s3 Options""
#$AppOptions.Title  = ""
$Window.Add($AppOptions)

$AppResults 	   = [Terminal.Gui.FrameView]::New()
$AppResults.Width  = [Terminal.Gui.Dim]::fILL()
$AppResults.Height = ([Terminal.Gui.Dim]::Fill() - 1)
$AppResults.X 	   = [Terminal.Gui.Pos]::Right($AppMenu)
$AppResults.Y 	   = [Terminal.Gui.Pos]::Bottom($AppOptions)
#Populate when there are results
#$AppResults.Title  = "App Results"
$Window.Add($AppResults)


$Footer = [Terminal.Gui.FrameView]::New()
$Footer.Width = [Terminal.Gui.Dim]::Fill()
$Footer.Height = 2
$Footer.Y = [Terminal.Gui.Pos]::Bottom($AppMenu)
$Window.Add($Footer)

#AppMenuOptions
$AppOne = [Terminal.Gui.Button]::New()
$AppOne.Text = "Hello World"
$AppOne.Add_Clicked({
    Set-AppOptionTitle "Testing"
    $OpenPort = Get-Port
})
$AppMenu.Add($AppOne)

[Terminal.Gui.Application]::Top.Add($Window)
[Terminal.Gui.Application]::Run()
