close all;
clc;
clear;

%% Simulation parameters
% Sampling period (s)
dSamplingPeriod = 0.01;

%% Plant definition ( 2DOF mass-damper system )
M1 = 1.0;
M2 = 1.0;
D1 = 1.0;
D2 = 1.0;

Ac = [
    0, 0, 1, 0;
    0, 0, 0, 1;
    0, 0, -(D1+D2)/M1, D2/M1;
    0, 0, D2/M2, -D2/M2;
];

Bc = [
    0, 0;
    0, 0;
    1/M1, 0;
    0, 1/M2;
];

Cc = [
    1, 0, 0, 0;
    0, 1, 0, 0;
];

Dc = zeros( 2, 2 );

plant = ss( Ac, Bc, Cc, Dc );

%% Inner LQR design
Q_lqr = diag( [ 1, 1, 1, 1 ] );
R_lqr = diag( [ 1, 1 ] );
gain_lqr = lqr( Ac, Bc, Q_lqr, R_lqr );

%% Internal model definition
% Without inner controller
model = c2d( ss( Ac, Bc, Cc, Dc ), dSamplingPeriod );
InnerFbFlag = 0;

% With inner controller (LQR)
% model = c2d( ss( Ac - Bc * gain_lqr, Bc, Cc, Dc ), dSamplingPeriod );
% InnerFbFlag = 1;

%% Controller defenition
% Discrete time sampling period ( design parameter )
pfc.dSamplingPeriod = dSamplingPeriod;

% Desired closed-loop response time ( design parameter )
pfc.tCLRT = [
    0.6;
    0.6;
];

% tCLRTを大きくしてみると，強制応答が何を計算しているかがわかりやすい
% pfc.tCLRT = [
%     30.0;
%     30.0;
% ];

% Use delay compensation by using future setpoint
pfc.futureSetpointFlag = 0;

% Basis function order ( sometimes modify )
pfc.basisFunctionOrder = 3;

% Coincidence points ( sometimes modify )
pfc.h = [
    floor( max( pfc.tCLRT ) / ( 3 * pfc.dSamplingPeriod ) );
    floor( max( pfc.tCLRT ) / ( 2 * pfc.dSamplingPeriod ) );
    floor( max( pfc.tCLRT ) / ( 1 * pfc.dSamplingPeriod ) );
];

% Matrices
pfc.Ad = model.a;
pfc.Bd = model.b;
pfc.Cd = model.c;
pfc.Dd = model.d;

% Dimensions
pfc.stateDim = size( pfc.Ad, 1 );
pfc.inputDim = size( pfc.Bd, 2 );
pfc.outputDim = size( pfc.Cd, 1 );
pfc.coincidenceDim = size( pfc.h, 1 );

% Force output matrix
pfc.ymfo = getYmfo( pfc );

% Free output matrix
pfc.ymfr = getYmfr( pfc );

% Reference trajectory
pfc.lh = getReferenceTrajectory( pfc );

%% 強制応答の確認
figure( 'Name', 'Force output', 'Position', [ 25, 50, 1850, 900 ] );

t_end = pfc.dSamplingPeriod * ( pfc.h(end) - 1 );
t_vec = linspace( 0, t_end, pfc.h(end) )';

for cnt_basis = 1:pfc.basisFunctionOrder
    u_vec = t_vec.^( cnt_basis - 1 );
    for cnt_input = 1:pfc.inputDim
        u_mat = zeros( length( t_vec ), pfc.inputDim );
        u_mat(:,cnt_input) = u_vec;
        
        [ y, t ] = lsim( model, u_mat );
        
        for cnt_output = 1:pfc.outputDim
            subplot( pfc.outputDim, ( pfc.inputDim * pfc.basisFunctionOrder ), ( cnt_output - 1 ) * ( pfc.inputDim * pfc.basisFunctionOrder ) + ( cnt_basis - 1 ) * ( pfc.inputDim ) + cnt_input );
            hold on;
            plot( t, y(:,cnt_output) );
            
            for cnt_coincidence = 1:pfc.coincidenceDim
                rowIndex = ( ( cnt_coincidence - 1 ) * pfc.outputDim + cnt_output );
                colIndex = ( ( cnt_basis - 1 ) * pfc.inputDim + cnt_input );
                scatter( pfc.dSamplingPeriod * pfc.h(cnt_coincidence), pfc.dSamplingPeriod^( cnt_basis - 1 ) * pfc.ymfo(rowIndex,colIndex) );
            end
            
            Text = strcat( 'Output', num2str( cnt_output ), ', Input', num2str( cnt_input ), ', Order', num2str( cnt_basis ) );
            title( Text );
        end
    end
end


%% Simulation
sim( 'PFC_Integrate_model' );