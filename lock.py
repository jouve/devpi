
import json
import sys

def fmt(k, v):
        try:
            return f'''{v['file']}#egg={k}'''
        except KeyError:
            pass
        try:
            markers = f''' ; {v['markers']}'''
        except KeyError:
            markers = ''
        return f'''{k}{v['version']}{markers}'''

def main():
    print('\n'.join(sorted(fmt(k, v) for k, v in json.load(sys.stdin)['default'].items())))

if __name__ == '__main__':
    sys.exit(main())
