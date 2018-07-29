% 指定された一致点における，ある初期状態からの自由応答を計算する．
% CoincidencePoint  : Discrete-time sampling index of a coincidence point
% pfc               : PFC structure including system definition
function freeOutput = getFreeOutput( CoincidencePoint, pfc )
    % Free output
    freeOutput = pfc.Cd * pfc.Ad^( pfc.h(CoincidencePoint) );
end