@echo off
REM copy recursively; /E copies all subdirs, /I assumes destination is directory
mkdir tmp_for_test
xcopy /E /I {project}\tests tmp_for_test\tests
pytest tmp_for_test/tests
