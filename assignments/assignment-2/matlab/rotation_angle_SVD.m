% X,P ---- points set
% f ---- focal length(pixel)
function [angle, Ex, Ep, W, U, S, V, R] = rotation_angle_SVD(X, P, f)
    [~, cols] = size(X);
    NuX = zeros(3, cols);
    NuP = zeros(3, cols);
    
    % Calculate N-vector
    for i = 1 : cols
        NuX(:, i) = [X(1, i); X(2, i); f] ./ sqrt(X(1, i)^2 + X(2, i)^2 + f^2);
        NuP(:, i) = [P(1, i); P(2, i); f] ./ sqrt(P(1, i)^2 + P(2, i)^2 + f^2);
    end
    
    % Find the mass center
    Ex = zeros(3, 1);
    Ep = zeros(3, 1);
    for i = 1 : cols
        Ex = Ex + NuX(:, i);
        Ep = Ep + NuP(:, i);
    end
    Ex = Ex / cols;
    Ep = Ep / cols;
    
    % Calculate W
    X_1 = NuX - Ex;
    P_1 = NuP - Ep;
    W = X_1 * P_1';
    
    % Using SVD to find rotation angle
    [U, S, V] = svd(W);
    disp(S); % delta_1 > = delta_2 >= delta_3
    R = U * V';
    angle = rotm2eul(R);
end