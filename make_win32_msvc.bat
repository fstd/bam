@echo off

@REM check if we already have the tools in the environment
if exist "%VCINSTALLDIR%" (
	goto compile
)

@REM Check for Visual Studio
if exist "%VS120COMNTOOLS%" (
	set VSPATH="%VS120COMNTOOLS%"
	goto set_env
)
if exist "%VS110COMNTOOLS%" (
	set VSPATH="%VS110COMNTOOLS%"
	goto set_env
)
if exist "%VS100COMNTOOLS%" (
	set VSPATH="%VS100COMNTOOLS%"
	goto set_env
)
if exist "%VS90COMNTOOLS%" (
	set VSPATH="%VS90COMNTOOLS%"
	goto set_env
)
if exist "%VS80COMNTOOLS%" (
	set VSPATH="%VS80COMNTOOLS%"
	goto set_env
)

echo You need Microsoft Visual Studio 8, 9, 10, 11 or 12 installed
pause
exit

@ setup the environment
:set_env
call %VSPATH%vsvars32.bat

:compile
@echo === building bam ===
@cl /D_CRT_SECURE_NO_DEPRECATE /O2 /nologo src/tools/txt2c.c /Fesrc/tools/txt2c.exe
@src\tools\txt2c src/base.lua src/tools.lua src/driver_gcc.lua src/driver_clang.lua src/driver_cl.lua > src\internal_base.h

@REM /DLUA_BUILD_AS_DLL = export lua functions
@REM /W3 = Warning level 3
@REM /Ox = max optimizations
@REM /TC = compile as c
@REM /Zi = generate debug database
@REM /GS- = no stack checks
@REM /GL = Whole program optimization (ltcg)
@REM /LTCG = link time code generation
@cl /D_CRT_SECURE_NO_DEPRECATE /DLUA_BUILD_AS_DLL /W3 /O2 /TC /Zi /GS- /GL /nologo /I src/lua src/*.c src/lua/*.c /Febam.exe /link Advapi32.lib /LTCG

@REM clean up
@del bam.exp
@del *.obj

