#!/usr/bin/env python
"""A more advanced Mapper, using Python iterators and generators."""

import sys
offset=0;
filename='';

def read_input(file):
    for line in file:
    	global filename
    	filename=file.name
        # split the line into words
        yield line.split()

def main(separator='\t'):
    # input comes from STDIN (standard input)
    data = read_input(sys.stdin)
    for words in data:
        # write the results to STDOUT (standard output);
        # what we output here will be the input for the
        # Reduce step, i.e. the input for reducer.py
        #
        # tab-delimited; the trivial word count is 1
        for word in words:
        	global filename
        	global offset
        	outstr=filename+'@'+str(offset)
        	print '%s%s%s' % (word, separator, outstr)
        	offset+=len(word)+1;#1 for space character;

if __name__ == "__main__":
    main()
