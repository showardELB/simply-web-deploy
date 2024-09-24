$msdeploy = "C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"

# Get the input arguments
$source = $args[0]
$destination = $args[1]
$recycleApp = $args[2]
$computerName = $args[3]
$username = $args[4]
$password = $args[5]
$delete = $args[6]
$skipDirectory = $args[7]

# Build the computer name argument for MSDeploy
$computerNameArgument = "${computerName}/MsDeploy.axd?site=${recycleApp}"

# Get the current directory and prepare the content path
$directory = Split-Path -Path (Get-Location) -Parent
$contentPath = Join-Path -Path $directory -ChildPath $source

# Construct the target path for deployment
$targetPath = Join-Path -Path $recycleApp -ChildPath $destination

# Initialize MSDeploy arguments
$msdeployArguments = @(
    "-verb:sync",
    "-allowUntrusted",
    "-source:contentPath=${contentPath}",
    "-dest:contentPath=${targetPath},computerName=${computerNameArgument},username=${username},password=${password},AuthType='Basic'"
)

# Handle the deletion rule
if ($delete -ne "true") {
    $msdeployArguments += "-enableRule:DoNotDeleteRule"
}

# Handle the skip directory option
if ($skipDirectory) {
    $msdeployArguments += "-skip:Directory=${skipDirectory}"
}

# Execute the MSDeploy command with the arguments
& $msdeploy @msdeployArguments
