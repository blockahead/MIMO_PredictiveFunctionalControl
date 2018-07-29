% h�T���v�������ڕW�l��x�������C�����̖ڕW�l�Ƃ��ė��p����D
% SV                : Current setpoint
% pfc               : PFC structure including system definition
function [ currentSV, futureCompensation_vec ] = getFutureSV_vec( SV, pfc )
    bufferedFutureSV = bufferingFutureSV( SV, pfc );
    
    currentSV = getIndexedSV( 1, bufferedFutureSV, pfc );
    
    futureCompensation_vec = zeros( ( pfc.outputDim * pfc.coincidenceDim ), 1 );
    for cnt_coincidence = 1:pfc.coincidenceDim
        rowIndex = ( ( cnt_coincidence - 1 ) * pfc.outputDim + 1 ):( cnt_coincidence * pfc.outputDim );
        colIndex = 1;
        futureCompensation_vec(rowIndex,colIndex) = getIndexedSV( ( pfc.h(cnt_coincidence) + 1 ), bufferedFutureSV, pfc ) - currentSV;
    end
end