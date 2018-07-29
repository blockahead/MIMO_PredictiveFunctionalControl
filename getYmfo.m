% ã≠êßâûìöçsóÒÇåvéZÇ∑ÇÈÅD
% pfc               : PFC structure including system definition
function ymfo = getYmfo( pfc )
    ymfo = zeros( ( pfc.outputDim * pfc.coincidenceDim ), ( pfc.inputDim * pfc.basisFunctionOrder ) );

    for cnt_basis = 1:pfc.basisFunctionOrder
        for cnt_coincidence = 1:pfc.coincidenceDim
            for cnt_input = 1:pfc.inputDim
                rowIndex = ( ( cnt_coincidence - 1 ) * pfc.outputDim + 1 ):( cnt_coincidence * pfc.outputDim);
                colIndex = ( ( cnt_basis - 1 ) * pfc.inputDim + cnt_input );
                ymfo(rowIndex,colIndex) = getForceOutput( cnt_input, cnt_coincidence, cnt_basis, pfc );
            end
        end
    end
end