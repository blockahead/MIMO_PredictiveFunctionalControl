function MV = controlPFC( SV, CV, MV_pre, pfc )
    persistent xm;
    
    if( isempty( xm ) )
        xm = zeros( pfc.stateDim, 1 );
    end
    
    % -------------------------------------
    % Model update
    % -------------------------------------
    xm = pfc.Ad * xm + pfc.Bd * MV_pre;
    ym = pfc.Cd * xm;
    
    % -------------------------------------
    % Compensation with future setpoint
    % -------------------------------------
    if( pfc.futureSetpointFlag )
        [ SV, futureCompensation_vec ] = getFutureSV_vec( SV, pfc );
    else
        futureCompensation_vec =  zeros( ( pfc.outputDim * pfc.coincidenceDim ), 1 );
    end
    
    % -------------------------------------
    % Extend to vector
    % -------------------------------------    
    SV_vec = repmat( SV, pfc.coincidenceDim, 1 );
    CV_vec = repmat( CV, pfc.coincidenceDim, 1 );
    ym_vec = repmat( ym, pfc.coincidenceDim, 1 );
    
    % -------------------------------------
    % Calculate the control input
    % -------------------------------------
    Y = ( SV_vec - CV_vec ) .* pfc.lh - pfc.ymfr * xm + ym_vec + futureCompensation_vec;
    MV_buff = ( pfc.ymfo \ Y );
    
    % -------------------------------------
    % Apply first element to the plant
    % -------------------------------------
    MV = MV_buff(1:pfc.inputDim);
    
end