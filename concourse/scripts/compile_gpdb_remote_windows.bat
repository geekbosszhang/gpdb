@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
@echo on
cd %WORK_DIR%\gpdb_src\src\tools\msvc
echo "our $config = {gss => 'C:/ext', openssl => 'c:/ext', zlib => 'c:/ext'};"  >config.pl

perl build.pl client
perl install.pl %WORK_DIR%\greenplum-db-devel client

REM build gpfdist
cd %WORK_DIR%\gpdb_src\src\bin\gpfdist
mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH:PATH=C:\ext -DCMAKE_INSTALL_PREFIX:PATH=%WORK_DIR%\greenplum-db-devel -G "Visual Studio 15 2017 Win64" ..
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL

REM build pygresql
cd %WORK_DIR%\gpdb_src\gpMgmt\bin\pythonSrc\PyGreSQL-4.0
mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH=%WORK_DIR%\greenplum-db-devel -DCMAKE_INSTALL_PREFIX:PATH=%WORK_DIR%\greenplum-db-devel -G "Visual Studio 15 2017 Win64" ..
cmake --build . --config Release --target ALL_BUILD
cmake --build . --config Release --target INSTALL

REM create msi package
cd %WORK_DIR%\gpdb_src\gpAux\client\install\src\windows\
@call CopyDependencies.bat C:\ext %WORK_DIR%\greenplum-db-devel
@call CreatePackage.bat %WORK_DIR%\greenplum-db-devel %GPDB_VERSION%

move *.msi %WORK_DIR%

