## ################################ ##
##                                  ##
##  NIKO XU 制作 @ Copyright © 2018  ##
##   https://github.com/xujun4610   ##
##                                  ##
## ################################ ##

##请使用管理员模式运行此语句！
##调试时候，请开启如下语句！
##Set-PSDebug -step

## 设置PS为脚本运行！
Write-Host "您的系统不支持Powershell远程脚本运行！正在修改系统权限！"
Write-Host "（*^_^*）放心,这个操作真的真的不会危害您的PC安全！！！"
Set-ExecutionPolicy RemoteSigned CurrentUser

#### get web content
$webclient = New-Object System.Net.WebClient
# $encoding = New-Object System.Text.Encoding
$webclient.Encoding =  [System.Text.Encoding]::UTF8
$url = "https://raw.githubusercontent.com/googlehosts/hosts/master/hosts-files/hosts";
$filename =  $env:windir + "\System32\drivers\etc\" + "hosts.new";
Write-Host "Downloading, please wait!"
$webclient.DownloadFile($url, $filename);

#### copy file
$winetc = "\System32\drivers\etc\"
$filename = "hosts"
$file_bak = "hosts.bak"

$path_dl_file = $env:windir + $winetc + "hosts.new";  ###$PSScriptRoot + $filename;
$path_old_file = $env:windir + $winetc + $filename;
$path_bak_file = $env:windir + $winetc + $file_bak ;
$path_new_file = $env:windir + $winetc + "hosts.new";

$host_file = Get-Item $path_dl_file
if ( $host_file.Exists -eq $true ){
    $old_hosts = Get-Item $path_old_file
    $new_hosts = Get-Item $path_new_file
    #$bak_hosts = Get-Item $path_bak_file
    if ($bak_hosts.Exists  -eq $true ){
        $bak_hosts.Delete($true);
    }
    $old_hosts.CopyTo($path_bak_file, $true);
    #$new_hosts.Replace($old_hosts.FullName , $true)
} 
Write-Host "done!"
$host_file.Delete();

Write-Host "如果想要恢复上一个版本的hosts，请复制hosts.bak内的文本内容，粘贴至hosts文件"

ipconfig /flushdns