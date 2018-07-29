% éQè∆ãOìπÇåvéZÇ∑ÇÈÅD
% pfc               : PFC structure including system definition
function lh = getReferenceTrajectory( pfc )
    lh = zeros( ( pfc.outputDim * pfc.coincidenceDim ), 1 );
    
    for cnt_coincidence = 1:pfc.coincidenceDim
        for cnt_output = 1:pfc.outputDim
            rowIndex = ( ( cnt_coincidence - 1 ) * pfc.outputDim + cnt_output ):( cnt_coincidence * pfc.outputDim );
            colIndex = 1;
            lh(rowIndex,colIndex) = ( 1 - exp( ( - 3 * pfc.h(cnt_coincidence) * pfc.dSamplingPeriod ) / pfc.tCLRT(cnt_output) ) );
        end
    end
end