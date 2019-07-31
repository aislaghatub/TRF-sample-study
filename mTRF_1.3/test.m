%Speech: Forward model (TRF/AESPA)
load('speech_data.mat');

envelope=envelope/(max(envelope)-min(envelope));
[w,t] = mTRFtrain(envelope,EEG,128,1,-150,450,1000);
figure; plot(t,squeeze(w(1,:,85))); xlim([-100,400]);
xlabel('Time lag (ms)'); ylabel('Amplitude (a.u.)')