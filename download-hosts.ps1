## ################################ ##
##                                  ##
##  NIKO XU 制作 @ Copyright © 2018  ##
##   https://github.com/xujun4610   ##
##                                  ##
## ################################ ##

##请使用管理员模式运行此语句！
##调试时候，请开启如下语句！
##Set-PSDebug -step

# 提升权限
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{   
    $arguments = "& '" + $myinvocation.mycommand.definition + "'"
    Start-Process powershell -Verb runAs -ArgumentList $arguments
    Break
}

Write-Host("
++++++++++++++++++++++++++++++++++++++++++++++++++

  下载最新版本hosts（HostsDownloader）
  Version 1.2

  Niko Xu Production © " + (Get-Date).Year + "

  ↓ If you like this,please visit my GitHub 
  https://github.com/xujun4610
  
  在使用了hosts之后，请您遵守当地有关的法律法规
  做一个守法爱法的好公民
  Please compliance with local laws 
  and be a good citizen.

++++++++++++++++++++++++++++++++++++++++++++++++++
");

## 设置PS为脚本运行！

if ( (Get-ExecutionPolicy).ToString().Equals("RemoteSigned") -eq $false )
{
    Write-Host "【WARN】您的系统不支持Powershell远程脚本运行！正在修改系统权限！"
    Write-Host "（*^_^*）放心,这个操作真的真的不会危害您的PC安全！！！"
    Set-ExecutionPolicy RemoteSigned CurrentUser
}


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
$original_filename = "hosts"
$file_bak = "hosts.bak"

 ###$PSScriptRoot + $filename;
$path_old_file = $env:windir + $winetc + $original_filename;
$path_bak_file = $env:windir + $winetc + $file_bak ;
$path_new_file = $filename;


$old_hosts = Get-Item $path_old_file
$new_hosts = Get-Item $path_new_file
$bak_hosts = Get-Item $path_bak_file

if ( $old_hosts.Exists -eq $true ){

    if ($bak_hosts.Exists -eq $true ){
        $old_hosts.CopyTo($bak_hosts.FullName , $true)
    }else{
        $old_hosts.CopyTo($path_bak_file, $true);
    }
    $new_hosts.CopyTo($path_old_file , $true)
    #$old_hosts.CopyTo($path_bak_file, $true);
    #$new_hosts.CopyTo($old_hosts.FullName , $true)
    # $bak_hosts.Delete($true);

}else{
    $new_hosts.CopyTo($path_old_file , $true)
} 
Write-Host "done!"
if ($new_hosts.Exists -eq  $true){
    $new_hosts.Delete();

}

Write-Host "【INFO】如果想要恢复上一个版本的hosts，请复制hosts.bak内的文本内容，粘贴至hosts文件"

ipconfig /flushdns

"【INFO】输入任意键可退出Powershell控制台。" ;
[Console]::Readkey() |　Out-Null ;
Exit ;
