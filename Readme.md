
# BondReader

Welcome to BondReader, built for easy batch analysis on TreasuryDirect.gov. 
This project runs on GNU Cobol 

1. Pick the Bond history of your choice:
```
https://www.treasurydirect.gov/indiv/tools/tools_savingsbondvalues.htm
```

2. Add to a new directory with BondReader.cob 
3. Change the inFile value (line 6) to the file name. (Hardcoded to 'sb201712.asc' starter file)
4. Run in Terminal
```
COBC BondReader.cob
```
5. Profit?

Note: Try a different language if you want to do this at home. Writing CoBOL is like coding in Assembly while you can be using Python. Abstraction is pretty much impossible and the syntax is painful, but this was a fun challenge for myself.

## mk
