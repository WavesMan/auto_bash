@echo off

:: ����Ƿ��Թ���Ա�������
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo �����������ԱȨ��...
    goto UACPrompt
) else (
    goto gotAdmin
)

:UACPrompt
:: ����һ����ʱ VBScript �ļ�������Ȩ��
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
:: ִ�� VBScript ����Ȩ��
"%temp%\getadmin.vbs"
:: ɾ����ʱ VBScript �ļ�
del /f /q "%temp%\getadmin.vbs"
exit /B

:gotAdmin
:: ����ԱȨ���ѻ�ã�����ִ����������
echo �ѳɹ���ù���ԱȨ�ޡ�
pause

:: �ṩ����ѡ��
echo ��ѡ��Ҫִ�еĲ�����
echo 1. ��ͣWindows�Զ�����
echo 2. ȡ����ͣWindows�Զ�����
set /p choice=������ѡ�� (1 �� 2): 

:: �ж�ѡ��
if '%choice%' EQU '1' goto Update
if '%choice%' EQU '2' goto Un_Update
echo ��Ч��ѡ����������нű���
pause
exit /B

:Update
:: ��ͣWindows�Զ�����
echo ������ͣWindows�Զ�����...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "FlightSettingsMaxPauseDays" /t REG_DWORD /d 7000 /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseFeatureUpdatesStartTime" /t REG_SZ /d "2023-07-07T10:00:52Z" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseFeatureUpdatesEndTime" /t REG_SZ /d "2050-01-01T00:00:00Z" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseQualityUpdatesStartTime" /t REG_SZ /d "2023-07-07T10:00:52Z" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseQualityUpdatesEndTime" /t REG_SZ /d "2050-01-01T00:00:00Z" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseUpdatesStartTime" /t REG_SZ /d "2023-07-07T09:59:52Z" /f
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseUpdatesExpiryTime" /t REG_SZ /d "2050-01-01T00:00:00Z" /f
echo Windows�Զ���������ͣ��2050-01-01��
pause
exit /B

:Un_Update
:: ȡ����ͣWindows�Զ�����
echo ����ȡ����ͣWindows�Զ�����...
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "FlightSettingsMaxPauseDays" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseFeatureUpdatesStartTime" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseFeatureUpdatesEndTime" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseQualityUpdatesStartTime" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseQualityUpdatesEndTime" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseUpdatesStartTime" /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v "PauseUpdatesExpiryTime" /f
echo Windows�Զ�������ȡ����ͣ��
pause
exit /B