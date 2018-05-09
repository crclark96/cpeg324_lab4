import sys

def main():

    if(len(sys.argv) != 2):
        return "usage: python3 testbenchmaker.py <filename.asi>"
    
    ans = ""
    
    with open(sys.argv[1], "r") as f:
        for line in f:
            if line[0] != "#":
                ans += '("' + line[:-1] + '", ' + "'0'," + '"00000000"),\n'
                ans += '("' + line[:-1] + '", ' + "'1'," + '"00000000"),\n'    
    
    return ans

print(main())
