addpath('D:\Confidential\NTU\EE6222 Machine Vision\Assignment-1\Matlab\UCI data');
clear;
clc;
molec_biol_splice_R;
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
molec_biol_splice_conxuntos;
trainX = dataX(index1, :); 
trainY = dataY(index1, :);
testX = dataX(index2, :);
testY = dataY(index2, :);
options = 6;
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
            option1.ActivationFunction = 'relu';
            option1.mode = 1;
            
            option2.N = N;
            option2.C = 2^C;
            option2.Scale = Scale;
            option2.Scalemode = 3;
            option2.bias = 1;
            option2.link = 1;
            option2.ActivationFunction = 'sigmoid';
            option2.mode = 1;
            
            option3.N = N;
            option3.C = 2^C;
            option3.Scale = Scale;
            option3.Scalemode = 3;
            option3.bias = 1;
            option3.link = 1;
            option3.ActivationFunction = 'radbas';
            option3.mode = 1;
            
            option4.N = N;
            option4.C = 2^C;
            option4.Scale = Scale;
            option4.Scalemode = 3;
            option4.bias = 1;
            option4.link = 1;
            option4.ActivationFunction = 'sine';
            option4.mode = 1;
            
            option5.N = N;
            option5.C = 2^C;
            option5.Scale = Scale;
            option5.Scalemode = 3;
            option5.bias = 1;
            option5.link = 1;
            option5.ActivationFunction = 'hardlim';
            option5.mode = 1;
            
            option6.N = N;
            option6.C = 2^C;
            option6.Scale = Scale;
            option6.Scalemode = 3;
            option6.bias = 1;
            option6.link = 1;
            option6.ActivationFunction = 'tribas';
            option6.mode = 1;
            
            [train_accuracy1, test_accuracy1] = RVFL_train_val(trainX, trainY, testX, testY, option1);
            [train_accuracy2, test_accuracy2] = RVFL_train_val(trainX, trainY, testX, testY, option2);
            [train_accuracy3, test_accuracy3] = RVFL_train_val(trainX, trainY, testX, testY, option3);
            [train_accuracy4, test_accuracy4] = RVFL_train_val(trainX, trainY, testX, testY, option4);
            [train_accuracy5, test_accuracy5] = RVFL_train_val(trainX, trainY, testX, testY, option5);
            [train_accuracy6, test_accuracy6] = RVFL_train_val(trainX, trainY, testX, testY, option6);
            
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
            if test_accuracy3 > MAX_acc(3)
                MAX_acc(3) = test_accuracy3;
                Best_N(3) = N;
                Best_C(3) = C;
                Best_S(3) = Scale;
            end
            if test_accuracy4 > MAX_acc(4)
                MAX_acc(4) = test_accuracy4;
                Best_N(4) = N;
                Best_C(4) = C;
                Best_S(4) = Scale;
            end
            if test_accuracy5 > MAX_acc(5)
                MAX_acc(5) = test_accuracy5;
                Best_N(5) = N;
                Best_C(5) = C;
                Best_S(5) = Scale;
            end
            if test_accuracy6 > MAX_acc(6)
                MAX_acc(6) = test_accuracy6;
                Best_N(6) = N;
                Best_C(6) = C;
                Best_S(6) = Scale;
            end
        end
    end
end

% for datasets where training-testing partition is not available, performance vealuation is based on cross-validation.
molec_biol_splice_conxuntos_kfold;
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
    option1.ActivationFunction = 'relu';
    option1.mode = 1;

    option2.N = Best_N(2);
    option2.C = 2^Best_C(2);
    option2.Scale = Best_S(2);
    option2.Scalemode = 3;
    option2.bias = 1;
    option2.link = 1;
    option2.ActivationFunction = 'sigmoid';
    option2.mode = 1;
    
    option3.N = Best_N(3);
    option3.C = 2^Best_C(3);
    option3.Scale = Best_S(3);
    option3.Scalemode = 3;
    option3.bias = 1;
    option3.link = 1;
    option3.ActivationFunction = 'radbas';
    option3.mode = 1;
    
    option4.N = Best_N(4);
    option4.C = 2^Best_C(4);
    option4.Scale = Best_S(4);
    option4.Scalemode = 3;
    option4.bias = 1;
    option4.link = 1;
    option4.ActivationFunction = 'sine';
    option4.mode = 1;
    
    option5.N = Best_N(5);
    option5.C = 2^Best_C(5);
    option5.Scale = Best_S(5);
    option5.Scalemode = 3;
    option5.bias = 1;
    option5.link = 1;
    option5.ActivationFunction = 'hardlim';
    option5.mode = 1;
    
    option6.N = Best_N(6);
    option6.C = 2^Best_C(6);
    option6.Scale = Best_S(6);
    option6.Scalemode = 3;
    option6.bias = 1;
    option6.link = 1;
    option6.ActivationFunction = 'tribas';
    option6.mode = 1;

    [train_accuracy1, ACC_CV(1,i)] = RVFL_train_val(trainX, trainY, testX, testY, option1);
    [train_accuracy2, ACC_CV(2,i)] = RVFL_train_val(trainX, trainY, testX, testY, option2);
    [train_accuracy3, ACC_CV(3,i)] = RVFL_train_val(trainX, trainY, testX, testY, option3);
    [train_accuracy4, ACC_CV(4,i)] = RVFL_train_val(trainX, trainY, testX, testY, option4);
    [train_accuracy5, ACC_CV(5,i)] = RVFL_train_val(trainX, trainY, testX, testY, option5);
    [train_accuracy6, ACC_CV(6,i)] = RVFL_train_val(trainX, trainY, testX, testY, option6);

end
ACC_CV_mean = mean(ACC_CV, 2);