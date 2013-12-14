jsaone
===============

This is a tiny wrapper around generic json libraries (which it imports by
trying first "json" and then "simplejson"), allowing to read a json file
incrementally.

This can be useful for
- parsing json streams without waiting for the end of the transmission,
- parsing very big json objects without wasting RAM for the json representation
  itself.

Efficiency
-----

No extensive tests were made (if you make them, let me know), but here are the
results (in seconds) obtained in opening a local file with 384650 objects,
totalling 174 MB:

+---------------------------------+-------------+-------------+
| Parser                          | Iteration 1 | Iteration 2 |
+=================================+=============+=============+
| standard (non-incremental) json |   9.511     |   9.273     |
+=================================+=============+=============+
| cythonized jsaone               |  19.055     |  18.956     |
+=================================+=============+=============+
| ijson (with yajl2 backend)      |  62.250     |  64.538     |
+=================================+=============+=============+
| pure python jsaone              | 421.641     | 421.821     |
+---------------------------------+-------------+-------------+

Those results were obtained with the script "tests/json_load_test.py".

Clearly those numbers are affected by the speed of the CPU and of the medium.
In general the faster the CPU (compared to the storage medium/stream), the
fastest will be the standard json compared to incremental ones (including
jsaone).

Why "jsaone"
-----

Because it sounds similar to "json"... but the Saône is a (large) stream.

Dependencies
-----

 - simplejson_ (Python 2.5 only)
 - for efficiency: cython (at build time)

License
-------

Released under the GPL 3.

.. _simplejson: http://pypi.python.org/pypi/simplejson/
.. _cython: http://cython.org
