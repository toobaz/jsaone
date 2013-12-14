from distutils.core import setup
from Cython.Build import cythonize

setup(
  name = 'jsaone',
  version='1.0',
  license='GPL',
  author='Pietro Battiston',
  author_email='me@pietrobattiston.it',
  url='http://pietrobattiston.it/jsaone',
  ext_modules = cythonize("jsaone_cyt.pyx"),
  py_modules=['jsaone', 'jsaone_py'],
  classifiers=[
	'Development Status :: 4 - Beta',
	'Environment :: X11 Applications :: GTK',
	'Intended Audience :: Developers',
	'License :: OSI Approved :: GNU General Public License (GPL)',
	'Programming Language :: Python',
	'Topic :: Software Development :: Libraries :: Python Modules',
	'Topic :: System :: Networking',
	'Topic :: Internet :: WWW/HTTP'
	]	
)
