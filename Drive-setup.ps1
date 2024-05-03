# Assign drive name
$driveLetter = "M:"
# Assign the path for the shared folder
$sharedFolderPath = "$driveLetter\data"
# Create directories
$directories = @(
    "M:\data\media\movies"
    "M:\data\media\shows"
    "M:\data\torrents\movies"
    "M:\data\torrents\shows"
    "M:\data\usenet\incomplete"
    "M:\data\usenet\complete\movies"
    "M:\data\usenet\complete\shows"
)
foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force
}
# Share "M:\data"
New-SmbShare -Name "Data" -Path $sharedFolderPath -FullAccess "Everyone"

# Set directory permissions: M:\data\ Everyone has FULL Access
$topLevelDirectory = "M:\data\"
$acl = Get-Acl -Path $topLevelDirectory
$permission = "Everyone", "FullControl", "Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission)
$acl.AddAccessRule($accessRule)
Set-Acl -Path $topLevelDirectory -AclObject $acl
Get-ChildItem -Path $topLevelDirectory -Recurse | ForEach-Object {
    Set-Acl -Path $_.FullName -AclObject $acl
}