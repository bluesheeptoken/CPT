import setuptools
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import sys
import platform

if platform.system() == 'Windows':
    compile_args = ['/openmp']
else:
    compile_args = ['-fopenmp', '-std=c++11']


module = Extension('*',
        ['cpt/*.pyx'],
        extra_compile_args=compile_args,
        extra_link_args=compile_args)

version = "0.0.8"

author = "Bluesheeptoken"
author_email = "louis.fruleux1@gmail.com"

description = "Compact Prediction Tree: A Lossless Model for Accurate Sequence Prediction (cython implementation) "

license = "MIT"

setup(name="cpt",
      ext_modules=cythonize(
        module,
        annotate=False,
        compiler_directives={'language_level': sys.version_info[0]}),
      version=version,
      author=author,
      author_email=author_email,
      description=description,
      license=license)
