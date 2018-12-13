BUILD_DIR=build
SRC_DIR=cptCython
COMPILED_DIR=compiled
TEST_DIR=testsCython
REPORTS_DIR=reports

clean:
	rm -f -r ${BUILD_DIR}/
	rm -f ${SRC_DIR}/*.c
	find . -name "*.so" -exec rm {} \;
	find . -name "*.html" -exec rm {} \;
	find . -name "*.c" -exec rm {} \;
	rm -f -r ${COMPILED_DIR}
	rm -f -r ${REPORTS_DIR}

build: clean
	python setup.py build_ext
	mv ${SRC_DIR}/*.c ${BUILD_DIR}
	mkdir ${REPORTS_DIR}
	mv ${SRC_DIR}/*.html ${REPORTS_DIR}

test: build test-without-build

test-without-build:
	python -m unittest discover -s ${TEST_DIR} -p "*.py"

deploy: build
