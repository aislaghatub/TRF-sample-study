% Converts *.bdf into Matlab/EEGlab matrix


addpath('C:\Users\abednar2\Desktop\TRF_sample_analysis\EEGlabToolbox\eeglab14_1_2b'); % add EEGLAB toolbox path
%IMPORTANT: open eeglab by typing "eeglab" in the command window;
%File->Memory and other options-> UNTICK "If set, use single precision...."->Click OK

subject_name='EL';
bdf_file_path='C:\Users\abednar2\Desktop\TRF_sample_analysis\bdfFiles\';
EEG=pop_biosig([bdf_file_path subject_name '.bdf']); % if not installed, dialog will open-> confirm installation
% there might few warnings e.g. but ignore them
if ~isa(EEG.data,'double'); error('Data loaded as SINGLE. Change EEGLAB settings'); end % for slow people....

mat_file_path='C:\Users\abednar2\Desktop\TRF_sample_analysis\eegMatFiles\';
if ~exist(mat_file_path, 'dir'); mkdir(mat_file_path); end % create folder if does not exist
save([mat_file_path subject_name '.mat'], 'EEG','-v7.3') % save eeg data as *.mat

               