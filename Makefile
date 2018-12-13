BUILD_DIR=build
SRC_DIR=cptCython
COMPILED_DIR=compiled
TEST_DIR=testsCython

clean:
	rm -f -r ${BUILD_DIR}/
	rm -f ${SRC_DIR}/*.c
	rm -f *.so
	rm -f -r ${COMPILED_DIR}

build: clean
	python setup.py build_ext
	mv ${SRC_DIR}/*.c ${BUILD_DIR}
	mkdir ${COMPILED_DIR}
	mv ${BUILD_DIR}/lib.*/*/*.so ${COMPILED_DIR}
test: build test-without-build

test-without-build:
	python -m unittest discover -s ${TEST_DIR} -p "*.py"

deploy: build
