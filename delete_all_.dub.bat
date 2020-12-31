@echo off

FOR /D %%f IN ( .\* ) DO (
    IF EXIST .\%%f\.dub (
        echo .\%%f\.dub
        rmdir /q /s .\%%f\.dub
    )
)
