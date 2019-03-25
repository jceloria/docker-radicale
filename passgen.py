#!/usr/bin/env python
# -*- coding: utf-8 -*-

########################################################################################################################
"""
 Generate a bcrypt hashed password

 The MIT License (MIT)

 Copyright © 2019 by John Celoria.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

"""
########################################################################################################################
# Library imports
from __future__ import print_function
import argparse
import logging.handlers
import os
import getpass
import sys

try:
    import bcrypt
except Exception:
    print("Oops!, looks like you need to run: `pip install bcrypt'")
    sys.exit(-1)

########################################################################################################################
# Set some defaults
__author__ = 'John Celoria'
__version__ = '0.1'

########################################################################################################################
# Setup logging
log = logging.getLogger(__name__)
log.setLevel(logging.INFO)

# Suppress less than WARNING level messages for the request module
logging.getLogger("requests").setLevel(logging.WARNING)

# Default logging format
log_format = '[%(filename)s:%(funcName)s]: %(levelname)s - %(message)s'

# log to the console (stderr by default)
ch = logging.StreamHandler(sys.stdout)
ch.setLevel(logging.INFO)
ch.setFormatter(logging.Formatter('%(asctime)s ' + log_format))
log.addHandler(ch)

########################################################################################################################


def parse_args():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )

    parser.add_argument('-u', '--username', default=getpass.getuser())

    return parser.parse_args()


def main():
    args = parse_args()

    password = getpass.getpass().encode('utf-8')
    hashed = bcrypt.hashpw(password, bcrypt.gensalt())

    print('{}:{}'.format(args.username, hashed.decode("utf-8")))


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        log.info('Interrupted!')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)

########################################################################################################################
