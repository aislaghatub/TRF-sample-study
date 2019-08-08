study_path='C:\Users\aosulli4\Documents\GitHub\TRF-sample-study\';

addpath([study_path 'mTRF_1.3']); % add TRF toolbox to path

%% load EEG
subject_name='EL'; 
mat_file_path_preprocessed=[study_path 'eegMatFiles_preprocessed\'];
load([mat_file_path_preprocessed subject_name '.mat'])

%% Add data to cell-array
eeg_cell_arr={};
for i=1:EEG.trials
    eeg_cell_arr{i}=EEG.data(:,:,i)';
end

%% Load stimuli envelopes into cell-array
trial_order=EEG.epochdescription; %that is where we stored our labels for epoched EEG
envelope_file_path=[study_path 'audioEnvelopes\'];
envelope_template='gammachirp_256bands_';
stim_cell_arr={};
for i=1:EEG.trials
    trial_label=trial_order(i); % make sure we are loading correct envelope;
    temp_env=load([envelope_file_path envelope_template num2str(trial_label) '.mat']);
    temp_env128hz=temp_env.envelope128;
    stim_cell_arr{i}=temp_env128hz;
end

%% Run Forward TRF
% type "help mTRFcrossval" for more info
lambdas=2.^[-5:5:25];
[r,p,mse,pred,model] = mTRFcrossval(stim_cell_arr,eeg_cell_arr,128,1,0,700,lambdas);
avg_r=mean(mean(r,1),3);
[best_lambda,best_lambda_ind]=max(avg_r);

%% Plot correlations vs lambdas
figure(1)
plot(avg_r); hold on;
scatter(best_lambda_ind,best_lambda); hold off;
xticklabels(num2cell(lambdas))
xlabel('Lambda')
ylabel('Average Correlation (r)')

%% plot average TRF model weights for a selected electrode and best lambda
selected_electrode=49;
avg_model=squeeze(mean(model(:,best_lambda_ind,:,selected_electrode),1)); % average across trials

figure(2)
t=(0:size(model,3)-1)/128;
plot(t,avg_model)
xlabel('Lags')
ylabel('Weights')

%% plot average TRF model weights for all electrodes and best lambda
figure(3)
t=(0:size(model,3)-1)/128;
avg_model=squeeze(mean(model(:,best_lambda_ind,:,:),1)); % average across trials
plot(t,avg_model)
xlabel('Lags')
ylabel('Weights')

%% plot average TRF model weights for a selected timelag and best lambda AKA topoplot
addpath([study_path 'EEGlabToolbox\eeglab14_1_2b']); % add EEGLAB toolbox path
eeglab
rmpath(genpath([study_path 'EEGlabToolbox\eeglab14_1_2b\plugins\Biosig3.3.0\']));
load([study_path '128chanlocs.mat']);

selected_lag=10;
avg_model=squeeze(mean(model(:,best_lambda_ind,selected_lag,:),1)); % average across trials

figure(4)
topoplot(avg_model,chanlocs)

%% plot correlation topoplot
figure(5)
r_topo=squeeze(mean(r(:,best_lambda_ind,:),1));
topoplot(r_topo,chanlocs);
