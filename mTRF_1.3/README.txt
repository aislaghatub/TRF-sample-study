mTRF Toolbox is a MATLAB package that permits the fast computation of the
linear stimulus-response mapping of any sensory system. This mapping can
be modelled in the forward or backward direction efficiently via
multivariate ridge regression. mTRF toolbox is suitable for analysing
EEG, MEG, ECoG and EMG data.

The forward model, or temporal response function (TRF), can be
interpreted using conventional analysis techniques such as time-frequency
and source analysis. The TRF can also be used to predict future responses
of the system given a new stimulus signal. Similarly, the backward model
can be used to reconstruct spectrotemporal stimulus information given new
response data.

mTRF Toolbox facilitates the use of continuous stimuli in
electrophysiological studies as opposed to time-locked averaging
techniques which require discrete stimuli. This enables examination of
how neural systems process more natural and ecologically valid stimuli
such as speech, music, motion and contrast.

mTRF Toolbox is available at:
http://sourceforge.net/projects/aespa/

Table of Contents
=================

* mTRFtrain.m Usage
* mTRFpredict.m Usage
* lagGen.m Usage
* mTRFcrossval.m Usage
* mTRFmulticrossval.m Usage
* Sample Data Sets
* Tips on practical Use
* Examples
* Additional Information

mTRFtrain Usage
===============

mTRFtrain mTRF training function.  
  [MODEL,T,CONST] = MTRFTRAIN(STIM,RESP,FS,DIR,START,FIN) performs 
  multivariate ridge regression on the stimulus signal STIM and the 
  response data RESP to solve for the linear stimulus-response mapping 
  function MODEL. The time lags T should be set in milliseconds between 
  START and FIN and the sampling frequency FS should be defined in Hertz. 
  Pass in DIR==0 to map in the forward direction or DIR==1 to map 
  backwards.

  [MODEL,T] = MTRFTRAIN(...,LAMBDA) sets the ridge parameter value to
  LAMBDA for the regularisation step.

  Inputs:
  stim   - stimulus signal (time by observations)
  resp   - response data (time by channels)
  Fs     - sampling frequency (Hz)
  dir    - direction of mapping (forward==0, backward==1)
  start  - start time lag (ms)
  fin    - finish time lag (ms)
  lambda - ridge parameter

  Outputs:
  model  - linear stimulus-response mapping function (DIR==0: obs by lags
           by chans, DIR==1: chans by lags by obs)
  t      - vector of non-integer time lags (ms)
  const  - regression constant


mTRFpredict Usage
=================

mTRFpredict mTRF prediction function.
  PRED = MTRFPREDICT(STIM,RESP,MTRF,FS,DIR,START,FIN,CONST) predicts the
  outcome PRED of convolving the stimulus signal STIM or the response
  data RESP with the linear stimulus-response mapping function MODEL.
  Pass in DIR==0 to predict RESP or DIR==1 to predict STIM.

  [PRED,RHO,PVAL,MSE] = MTRFPREDICT(...) also returns the correlation
  coefficients RHO between the predicted and original signals, the
  corresponding p-values PVAL and the mean squared error MSE.

  Inputs:
  stim   - stimulus signal (time by observations)
  resp   - response data (time by channels)
  model  - linear stimulus-response mapping function (DIR==0: obs by
           lags by chans, DIR==1: chans by lags by obs)
  Fs     - sampling frequency (Hz)
  dir    - direction of mapping (forward==0, backward==1)
  start  - start time lag (ms)
  fin    - finish time lag (ms)
  const  - regression constant

  Outputs:
  pred   - prediction (DIR==0: time by chans, DIR==1: time by obs)
  rho    - correlation coefficients for each chan or obs
  pVal   - calculated probabilities
  MSE    - mean squared errors

lagGen Usage
============

lagGen Lag generator.
  [XLAG] = LAGGEN(X,LAGS) returns the matrix XLAG containing the lagged
  time series of X for a range of time lags given by the vector LAGS. If
  X contains multiple observations (e.g., channels or frequency bands),
  LAGGEN will concatenate them for each lag along the columns of XLAG.

  Inputs:
  x    - vector or matrix of time series data (time by obs)
  lags - vector of integer time lags (samples)

  Outputs:
  xLag - matrix of lagged time series data (time by lags*obs)

mTRFcrossval Usage
==================

