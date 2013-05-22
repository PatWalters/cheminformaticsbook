#!/usr/bin/env python

# Listing 6
# cacluate similarity between pairs of SMILES files and report 
# the most similar training set molecule for each test set molecule

import sys,string
from rdkit import Chem
from rdkit import DataStructs
from rdkit.Chem.Fingerprints import FingerprintMols

# build a list of fingerprints from an input file
def buildFingerprintList(fileName):
    suppl = Chem.SmilesMolSupplier(fileName,titleLine=False)
    fpList = []
    for idx,mol in enumerate(suppl):
        print >> sys.stderr,"\rGenerating fingerprints for %s " % (fileName),idx+1,
        sys.stderr.flush()
        fpList.append([mol.GetProp("_Name"),FingerprintMols.FingerprintMol(mol)])
    print >> sys.stderr,"\rGenerating fingerprints for %s " % (fileName),idx+1
    return fpList

# for each molecule in queryFpLIst, find and report the most similar molecule in refFpList    
def findMostSimilar(refFpList,queryFpList):
    outList = []
    for idx,[name,fp] in enumerate(queryFpList):
        print >> sys.stderr,"\rCalculating similarity ",idx,
        sys.stderr.flush()
        simList = [[x[0],DataStructs.FingerprintSimilarity(fp,x[1])] for x in refFpList]
        simList.sort(lambda a,b: cmp(b[1],a[1]))
        outList.append([name,simList[0]])
    print >> sys.stderr,"\rCalculating similarity ",idx+1
    return outList


# setup training and test sets
trainingFiles = ["huuskonen_train.smi"]
testFiles = ["huuskonen_test.smi","jcim.smi","pubchem.smi"]
trainDict = {}
testDict = {}

# open the output file
ofs = open("similarity.txt","w")

# generate fingerprints
for fileName in trainingFiles:
    trainDict[fileName] = buildFingerprintList(fileName)
for fileName in testFiles:
    testDict[fileName] = buildFingerprintList(fileName)

# write the output
print >> ofs,"Query Reference Similarity Dataset"
for trainFileName,trainFpList in trainDict.iteritems():
    for testFileName,testFpList in testDict.iteritems():
        print >> sys.stderr,"Processing %s" % testFileName
        simList = findMostSimilar(trainFpList,testFpList)
        for query,[ref,sim] in simList:
            print >> ofs,query,ref,"%.2f" % (sim),testFileName.split(".")[0].upper()

print >> sys.stderr,"Results have been written to similarity.txt"
        


    
