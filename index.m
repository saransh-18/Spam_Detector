

% Extract Features
file_contents = readFile('emailSample1.txt');
word_indices  = processEmail(file_contents);

% processEmail.m reads the mail and performs the following commands. 

% 1. Lower-casing: The entire email is converted into lower case, so that 
%   captialization is ignored.
% 2. Stripping HTML: All HTML tags are removed from the emails.
% 3. Normalizing URLs: All URLs are replaced with the text "httpaddr".
% 4. Normalizing Email Addresses: All email addresses are replaced with the 
%   text "emailaddr".
% 5. Normalizing Numbers: All numbers are replaced with the text 'number'.
% 6. Normalizing Dollars: All dollar signs ($) are replaced with the text 
%   'dollar'.
% 7. Word Stemming: Words are reduced to their stemmed form. For example, 
%   'discount', 'discounts', 'discounted' and 'discounting' are all replaced 
%   with 'discount'. Sometimes, the Stemmer actually strips off additional 
%   characters from the end, so 'include', 'includes', 'included', and 
%   'including' are all replaced with 'includ'.
% 8. Removal of non-words: Non-words and punctuation have been removed. 
%   All white spaces (tabs, newlines, spaces) have all been trimmed to a 
%   single space character.


% Print Stats
disp(word_indices)

% Now we implement feature extraction which will converts each email into a
%   vector, by using vocabulary list
% Which is if the feature for an email corresponds to whether the -th word 
%   in the dictionary occurs in the email or not.

% Extract Features
features = emailFeatures(word_indices);

%EMAILFEATURES takes in a word_indices vector and produces a feature vector 
%   from the word indices


% Print Stats
fprintf('Length of feature vector: %d\n', length(features));

% This will tell us about how, many letters match with that of our
% dictionary. 

fprintf('Number of non-zero entries: %d\n', sum(features > 0));

% After this we will load a preprocessed training dataset that we will use 
% to train an SVM classifier. spamTrain.mat contains 4000 training examples
% of spam and non-spam email, while spamTest.mat contains 1000 test 
% examples. Each original email was processed using the processEmail and 
% emailFeatures functions and converted into a vector. After loading the 
% dataset, the code will proceed to train a SVM to classify between spam () 
% and non-spam () emails.

% Load the Spam Email dataset
load('spamTrain.mat');
C = 0.1;
model = svmTrain(X, y, C, @linearKernel);

% Predicting the train set accuracy
p = svmPredict(model, X);
fprintf('Training Accuracy: %f\n', mean(double(p == y)) * 100);

% Load the test dataset
load('spamTest.mat');

% Predicting the test set accuracy
p = svmPredict(model, Xtest);
fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);


% Sort the weights and obtin the vocabulary list
[weight, idx] = sort(model.w, 'descend');
vocabList = getVocabList();
for i = 1:15
    if i == 1
        fprintf('Top predictors of spam: \n');
    end
    fprintf('%-15s (%f) \n', vocabList{idx(i)}, weight(i));
end

% complete program
