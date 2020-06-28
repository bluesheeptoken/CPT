import setuptools
from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import sys
import platform
from os import path


if platform.system() == "Windows":
    compile_args = ["/openmp"]
elif platform.system() == "Darwin":
    compile_args = ["-fopenmp"]
else:
    compile_args = ["-fopenmp", "-std=c++11"]

module = Extension(
    name="*",
    sources=["cpt/*.pyx"],
    extra_compile_args=compile_args,
    extra_link_args=compile_args,
)

version = "1.2.2"

author = "Bluesheeptoken"
author_email = "louis.fruleux1@gmail.com"

description = (
    "Compact Prediction Tree: A Lossless Model for Accurate Sequence Prediction"
)

license = "MIT"

this_directory = path.abspath(path.dirname(__file__))
with open(path.join(this_directory, "README.md")) as f:
    long_description = f.read()

url = "https://github.com/bluesheeptoken/CPT"

setup(
    name="cpt",
    ext_modules=cythonize(
        module,
        annotate=False,
        compiler_directives={"language_level": sys.version_info[0]},
    ),
    version=version,
    author=author,
    author_email=author_email,
    description=description,
    license=license,
    long_description=long_description,
    long_description_content_type="text/markdown",
    url=url,
    python_requires=">=3.5, <4",
)
