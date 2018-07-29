function bufferedFutureSV = bufferingFutureSV( SV, pfc )
    persistent futureSV_buff;
    
    if( isempty( futureSV_buff ) )
        futureSV_buff = zeros( pfc.outputDim, pfc.h(pfc.basisFunctionOrder) + 1 );
    end
    
    for cnt_h = 1:( pfc.h(pfc.basisFunctionOrder) )
        rowIndex = 1:pfc.outputDim;
        colIndex = cnt_h;
        futureSV_buff(rowIndex,colIndex) = futureSV_buff(rowIndex,colIndex+1);
    end
    
    rowIndex = 1:pfc.outputDim;
    colIndex = pfc.h(pfc.basisFunctionOrder) + 1;
    futureSV_buff(rowIndex,colIndex) = SV;
    
    bufferedFutureSV = futureSV_buff;
end