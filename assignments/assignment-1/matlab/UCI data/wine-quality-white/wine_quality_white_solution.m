addpath('D:\Confidential\NTU\EE6222 Machine Vision\Assignment-1\Matlab\UCI data');
clear;
clc;
wine_quality_white_R;
data = data(:, 2 : end); % features and labels
dataX = data(:, 1 : end - 1); % features
% do normalization for each feature
mean_X = mean(dataX, 1);
dataX = dataX - repmat(mean_X, size(dataX, 1), 1);
norm_X = sum(dataX.^2, 1);
norm_X = sqrt(norm_X);
norm_X = repmat(norm_X, size(dataX, 1), 1);
dataX = dataX ./ norm_X; % normalized feature
dataY = data(:, end); % label

% for datasets where training-testing partition is available, paramter tuning is based on this file.
wine_quality_white_conxuntos;
trainX = dataX(index1, :); 
trainY = dataY(index1, :);
testX = dataX(index2, :);
testY = dataY(index2, :);
options = 2;
MAX_acc = zeros(options, 1);
Best_N = zeros(options, 1);
Best_C = zeros(options, 1);
Best_S = zeros(options, 1);
S = -5 : 0.5 : 5;
for s = 1 : numel(S)
    for N = 3 : 20 : 203
        for C = -5 : 14 
            Scale = 2^S(s);
            
            option1.N = N;
            option1.C = 2^C;
            option1.Scale = Scale;
            option1.Scalemode = 3;
            option1.bias = 1;
            option1.link = 1;
            option1.ActivationFunction = 'radbas';
            option1.mode = 2;
            
            option2.N = N;
            option2.C = 2^C;
            option2.Scale = Scale;
            option2.Scalemode = 3;
            option2.bias = 1;
            option2.link = 1;
            option2.ActivationFunction = 'radbas';
            option2.mode = 1;
            
            [train_accuracy1, test_accuracy1] = RVFL_train_val(trainX, trainY, testX, testY, option1);
            [train_accuracy2, test_accuracy2] = RVFL_train_val(trainX, trainY, testX, testY, option2);
            
            % paramater tuning: we prefer the parameter which lead to better accuracy on the test data.
            if test_accuracy1 > MAX_acc(1)
                MAX_acc(1) = test_accuracy1;
                Best_N(1) = N;
                Best_C(1) = C;
                Best_S(1) = Scale;
            end
            if test_accuracy2 > MAX_acc(2)
                MAX_acc(2) = test_accuracy2;
                Best_N(2) = N;
                Best_C(2) = C;
                Best_S(2) = Scale;
            end
        end
    end
end

% for datasets where training-testing partition is not available, performance vealuation is based on cross-validation.
wine_quality_white_conxuntos_kfold;
ACC_CV = zeros(options, 1);

for i = 1 : 4
    trainX = dataX(index{2 * i - 1}, :);
    trainY = dataY(index{2 * i - 1}, :);
    testX = dataX(index{2 * i}, :);
    testY = dataY(index{2 * i}, :);

    option1.N = Best_N(1);
    option1.C = 2^Best_C(1);
    option1.Scale = Best_S(1);
    option1.Scalemode = 3;
    optino1.bias = 1;
    option1.link = 1;
    option1.ActivationFunction = 'radbas';
    option1.mode = 2;

    option2.N = Best_N(2);
    option2.C = 2^Best_C(2);
    option2.Scale = Best_S(2);
    option2.Scalemode = 3;
    option2.bias = 1;
    option2.link = 1;
    option2.ActivationFunction = 'radbas';
    option2.mode = 1;

    [train_accuracy1, ACC_CV(1,i)] = RVFL_train_val(trainX, trainY, testX, testY, option1);
    [train_accuracy2, ACC_CV(2,i)] = RVFL_train_val(trainX, trainY, testX, testY, option2);

end
ACC_CV_mean = mean(ACC_CV, 2);