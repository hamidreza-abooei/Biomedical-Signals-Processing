clc
clear
close all
%% Load data
[train , test] = load_data();
whole_data = [train ; test];

%% Split 0,1
data0 = whole_data(whole_data==0,:);
data1 = whole_data(whole_data==1,:);

%% Plot 
figure()
scatter(data0(:,2),data0(:,3),'b')
hold on
scatter(data1(:,2),data1(:,3),'k')
grid on
legend("0","1")



%% Bayesian => SVM
svm_Mdl = fitcsvm(train(:,2:3), train(:,1));
test_hat_svm = predict(svm_Mdl,test(:,2:3));
conf_svm = confusionmat(test(:,1),test_hat_svm)
svm_percision = (sum(sum((eye(2).*conf_svm))))/sum(conf_svm(:))*100
Whole_pred_svm = predict(svm_Mdl,whole_data(:,2:3));
wrong_pred_svm = whole_data(Whole_pred_svm ~= whole_data(:,1),:);
figure()
scatter(data0(:,2),data0(:,3),'b')
hold on
scatter(data1(:,2),data1(:,3),'k')
scatter(wrong_pred_svm(:,2),wrong_pred_svm(:,3),'r')
grid on
legend("0","1","wrong")
title("wrong illustration distribution in SVM")

%% Naive Bayes
Naive_Mdl = fitcnb(train(:,2:3), train(:,1));
test_hat_naive = predict(Naive_Mdl,test(:,2:3));
conf_Naive = confusionmat(test(:,1),test_hat_naive)
Naive_percision = (sum(sum((eye(2).*conf_Naive))))/sum(conf_Naive(:))*100
Whole_pred_Naive = predict(Naive_Mdl,whole_data(:,2:3));
wrong_pred_Naive = whole_data(Whole_pred_Naive ~= whole_data(:,1),:);
figure()
scatter(data0(:,2),data0(:,3),'b')
hold on
scatter(data1(:,2),data1(:,3),'k')
scatter(wrong_pred_Naive(:,2),wrong_pred_Naive(:,3),'r')
grid on
legend("0","1","wrong")
title("wrong illustration distribution in Naive Bayes")


%% Linear Classifier
Linear_Mdl = fitclinear(train(:,2:3), train(:,1));
test_hat_linear = predict(Linear_Mdl,test(:,2:3));
conf_Linear = confusionmat(test(:,1),test_hat_linear)
Linear_percision = (sum(sum((eye(2).*conf_Linear))))/sum(conf_Linear(:))*100
Whole_pred_linear = predict(Linear_Mdl,whole_data(:,2:3));
wrong_pred_linear = whole_data(Whole_pred_linear ~= whole_data(:,1),:);
figure()
scatter(data0(:,2),data0(:,3),'b')
hold on
scatter(data1(:,2),data1(:,3),'k')
scatter(wrong_pred_linear(:,2),wrong_pred_linear(:,3),'r')
grid on
legend("0","1","wrong")
title("wrong illustration distribution in linear")

%% Nearest Neighbourhood
K_Near_Mdl = fitcknn(train(:,2:3), train(:,1));
test_hat_neighbor = predict(K_Near_Mdl,test(:,2:3));
conf_K_nearest = confusionmat(test(:,1),test_hat_neighbor)
nearest_percision = (sum(sum((eye(2).*conf_K_nearest))))/sum(conf_K_nearest(:))*100
Whole_pred_nearest = predict(K_Near_Mdl,whole_data(:,2:3));
wrong_pred_nearest = whole_data(Whole_pred_nearest ~= whole_data(:,1),:);
figure()
scatter(data0(:,2),data0(:,3),'b')
hold on
scatter(data1(:,2),data1(:,3),'k')
scatter(wrong_pred_nearest(:,2),wrong_pred_nearest(:,3),'r')
grid on
legend("0","1","wrong")
title("wrong illustration distribution in K Nearest neighborhood")

