% X,P ---- points set
% f ---- focal length(pixel)
function [angle, K, K_hat, v, s, q_hat, R]  = rotation_angle_quaternion(X, P, f)
    [~, cols] = size(X);
    NuX = zeros(3, cols);
    NuP = zeros(3, cols);
    
    % Calculate N-vector
    for i = 1 : cols
        NuX(:, i) = [X(1, i); X(2, i); f] ./ sqrt(X(1, i)^2 + X(2, i)^2 + f^2);
        NuP(:, i) = [P(1, i); P(2, i); f] ./ sqrt(P(1, i)^2 + P(2, i)^2 + f^2);
    end
    
    % Calculate K and K_hat
    W = [9 6 6 8 9 12 11 17];
    K = zeros(3, 3);
    for i = 1 : cols
        K = K + W(i) * NuX(:, i) * NuP(:, i)';
    end
    K_hat = [K(1, 1) + K(2, 2) + K(3, 3), K(3, 2) - K(2, 3), K(1, 3) - K(3, 1), K(2, 1) - K(1, 2);
        K(3, 2) - K(2, 3), K(1, 1) - K(2, 2) - K(3, 3), K(1, 2) + K(2, 1), K(3, 1) + K(1, 3);
        K(1, 3) - K(3, 1), K(1, 2) + K(2, 1), - K(1, 1) + K(2, 2) - K(3, 3), K(2, 3) + K(3, 2);
        K(2, 1) - K(1, 2), K(3, 1) + K(1, 3), K(2, 3) + K(3, 2), - K(1, 1) - K(2, 2) + K(3, 3)];
    [v, s] = eig(K_hat); % v -- eigenvector matrix; s -- eigenvalue matrix
    s_max = s(1, 1);
    index = 1;
    for i = 2 : 4
        if s(i, i) > s_max
            s_max = s(i, i);
            index= i;
        end
    end
    q = v(:, index);
    q0 = q(1, 1) / sqrt(q(1, 1)^2 + q(2, 1)^2 + q(3, 1)^2 + q(4, 1)^2);
    q1 = q(2, 1) / sqrt(q(1, 1)^2 + q(2, 1)^2 + q(3, 1)^2 + q(4, 1)^2);
    q2 = q(3, 1) / sqrt(q(1, 1)^2 + q(2, 1)^2 + q(3, 1)^2 + q(4, 1)^2);
    q3 = q(4, 1) / sqrt(q(1, 1)^2 + q(2, 1)^2 + q(3, 1)^2 + q(4, 1)^2);
    sum = q(1, 1)^2 + q(2, 1)^2 + q(3, 1)^2 + q(4, 1)^2;
    disp(sum);
    q_hat = [q0; q1; q2; q3];
    
    R = [q0^2 + q1^2 - q2^2 - q3^2, 2 * (q1 * q2 - q0 * q3), 2 * (q1 * q3 + q0 * q2);
        2 * (q2 * q1 + q0 * q3), q0^2 - q1^2 + q2^2 - q3^2, 2 * (q2 * q3 - q0 * q1);
        2 * (q3 * q1 - q0 * q2), 2 * (q3 * q2 + q0 * q1), q0^2 - q1^2 - q2^2 + q3^2];
    angle = rotm2eul(R);
end