mTRFcrossval mTRF cross-validation function.
  [RHO,PVAL,MSE] = MTRFCROSSVAL(STIM,RESP,FS,DIR,START,FIN,LAMBDA)
  performs leave-one-out cross-validation on the stimulus trials STIM and
  the response trials RESP for the range of ridge parameter vlaues
  LAMBDA. As a measure of performance, it returns the correlation
  coefficients RHO between the predicted and original signals, the
  corresponding p-values PVAL and the mean squared error MSE. The time
  lags T should be set in milliseconds between START and FIN and the
  sampling frequency FS should be defined in Hertz. Pass in DIR==0 to map
  in the forward direction or DIR==1 to map backwards.

  [...,PRED,MODEL] = MTRFPREDICT(...) also returns the predicted signals
  PRED and the linear stimulus-response mapping function MODEL.

  Inputs:
  stim   - stimulus trials [cell: {1,trials}(time by observations)]
  resp   - response trials [cell: {1,trials}(time by channels)]
  Fs     - sampling frequency (Hz)
  dir    - direction of mapping (forward==0, backward==1)
  start  - start time lag (ms)
  fin    - finish time lag (ms)
  lambda - vector of ridge parameter values

  Outputs:
  rho    - correlation coefficients for each chan or obs
  pVal   - calculated probabilities
  MSE    - mean squared errors
  pred   - prediction (DIR==0: trials by lambdas by time by chans,
           DIR==1: trials by lambdas by time by obs)
  model  - linear stimulus-response mapping function (DIR==0: trials by
           lambdas by obs by lags by chans, DIR==1: trials by lambdas by
           chans by lags by obs)

mTRFmulticrossval Usage
=======================

mTRFmulticrossval mTRF multisensory cross-validation function.
  [RHO,PVAL,MSE] = MTRFMULTICROSSVAL(STIM,RESP1,RESP2,RESP3,FS,DIR,START,
  FIN,LAMBDA1,LAMBDA2) performs leave-one-out cross-validation of an
  additive model for multisensory data as follows:
  1. Separate unisensory models are calculated using the stimulus signals
     STIM and the unisensory response data sets RESP1 and RESP2 for the
     range of ridge parameter vlaues LAMBDA1 and LAMBDA2 respectively.
  2. The sum of the unisensory models for every combination of LAMBDA1
     and LAMBDA2 is calculated, i.e., the additive model.
  3. The additive models are validated by testing them on the
     multisnesory response data RESP3.
  As a measure of performance, it returns the correlation coefficients
  RHO between the predicted and original signals, the corresponding
  p-values PVAL and the mean squared error MSE. The time lags T should be
  set in milliseconds between START and FIN and the sampling frequency FS
  should be defined in Hertz. Pass in DIR==0 to map in the forward
  direction or DIR==1 to map backwards. The stimulus trials STIM must
  correspond to the response trials in all three sensory conditions.

  [...,PRED,MODEL] = MTRFPREDICT(...) also returns the predicted signals
  PRED and the linear stimulus-response mapping function MODEL.

  Inputs:
  stim   - stimulus trials {1,trials}(time by observations)
  resp1  - unisensory response trials {1,trials}(time by channels)
  resp2  - unisensory response trials {1,trials}(time by channels)
  resp3  - multisensory response trials {1,trials}(time by channels)
  Fs     - sampling frequency (Hz)
  dir    - direction of mapping (forward==0, backward==1)
  start  - start time lag (ms)
  fin    - finish time lag (ms)
  lambda - vector of ridge parameter values

  Outputs:
  rho    - correlation coefficients for each chan or obs
  pVal   - calculated probabilities
  MSE    - mean squared errors
  pred   - prediction (DIR==0: trials by lambdas1 by lambdas2 by time by
           chans, DIR==1: trials by lambdas1 by lambdas2 by time by obs)
  model  - linear stimulus-response mapping function (DIR==0: trials by
           lambdas1 by lambdas2 by obs by lags by chans, DIR==1: trials
           by lambdas1 by lambdas2 by chans by lags by obs)

Sample Data Sets
================

contrast_data.mat
This MATLAB file contains 3 variables. The first is a matrix consisting
of 120 seconds of 128-channel EEG data. The second is a vector consisting
of a normalised sequence of numbers that indicate the contrast of a
checkerboard that was presented during the EEG at a rate of 60 Hz. The
third is a scaler which represents the sample rate of the contrast signal
and EEG data (128 Hz). See Lalor et al. (2006) for further details.

coherentMotion_data.mat
This MATLAB file contains 3 variables. The first is a matrix consisting
of 200 seconds of 128-channel EEG data. The second is a vector consisting
of a normalised sequence of numbers that indicate the motion coherence of
a dot field that was presented during the EEG at a rate of 60 Hz. The
third is a scaler which represents the sample rate of the motion signal
and EEG data (128 Hz). See Gonçalves et al. (2014) for further details.

