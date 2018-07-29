function indexedSV = getIndexedSV( Index, bufferedFutureSV, pfc )
    rowIndex = 1:pfc.outputDim;
    colIndex = Index;
    indexedSV = bufferedFutureSV(rowIndex,colIndex);
end