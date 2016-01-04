from setuptools import setup
from Cython.Build import cythonize

setup(
    name='dependency_decoding',
    version='0.0.1',
    ext_modules=cythonize("*.pyx"))