speech_data.mat
This MATLAB file contains 4 variables. The first is a matrix consisting
of 120 seconds of 128-channel EEG data. The second is a matrix consisting
of a speech spectrogram. This was calculated by band-pass filtering the 
speech signal into 128 logarithmically-spaced frequency bands between 100 
and 4000 Hz and taking the Hilbert transform at each frequency band. The 
spectrogram was then downsampled to 16 frequency bands by averaging 
across every 8 neighbouring frequency bands. The third variable is the 
broadband envelope, obtained by taking the mean across the 16 narrowband 
envelopes. The fourth variable is a scaler which represents the sample 
rate of the envelope, spectrogram and EEG data (128 Hz). See Lalor & 
Foxe, 2010 for further details.

Tips on Practical Use
=====================

* Ensure that the stimulus and response data have the same sample rate
  and number of samples.
* Downsample the data when conducting large-scale multivariate analyses
  to reduce running time, e.g., 64 Hz or 128 Hz.
* Normalise all data, e.g., between [-1,1] or [0,1]. This will stabalise
  regularisation across trials and enable a smaller parameter search.
* Enter the start and finish time lags in milliseconds. Enter positive
  lags for post-stimulus mapping and negative lags for pre-stimulus
  mapping.
* When using mTRFpredict, always enter the model in its original
  3-dimensional form, i.e., do not remove any singleton dimensions.
* When using mTRFcrossval, the trials do not have to be the same length,
  but using trials of the same length will optimise performance.
* When using mTRFmulticrossval, the trials in each of the three sensory
  conditions should correspond to the trials in the stimulus array.

Examples
========

Contrast: Forward model (TRF/VESPA)
>> load('contrast_data.mat');
>> [w,t] = mTRFtrain(contrastLevel,EEG,128,0,-150,450,1);
>> figure; plot(t,squeeze(w(1,:,23))); xlim([-100,400]);
>> xlabel('Time lag (ms)'); ylabel('Amplitude (a.u.)')

Motion: Forward model (TRF/VESPA)
>> load('coherentmotion_data.mat');
>> [w,t] = mTRFtrain(coherentMotionLevel,EEG,128,0,-150,450,1);
>> figure; plot(t,squeeze(w(1,:,21))); xlim([-100,400]);
>> xlabel('Time lag (ms)'); ylabel('Amplitude (a.u.)')

Speech: Forward model (TRF/AESPA)
>> load('speech_data.mat');
>> [w,t] = mTRFtrain(envelope,EEG,128,0,-150,450,0.1);
>> figure; plot(t,squeeze(w(1,:,85))); xlim([-100,400]);
>> xlabel('Time lag (ms)'); ylabel('Amplitude (a.u.)')

Speech: Spectrotemporal forward model (STRF)
>> load('speech_data.mat');
>> [w,t] = mTRFtrain(spectrogram,EEG,128,0,-150,450,100);
>> figure; imagesc(t,1:16,squeeze(w(:,:,85))); xlim([-100,400]);
>> xlabel('Time lag (ms)'); ylabel('Frequency band')

Speech: Backward model (stimulus reconstruction)
>> load('speech_data.mat');
>> envelope = resample(envelope,64,128); EEG = resample(EEG,64,128);
>> stimTrain = envelope(1:64*60,1); respTrain = EEG(1:64*60,:);
>> [g,t,con] = mTRFtrain(stimTrain,respTrain,64,1,0,500,1e5);
>> stimTest = envelope(64*60+1:end,1); respTest = EEG(64*60+1:end,:);
>> [recon,r,p,MSE] = mTRFpredict(stimTest,respTest,g,64,1,0,500,con);

Additional Information
======================

mTRF Toolbox is available at:
http://sourceforge.net/projects/aespa/

mTRF implementation document is available at:
http://www.bcl.hamilton.ie/~barak/papers/VESPA-intro.pdf

For any questions and comments, please email Dr. Edmund Lalor at:
edmundlalor@gmail.com

Acknowledgments:
This work was supported in part by Science Foundation Ireland (SFI), the
Irish Higher Education Authority (HEA) and the Irish Research Council
(IRC).

References:
* Lalor EC, Pearlmutter BA, Reilly RB, McDarby G, Foxe JJ (2006). The
  VESPA: a method for the rapid estimation of a visual evoked potential.
  NeuroImage, 32:1549-1561.
* Gonçalves NR, Whelan R, Foxe JJ, Lalor EC (2014). Towards obtaining
  spatiotemporally precise responses to continuous sensory stimuli in
  humans: a general linear modeling approach to EEG. NeuroImage,
  97(2014):196-205.
* Lalor, EC, & Foxe, JJ (2010). Neural responses to uninterrupted natural
  speech can be extracted with precise temporal resolution. European
  Journal of Neuroscience, 31(1):189-193.
