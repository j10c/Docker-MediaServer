# Assign drive name
$driveLetter = "D:"
# Assign the path for the shared folder
$sharedFolderPath = "$driveLetter\data"
# Create directories
$directories = @(
    "D:\data\media\movies"
    "D:\data\media\shows"
    "D:\data\torrents\movies"
    "D:\data\torrents\shows"
    "D:\data\nzbget\incomplete"
    "D:\data\nzbget\complete\movies"
    "D:\data\nzbget\complete\shows"
)
foreach ($dir in $directories) {
    New-Item -ItemType Directory -Path $dir -Force
}
# Share "M:\data"
New-SmbShare -Name "Data" -Path $sharedFolderPath -FullAccess "Everyone"

# Set directory permissions: M:\data\ Everyone has FULL Access
$topLevelDirectory = "D:\data\"
$acl = Get-Acl -Path $topLevelDirectory
$permission = "Everyone", "FullControl", "Allow"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule($permission)
$acl.AddAccessRule($accessRule)
Set-Acl -Path $topLevelDirectory -AclObject $acl
Get-ChildItem -Path $topLevelDirectory -Recurse | ForEach-Object {
    Set-Acl -Path $_.FullName -AclObject $acl
}