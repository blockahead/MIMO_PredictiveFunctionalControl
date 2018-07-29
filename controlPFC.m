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
    % Extend error and model output vector
    % -------------------------------------
    eror_vec = repmat( ( SV - CV ), pfc.coincidenceDim, 1 );
    ym_vec = repmat( ym, pfc.coincidenceDim, 1 );
    
    
    % -------------------------------------
    % Calculate the control input
    % -------------------------------------
    Y = eror_vec .* pfc.lh - pfc.ymfr * xm + ym_vec;
    MV_buff = ( pfc.ymfo \ Y );
    
    % -------------------------------------
    % Apply first element to the plant
    % -------------------------------------
    MV = MV_buff(1:pfc.inputDim);
    
end