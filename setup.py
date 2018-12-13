from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

module = Extension('*', ['cptCython/*.pyx'])
module.cython_c_in_temp = True 

setup(ext_modules=cythonize(module))

