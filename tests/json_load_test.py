#! /usr/bin/python

from __future__ import print_function
import sys
import time
import os
sys.path.append('..')

parsers = ["jsaone_py", "jsaone_cyt", "jsaone", "json", "ijson"]

usage = """Usage:\n\n\t%s PARSER REPETITIONS FILE\n\nwhere PARSER is one of %s.""" % (sys.argv[0], (', '.join(parsers)))

try:
    parser = sys.argv[1]
    assert(parser in parsers)
    times = int(sys.argv[2])
    assert(os.path.exists(sys.argv[3]))
except:
    print(usage)
    sys.exit(0)

for rep in range(times):
    try:
        counter = 0
        now = time.time()
        with open(sys.argv[3]) as fileobj:
            if parser.startswith('jsaone'):
                if parser == 'jsaone_cyt':
                    from jsaone_cyt import load
                elif parser == 'jsaone_py':
                    from jsaone_py import load
                elif parser == 'jsaone':
                    from jsaone import load
                
                for obj in load(fileobj):
                    counter += 1

            elif parser == 'json':
                from json import load
                for item in load(fileobj):
                    counter += 1

            elif parser == 'ijson':
                import ijson.backends.yajl2 as ijson
                for obj in ijson.items(fileobj, ''):
                    counter += 1

            print("Read %d objects in %f seconds with parser %s" % (counter, time.time() - now, parser))
    except Exception as exc:
        raise exc
