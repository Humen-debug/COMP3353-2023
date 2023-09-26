from random import choice
from sys import argv

def DNA(len):
    return ''.join(choice('CGTA') for _ in range(len))

if __name__ == "__main__":
    dir='./DNA.txt'
    len=1000
    if(len(argv) >= 2): dir=argv[1]
    if(len(argv) >= 3): len=argv[2]
    with open(dir, mode='wt') as f:
        f.write(DNA(len))