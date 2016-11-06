# -*- coding: utf-8 -*-

# Copyright © 2013 Pietro Battiston <me@pietrobattiston.it>
# See "LICENSE" for copying.

"""
This is a simple incremental json parser. It relies on other parsers for the
real operation: all it does is to read the "key : value" pairs one at a time
and call the parser separately on each of them. It may hence be slower than the
original parser, but it allows to process json strings which represent a very
large number of objects (compared to the available RAM), or to parse json
streams without waiting for the end of their transmission.
"""

from __future__ import print_function

__version__ = '0.2'

try:
    from jsaone_cyt import load
except:
    from jsaone_py import load
    print("Cythonized version not found - falling back to pure Python one.")
