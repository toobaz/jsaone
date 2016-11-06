# -*- coding: utf-8 -*-

# Copyright © 2013 Pietro Battiston <me@pietrobattiston.it>
# See "LICENSE" for copying.

"""
This is a cythonized version of jsaone.py.
"""

from __future__ import print_function

try:
    import json
except ImportError:
    import simplejson as json

BUF_LEN = 100
STRIP_CHARS = set((' ', '\n', '\t'))
DELIMITERS = {'{' : '}',
              '[' : ']',
              '"' : '"'}

STATES_LIST = ["STARTING",
               "BEFORE_KEY",
               "INSIDE_KEY",
               "AFTER_KEY",
               "BEFORE_VALUE",
               "INSIDE_DELIMITED_VALUE",
               "INSIDE_NON_DELIMITED_VALUE",
               "AFTER_VALUE",
               "FINISHED"]

exec(",".join(STATES_LIST) + "= range(%d)" % len(STATES_LIST))
STATES = dict(zip(range(len(STATES_LIST)), STATES_LIST))

cdef int STARTING = 0
cdef int BEFORE_KEY = 1
cdef int INSIDE_KEY = 2
cdef int AFTER_KEY = 3
cdef int BEFORE_VALUE = 4
cdef int INSIDE_DELIMITED_VALUE = 5
cdef int INSIDE_NON_DELIMITED_VALUE = 6
cdef int AFTER_VALUE = 7
cdef int FINISHED = 8

DEBUG = False

def _debug(*args, **kwargs):
    if DEBUG:
        print(*args, **kwargs)
    else:
        pass

def nested_json(buf, obj_start, cursor):
    json_chunk = "{%s}" % buf[obj_start:cursor]
    _debug("Parse key/value pair '%s'" % json_chunk)
    
    try:
        json_obj = json.loads(json_chunk)
    except:
        print("Problem with key/value pair '%s'" % json_chunk)
        raise
    return json_obj.popitem()

def load(file_obj):
    """
    This generator reads and incrementally parses file_obj, yielding each
    key/value pair it parses as a tuple (key, value).
    """
    cdef int state = STARTING

    cdef same_buf = False
    
    open_delimiters = []
    
    escape = False
    
    cdef int cursor = -1
    cdef str buf = ''
    cdef str new_buf
    cdef str char
    
    while state != FINISHED:
        if cursor == len(buf)-1:
            new_buf = file_obj.read(BUF_LEN)
            if not new_buf:
                raise ValueError("Premature end (current processing buffer "
                                 "ends with '%s')" % buf)
            
            buf += new_buf

        cursor += 1
        char = buf[cursor]
        
#        _debug("Parse \"%s\" with state %s,"
#               " open delimiters %s..." % (char,
#                                           STATES[state],
#                                           open_delimiters),
#              end="")
        
        old_state = state

            
        if state == STARTING:
            if char == '{':
                state = BEFORE_KEY
        
        elif state == BEFORE_KEY:
            if char == '"':
                obj_start = cursor
                state = INSIDE_KEY
            elif char == '}':
                state = FINISHED
        
        elif state == INSIDE_KEY:
            if char == '"':
                state = AFTER_KEY
        
        elif state == AFTER_KEY:
            if char == ':':
                state = BEFORE_VALUE
        
        elif state == BEFORE_VALUE:
            if char in DELIMITERS:
                state = INSIDE_DELIMITED_VALUE
                open_delimiters.append(char)
            elif char not in STRIP_CHARS:
                state = INSIDE_NON_DELIMITED_VALUE
        
        elif state == INSIDE_NON_DELIMITED_VALUE:
            # Non delimited values can be
            # - numbers
            # - "true"
            # - "false"
            # - "null"
            # in any case, they can't contain spaces or delimiters.
            if char in STRIP_CHARS:
                state = AFTER_VALUE
            elif char == '}':
                state = FINISHED
            elif char == ',':
                state = BEFORE_KEY
            
            if state != INSIDE_NON_DELIMITED_VALUE:
                # OK, finished parsing value
                yield nested_json(buf, obj_start, cursor)
                del obj_start
                buf = buf[cursor:]
                cursor = 0
        
        elif state == INSIDE_DELIMITED_VALUE:
            if open_delimiters[-1] == '"':
                if escape:
                    escape = False
                    continue
                elif char == '\\':
                    escape = True
                    continue
                elif char != '"':
                    continue
                
            # Since we are INSIDE_DELIMITED_VALUE, there is at least an open
            # delimiter.
            if char == DELIMITERS[open_delimiters[-1]]:
                open_delimiters.pop()
                if not open_delimiters:
                    state = AFTER_VALUE
                    yield nested_json(buf, obj_start, cursor+1)
                    del obj_start
                    buf = buf[cursor:]
                    cursor = 0
            elif char in DELIMITERS:
                open_delimiters.append(char)
        
        elif state == AFTER_VALUE:
            if char == ',':
                state = BEFORE_KEY
            elif char == '}':
                state = FINISHED
        
        else:
            assert(state == FINISHED)
        
        # Unless there are whitespaces and such, all "non-content" states last
        # just 1 char.
        if state == old_state and not state in (INSIDE_KEY,
                                                INSIDE_DELIMITED_VALUE,
                                                INSIDE_NON_DELIMITED_VALUE):
            assert(char in STRIP_CHARS), ("Found char '%s' in %s while"
                              " parsing '%s'" % (char, STATES[old_state], buf))
        
#        _debug("... to state %s" % (STATES[state]))
