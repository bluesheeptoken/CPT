BUILD_DIR=build
SRC_DIR=cpt
TEST_DIR=tests
REPORTS_DIR=reports
COVERAGE_DIR=htmlcov

DEBUG=false

ifeq ($(DEBUG), true)
  trace_flag=--define CYTHON_TRACE
endif

build: cpt/*.pyx
	python3 setup.py build_ext --inplace ${trace_flag}
	mkdir -p ${REPORTS_DIR}
	mv ${SRC_DIR}/*.html ${REPORTS_DIR}

clean:
	rm -rf ${BUILD_DIR}/
	rm -f ${SRC_DIR}/*.c
	rm -f ${SRC_DIR}/*.so
	rm -f ${SRC_DIR}/*.h
	rm -f ${SRC_DIR}/*.cpp
	rm -rf ${REPORTS_DIR}
	rm -rf ${COVERAGE_DIR}

lint:
	pylint ${TEST_DIR}
	pycodestyle ${TEST_DIR}
	pylint profiling/profiling.py
	pycodestyle profiling/profiling.py --ignore=E402
	pylint tests_scripts
	pycodestyle tests_scripts
	pylint data/generate_metadata.py
	pycodestyle data/generate_metadata.py

test: build
	pytest
	pytest tests_scripts
