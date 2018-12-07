import argparse
import json
import logging
import sys

def pkg_version(fl):
    pipfile_lock_ = json.load(fl)

    def v(name):
        return pipfile_lock_['default'][name]['version'].replace('==', '')

    return v

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', action='count', default=0)
    parser.add_argument('pipfile_lock', nargs='?', type=argparse.FileType('r'), default=sys.stdin)
    args = parser.parse_args()

    logging.basicConfig(level=[logging.WARNING, logging.INFO, logging.DEBUG][min(args.verbose, 2)])

    v = pkg_version(args.pipfile_lock)
    print('+'.join(v(name) for name in ['devpi-server', 'devpi-web']))

if __name__ == '__main__':
    sys.exit(main())
