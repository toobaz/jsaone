from distutils.core import setup
from Cython.Build import cythonize
import codecs

with codecs.open('README', encoding='utf8') as fin:
    long_description = fin.read()

setup(
  name = 'jsaone',
  version='0.2',
  license='GPL',
  author='Pietro Battiston',
  author_email='me@pietrobattiston.it',
  url='http://pietrobattiston.it/jsaone',
  description='Incremental JSON parser',
  long_description=long_description,
  ext_modules = cythonize("jsaone_cyt.pyx"),
  py_modules=['jsaone', 'jsaone_py'],
  classifiers=[
	'Development Status :: 4 - Beta',
	'Intended Audience :: Developers',
	'License :: OSI Approved :: GNU General Public License (GPL)',
	'Programming Language :: Python',
	'Topic :: Software Development :: Libraries :: Python Modules',
	'Topic :: System :: Networking',
	'Topic :: Internet :: WWW/HTTP'
	]	
)
