from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize


module = Extension('*', ['cpt/*.pyx'])

setup(ext_modules=cythonize(module, annotate=True, compiler_directives={'linetrace': True}))
