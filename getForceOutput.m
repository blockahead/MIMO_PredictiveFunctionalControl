% 指定された一致点における，ゼロ状態からの強制応答を計算する．
% InputIndex        :
% CoincidencePoint  : Discrete-time sampling index of a coincidence point
% BasisFunction     : Order of basis function. 
%                   - 1: STEP
%                   - 2: RAMP
%                   - 3: PARABORA
% pfc               : PFC structure including system definition
function forceOutput = getForceOutput( InputIndex, CoincidencePoint, BasisFunction, pfc )
    u_vec = zeros( pfc.inputDim, 1 );
    forceOutput = zeros( pfc.outputDim, 1 );
    
    for cnt_h = 1:pfc.h(CoincidencePoint)
        % Control input vector
        u_vec(InputIndex) = ( ( cnt_h - 1 ) )^( BasisFunction - 1 );
        
        % Control input vector (こっちであるべき？)
        % u_vec(InputIndex) = ( pfc.dSamplingPeriod * ( cnt_h - 1 ) )^( BasisFunction - 1 );
        
        
        % Force output
        forceOutput = forceOutput + pfc.Cd * pfc.Ad^( pfc.h(CoincidencePoint) - cnt_h ) * pfc.Bd * u_vec;
    end
end