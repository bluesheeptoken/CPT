BUILD_DIR=build
SRC_DIR=cptCython
TEST_DIR=testsCython
REPORTS_DIR=reports

build: cptCython/*.pyx
	python3 setup.py build_ext
	mkdir -p ${REPORTS_DIR}
	cp ${SRC_DIR}/*.html ${REPORTS_DIR}

test: build
	python3 -m unittest discover -s ${TEST_DIR} -p "*.py"

clean:
	rm -rf ${BUILD_DIR}/
	rm -f ${SRC_DIR}/*.c
	find . -name "*.so" -exec rm {} \;
	find . -name "*.html" -exec rm {} \;
	find . -name "*.c" -exec rm {} \;
	rm -rf ${REPORTS_DIR}
