import setuptools
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
# import sys


module = Extension('*',
        ['cpt/*.pyx'],
        extra_compile_args=['-fopenmp', '-std=c++11'],
        extra_link_args=['-fopenmp', '-std=c++11'])

setup(name="cpt",
      ext_modules=cythonize(module, annotate=False),
      # compiler_directives={
      #                       'linetrace': True,
      #                          'language_level': sys.version_info[0]
      #                     }),
      version="0.0.7")
