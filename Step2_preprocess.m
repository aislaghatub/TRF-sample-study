study_path='G:\My Drive\MATLAB\TRF_sample_study\TRF-sample-study\';

addpath(genpath([study_path 'EEGlabToolbox\eeglab14_1_2b'])); % add EEGLAB toolbox path
rmpath(genpath([study_path 'EEGlabToolbox\eeglab14_1_2b\plugins\Biosig3.3.0\']));

%% load EEG
subject_name='EL'; 
mat_file_path=[study_path 'eegMatFiles\'];
load([mat_file_path subject_name '.mat'])

% you can plot the data anytime in eeglab GUI: type 'eeglab redraw' in Command
% Window->Plot->Channel Data (Scroll) 

%% filter eeg data between 2 and 8 hz; 
EEG = pop_eegfiltnew(EEG, 2,8);

% plot the data anytime in eeglab GUI: type 'eeglab redraw' in Command
% Window->Plot->Channel Data (Scroll) 

%% resample EEG down to 128Hz
EEG = pop_resample( EEG, 128);

%% save external electrodes (mastoids) separately from cortical electrodes
EEG.external_electrodes=EEG.data(129:end,:); % save external electrodes (mastoids) separately from cortical electrodes
EEG = pop_select( EEG,'channel', [1:128]); % keep only cortical channels; this will erase mastoids from the EEG.data sttructure

%% Load electrode channel locations from a file
load([study_path '128chanlocs.mat'])
EEG.chanlocs=chanlocs;

%% remove noisy channels... threshold can be modified
indelec1=[]; indelec2=[]; indelec3=[];
[~, indelec1] = pop_rejchan(EEG, 'elec',1:EEG.nbchan,'threshold',5,'norm','on','measure','kurt');
[~, indelec2] = pop_rejchan(EEG, 'elec',1:EEG.nbchan,'threshold',5,'norm','on','measure','spec');
[~, indelec3] = pop_rejchan(EEG, 'elec',1:EEG.nbchan ,'threshold',5,'norm','on','measure','prob');
bad_chans=unique([indelec1 indelec2 indelec3]); 
EEG = pop_select( EEG,'nochannel',bad_chans);



%% Interpolate deleted channels
EEG = pop_interp(EEG, chanlocs, 'spherical'); 

%% reference to average of all electrodes 
EEG = pop_reref( EEG, []);

% again we can plot the data
%type 'eeglab redraw' in Command Window->Plot->Channel Data (Scroll) 


%% Select trigger that will be used for epoching
min_trial_number=1;
max_trial_number=15;
arduino_trigger_number=128;

epoch_trig_indices=[];
epoch_trig_types=[];
new_eve_cnt=1;
for event_ind=1:(size(EEG.event,2)-1) % loop across all events(=triggers)
    if EEG.event(event_ind).type<=max_trial_number && EEG.event(event_ind).type>=min_trial_number % if trigger smaller than 15  
        if EEG.event(event_ind+1).type==128 % is the next trigger arduino trigger?            
          epoch_trig_types=[epoch_trig_types EEG.event(event_ind).type]; % save trial trigger number
          epoch_trig_indices=[epoch_trig_indices event_ind+1]; % !! IMPORTANT save index of the next arduino trigger (=event_ind+1);                    
        end
    end
end

%% Delete the 6th trigger (first trigger of type 11 was wrong)
epoch_trig_indices(6)=[];
epoch_trig_types(6)=[];

%% Epoch data - from 0 to 60 seconds after each arduino trigger
EEG = pop_epoch( EEG, {}, [0 60],'eventindices',epoch_trig_indices, 'epochinfo', 'yes'); %% 

% again we can plot the data
%type 'eeglab redraw' in Command Window->Plot->Channel Data (Scroll) 

%% save the trial order somewhere to EEG structure 
EEG.epochdescription=epoch_trig_types;
%.. could be saved somewhere else as well

%% save preprocessed eeg
mat_file_path_preprocessed=[study_path 'eegMatFiles_preprocessed\'];
if ~exist(mat_file_path_preprocessed, 'dir'); mkdir(mat_file_path_preprocessed); end % create folder if does not exist
save([mat_file_path_preprocessed subject_name '.mat'], 'EEG','-v7.3') % save eeg data as *.mat