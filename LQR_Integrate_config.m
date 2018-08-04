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
% Augumented system
Ac_aug = [
    Ac, zeros( 4, 2 )
    -Cc, zeros( 2, 2 );
];

Bc_aug = [
    Bc;
    zeros( 2, 2 );
];

% Weight
Q_lqr = diag( [ 1, 1, 1, 1, 1e6, 1e6 ] );
R_lqr = diag( [ 100, 100 ] );
gain_lqr_buff = lqr( Ac_aug, Bc_aug, Q_lqr, R_lqr );
gain_lqr_f = gain_lqr_buff(:,1:4);
gain_lqr_g = -gain_lqr_buff(:,5:6);


%% Simulation
sim( 'LQR_Integrate_model' );