@echo off
REM SIMPLE COMMAND.COM SCRIPT TO ASSEMBLE GAMEBOY FILES

if exist obj\%1.gb del obj\%1.gb

:begin
set assemble=1

echo assembling...
"C:\Users\albs_\OneDrive\Desktop\GB Dev\rgbds-0.3.9-win64\win64\rgbasm.exe" -v -iinc\ -oobj\%1.obj src\%1.asm

if errorlevel 1 goto end
echo linking...
"C:\Users\albs_\OneDrive\Desktop\GB Dev\rgbds-0.3.9-win64\win64\rgblink.exe" -mobj\map -o obj\%1.gb obj\%1.obj

if errorlevel 1 goto end
echo fixing...
"C:\Users\albs_\OneDrive\Desktop\GB Dev\rgbds-0.3.9-win64\win64\rgbfix.exe" -v -p 0xFF obj\%1.gb

:end