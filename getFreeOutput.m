% �w�肳�ꂽ��v�_�ɂ�����C���鏉����Ԃ���̎��R�������v�Z����D
% CoincidencePoint  : Discrete-time sampling index of a coincidence point
% pfc               : PFC structure including system definition
function freeOutput = getFreeOutput( CoincidencePoint, pfc )
    % Free output
    freeOutput = pfc.Cd * pfc.Ad^( pfc.h(CoincidencePoint) );
end