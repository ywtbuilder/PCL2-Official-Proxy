param([string]$AssemblyPath = 'PCLCS/bin/PCLCS.dll')

$ErrorActionPreference = 'Stop'
[Reflection.Assembly]::LoadFrom((Resolve-Path 'Plain Craft Launcher 2/Resources/Newtonsoft.Json.dll')) | Out-Null
[Reflection.Assembly]::LoadFrom((Resolve-Path $AssemblyPath)) | Out-Null

$cases = @(
    @{ Name = 'Java permanent license'; Json = '{"items":[{"name":"product_minecraft"}]}'; Expected = $true },
    @{ Name = 'Java play entitlement'; Json = '{"items":[{"name":"game_minecraft"}]}'; Expected = $true },
    @{ Name = 'No entitlement'; Json = '{"items":[]}'; Expected = $false },
    @{ Name = 'Bedrock only'; Json = '{"items":[{"name":"product_minecraft_bedrock"}]}'; Expected = $false },
    @{ Name = 'Unrelated entitlement'; Json = '{"items":[{"name":"product_other_game"}]}'; Expected = $false },
    @{ Name = 'Similar name is not a Java license'; Json = '{"items":[{"name":"product_minecraft_fake"}]}'; Expected = $false },
    @{ Name = 'Java among other entitlements'; Json = '{"items":[{"name":"product_other_game"},{"name":"game_minecraft"}]}'; Expected = $true }
)

foreach ($case in $cases) {
    $response = [Newtonsoft.Json.Linq.JObject]::Parse($case.Json)
    $actual = [PCLCS.MinecraftOwnership]::HasJavaEntitlement($response)
    if ($actual -ne $case.Expected) { throw ('Failed ownership case: ' + $case.Name) }
    Write-Output ('PASS: ' + $case.Name)
}

$launcher = [Reflection.Assembly]::LoadFrom((Resolve-Path 'Plain Craft Launcher 2/bin/Plain Craft Launcher 2.exe'))
$loginDataType = $launcher.GetType('PCL.ModLaunch+McLoginData')
$loginType = $launcher.GetType('PCL.ModLaunch+McLoginType')
$serverType = $launcher.GetType('PCL.ModLaunch+McLoginServer')
$checkLogin = $launcher.GetType('PCL.ModLaunch').GetMethod('McLoginAble', [type[]]@($loginDataType))
$legacy = [Activator]::CreateInstance($launcher.GetType('PCL.ModLaunch+McLoginLegacy'))
$legacy.UserName = 'TestPlayer'
$nide = [Activator]::CreateInstance($serverType, [object[]]@([Enum]::ToObject($loginType, 2)))
$auth = [Activator]::CreateInstance($serverType, [object[]]@([Enum]::ToObject($loginType, 3)))
foreach ($login in @($legacy, $nide, $auth)) {
    $reason = $checkLogin.Invoke($null, [object[]]@($login))
    if ([string]::IsNullOrEmpty($reason)) { throw ('Unexpectedly accepted login mode: ' + $login.Type) }
    Write-Output ('PASS: rejected unverified login mode ' + $login.Type)
}

if ($null -ne [Net.ServicePointManager]::ServerCertificateValidationCallback) {
    throw 'Launcher modified default HTTPS certificate validation.'
}
Write-Output 'PASS: default HTTPS certificate validation retained'
