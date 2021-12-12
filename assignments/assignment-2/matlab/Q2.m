clc;
clear;

X = [1097, 469; 2092, 576; 1313, 1111; 2044, 1255; 992, 1805; 1926, 2160; 1997, 2746; 1553, 423];
P = [427, 346; 1523, 536; 675, 1056; 1476, 1227; 300, 1803; 1347, 2151; 1420, 2738; 945, 335];

% Quaternion
[angle_Q, K, K_hat, v, s, q_hat, R_Q] = rotation_angle_quaternion(X', P', 2899);
angle_Q = angle_Q ./ pi .* 180;

% SVD
[angle_SVD, Ex, Ep, W, U, S, V, R_SVD] = rotation_angle_SVD(X', P', 2899);
angle_SVD = angle_SVD ./ pi .* 180;