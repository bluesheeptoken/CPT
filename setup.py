from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import sys


module = Extension('*',
        ['cpt/*.pyx'],
        extra_compile_args=['-fopenmp'],
        extra_link_args=['-fopenmp'])

setup(ext_modules=cythonize(module,
                            annotate=True,
                            compiler_directives={
                                'linetrace': True,
                                'language_level': sys.version_info[0]
                            }))
