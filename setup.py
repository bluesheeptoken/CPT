from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize


module = Extension('*',
        ['cpt/*.pyx'],
        extra_compile_args=['-fopenmp'],
        extra_link_args=['-fopenmp'])

setup(ext_modules=cythonize(module, annotate=True, compiler_directives={'linetrace': True}))
