#!/usr/bin/env python

# Listing 2 
# calculate molecular descriptors using the RDKit library

import sys,string
from rdkit import Chem
from rdkit.Chem import Descriptors

if len(sys.argv) != 3:
    print >> sys.stderr,"usage %s infile.smi outfile" % (sys.argv[0])
    sys.exit(0)

# setup a molecule supplier for the input molecules
suppl = Chem.SmilesMolSupplier(sys.argv[1],titleLine=False)
# open the output file
ofs = open(sys.argv[2],"w")
# create a list of descriptor names for the header
nameList = ["Name"] + [x[0] for x in Descriptors.descList[3:]]
print >> ofs,string.join(nameList)
# read the input molecules
for idx,mol in enumerate(suppl):
    print >> sys.stderr,"\r",idx+1,
    sys.stderr.flush()
    print >> ofs,mol.GetProp("_Name"),
    # write out the desriptors
    for name,desc in Descriptors.descList[3:]:
        val = desc(mol)
        print >> ofs,"%.2f" % (val),
    print >> ofs
print >> sys.stderr,"\r",idx+1

    

    
