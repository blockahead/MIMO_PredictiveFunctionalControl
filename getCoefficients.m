% Free output matrix F_mat‚ÆToeplitz matrix Phi_mat‚ðŒvŽZ‚·‚é
% pfc               : PFC construct including system definition
function [ F_mat, Phi_mat ] = getCoefficients( pfc )
    Ad = pfc.Ad;
    Bd = pfc.Bd;
    Cd = pfc.Cd;

    F_mat = zeros( ( pfc.outputDim * pfc.h(pfc.coincidenceDim) ), pfc.stateDim );
    Phi_mat = zeros( ( pfc.outputDim * pfc.h(pfc.coincidenceDim) ), ( pfc.inputDim * pfc.h(pfc.coincidenceDim) ) );

    pow_Ad = eye( pfc.stateDim, pfc.stateDim );
    
    for cnt_h_outer = 1:pfc.h(pfc.coincidenceDim)
        buff = Cd * pow_Ad * Bd;
        
        for cnt_h_inner = 1:( pfc.h(pfc.coincidenceDim) - ( cnt_h_outer - 1 ) )
            rowIndex = ( ( ( cnt_h_outer - 1 ) + ( cnt_h_inner - 1 ) ) * pfc.outputDim + 1 ):( ( ( cnt_h_outer - 1 ) + cnt_h_inner ) * pfc.outputDim );
            colIndex = ( ( cnt_h_inner - 1 ) * pfc.inputDim + 1 ):( cnt_h_inner * pfc.inputDim );
            Phi_mat(rowIndex,colIndex) = buff;
        end
        
        
        pow_Ad = pow_Ad * Ad;
        
        rowIndex = ( ( cnt_h_outer - 1 ) * pfc.outputDim + 1 ):( cnt_h_outer * pfc.outputDim );
        colIndex = 1:pfc.stateDim;
        F_mat(rowIndex,colIndex) = Cd * pow_Ad;
    end
end