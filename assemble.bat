@echo off
REM SIMPLE COMMAND.COM SCRIPT TO ASSEMBLE GAMEBOY FILES

if exist obj\%2.gb del obj\%2.gb

:begin
set assemble=1
set rgbds_path=C:\Users\albs_\OneDrive\Desktop\GB Dev\rgbds-0.3.9-win64\win64\

echo assembling...
"%rgbds_path%rgbasm.exe" -v -iinc\ -oobj\%1.obj src\%1.asm

if errorlevel 1 goto end
echo linking...
"%rgbds_path%rgblink.exe" -mobj\map -o obj\%2.gb obj\%1.obj

if errorlevel 1 goto end
echo fixing...
"%rgbds_path%rgbfix.exe" -v -p 0xFF obj\%2.gb

:end