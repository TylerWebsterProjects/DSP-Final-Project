function xx = bell(ff, Io, tau, dur, fsamp)
%BELL produce a bell sound
%
% usage: xx = bell(ff, Io, tau, dur, fsamp)
%
% where: ff = frequency vector (containing fc and fm)
% Io = scale factor for modulation index
% tau = decay parameter for A(t) and I(t)
% dur = duration (in sec.) of the output signal
% fsamp = sampling rate

t = 0:1/fsamp:dur;
env = bellenv(tau, dur, fsamp); %generate bell envelope
xx = env.*cos(2.*pi.*ff(1).*t+Io.*env.*cos(2.*pi.*ff(2).*t-pi/2)-pi/2);

end
