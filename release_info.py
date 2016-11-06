import re

app_name = 'jsaone'
basefile = 'jsaone.py'
files_to_substitute = ['jsaone.py']
version_re = re.compile("__version__ *= *'([0-9]*\.[0-9]*(\.[0-9]*)?)'")
version_re_setup = re.compile("version='([0-9]*\.[0-9]*(\.[0-9]*)?)',")
