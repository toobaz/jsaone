jsaone
===============

This is a tiny wrapper around generic json libraries (which it imports by
trying first "json" and then "simplejson"), allowing to read a json file
incrementally.

This can be useful for
- parsing json streams without waiting for the end of the transmission,
- parsing very big json objects without wasting RAM for the json representation
  itself.

Notice that
- for local files, this approach is probably slower than the wrapped json
  library, unless maybe in cases with a quick CPU and a slow drive,
- existing standalone incremental parsers, such as ijson, may perform better.

Why "jsaone"
-----

Because it sounds to similar to "json"... but the Saône is a (big) stream.

Dependencies
-----

 - simplejson_ (Python 2.5 only)

License
-------

Released under the GPL 3.

.. _simplejson: http://pypi.python.org/pypi/simplejson/
