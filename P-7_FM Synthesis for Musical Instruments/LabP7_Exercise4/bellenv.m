function yy = bellenv(tau, dur, fsamp)
%BELLENV produces envelope function for bell sounds
%
% usage: yy = bellenv(tau, dur, fsamp);
%
% where tau = time constant
% dur = duration of the envelope
% fsamp = sampling frequency
% returns:
% yy = decaying exponential envelope
% note: produces exponential decay for positive tau
t = 0:1/fsamp:dur;
yy = exp(-t./tau); %I think the amplitude should be 1
end