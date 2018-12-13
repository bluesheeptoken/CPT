from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize

cpp_source_files=[]
module = Extension('*', ['cptCython/*.pyx'] + cpp_source_files)
module.cython_c_in_temp = True 

setup(ext_modules=cythonize(module,annotate=True))

