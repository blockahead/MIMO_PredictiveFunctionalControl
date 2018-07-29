% 自由応答ベクトルを計算する．
% pfc               : PFC structure including system definition
function ymfr = getYmfr( pfc )
    ymfr = zeros( ( pfc.outputDim * pfc.coincidenceDim ), pfc.stateDim );
    
    for cnt_coincidence = 1:pfc.coincidenceDim
        rowIndex = ( ( cnt_coincidence - 1 ) * pfc.outputDim + 1 ):( cnt_coincidence * pfc.outputDim);
        colIndex = 1:( pfc.stateDim );
        ymfr(rowIndex,colIndex) = getFreeOutput( cnt_coincidence, pfc );
    end
end