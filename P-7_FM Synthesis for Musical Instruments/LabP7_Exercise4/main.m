%% FM Synthesis for Musical Instruments - Bells and Clarinets: Lab P7 - Exercise 4

%% 4.1) Generating the Bell Envelopes
% See the file "bellenv.m" for implemenentation
% The bellenv function specializes the FM synthesis formula for a bell
% sound. Intuitively we can hear that a bell sound is strongest towards the
% start, and decays over time. The form of the amplitude envelope A(t) and
% the modulation index envelope I(t) are both decaying exponentials in the
% form y(t) = exp(-t/tau), where tau is a parameter that controls the rate
% of decay. The lines below plot the envelopes for cases 1 and 5. Note that
% since they have the same tau, the two are very similar looking, the main
% difference is the duration.
figure(1);
subplot(1,2,1); plot(bellenv(2, 6, 11025)); title("Case 1"); xlabel("Time"); ylabel("Magnitude");
subplot(1,2,2); plot(bellenv(2,5,11025)); title("Case 5"); xlabel("Time"); ylabel("Magnitude");
sgtitle("Bell Envelopes (Cases 1 and 5)")

%% 4.2) Parameters for the Bell
% See the file "bell.m" for implementation
% The bell function takes the parameters and plugs the appropriate envelope
% into the FM synthesis function. This is where we can get a real sound,
% though in this one it will just be graphed again since 4.3 demonstrates
% the sounds.
figure(2);
subplot(1,2,1); plot(bell([110,220],10,2,6,11025)); title("Case 1"); xlabel("Time"); ylabel("Magnitude");
subplot(1,2,2); plot(bell([250, 350],5,2,5,11025)); title("Case 5"); xlabel("Time"); ylabel("Magnitude");
sgtitle("Bell Sound Graph (Cases 1 and 5)")

%% 4.3) The Bell Sound
% FIXME: Intending to add more cases in the future for extra credit. For
% now, choose case 1 and case 5.
% Two of the six cases presented in the table of section 4.3 are analyzed.

%% 4.3a) - Listening to Sounds of the Bell
%% 4.3a) -> Case 1:
% This bell tone has a very deep and long droning sound, with what feels
% like slow beat tone/reverberation.

FM_Synth_4(1);
pause;

%% 4.3a) -> Case 5:
% This tone feels similar to case one in terms of depth and long droning
% sound, but has a characteristically different initial tone, sounding more
% like a bell you would hear ring in a church or city to tell time.

FM_Synth_4(5);
pause;

%% 4.3b) - Calculating Fundamental Frequencies of the Bell
%% 4.3b) -> Case 1: |fc,  fm,  Io, tau, dur, fs   |
%                   |110, 220, 10, 2,   6,   11025|
% The fundamental frequency is the greatest common divisor of  fc and fm.
% You can verify this by listening to the pure synthesized note at the
% fundamental frequency and comparing it to the sound of the real bell
% sound. They sound "feel" the same if you are unfamiliar with musical
% theory. To those who are more familiar with music, they should sound like
% they center on the same note.

fund_1 = gcd(110,220) % no semicolon so the result can show
FM_Synth_4(1)
pause;
soundsc(cos(2*pi*fund_1.*(0:(1/11025):5)), 11025)
pause;

%% 4.3b) -> Case 5: |fc,  fm,  Io, tau, dur, fs   |
%                   |250, 350, 5,  2,   5,   11025|
% This follows the same procedure.

fund_5 = gcd(250, 350)
FM_Synth_4(5)
pause;
% The sound below sounds quiet for multiple possible reasons. One, human
% hearing is less sensitive to very low and very high frequencies. 50 Hz is
% probably on the lower edge. The second, and probably the more relevant
% reason, is that the audio equipment (headphones, earbuds, speakers) being
% used may not be tuned/designed to produce large amounts of power at these
% low frequencies, prefering mid-range sounds. Check out speaker frequency
% response if you're curious for more!
soundsc(cos(2*pi*fund_5.*(0:(1/11025):5)), 11025)
pause;

%% 4.3c) - Plotting Instantaneous Frequencies
%% 4.3c) -> Case 1
% I(t) is the modulation index envelope, and it has the same form as A(t)
% except that the amplitude is determined by Io. When you increase Io, the
% "ringing" quality of the bell sound is intensified. At extremes, it makes
% the sound tinny and clashing. The close Io is to zero, the closer the
% sound is to a fully synthesized sound.

% f_i(t) is the instantaneous frequency of our sound, and is represented by
% [fc - I(t)*fm*sin(2*pi*fm*t + phi_m)+ dI/dt*cos(2*pi*fm*t + phi_m)]
% Note that phi_m/phi_c are arbitrary constants usually chosen to be -pi/2

% I(t) is our bellenv function multiplied by Io, so dI/dt = -Io/tau * exp(-t/tau)

fc = 110; fm = 220; Io = 10; tau = 2; dur = 6; fs = 11025;
t = 0:(1/fs):dur; %duration 6 seconds at 11025Hz
It = Io.*bellenv(tau,dur,fs);
fi = fc - It.*fm.*sin(2*pi*fm.*t - pi/2) - (Io/tau).*exp(-t./tau).*cos(2*pi*fm.*t - pi/2);
figure(3)
subplot(1,2,1); plot(t, fi); xlabel("Time"); ylabel("f_{i}(t)"); title("Case 1")

%% 4.3c) -> Case 5
% same process.
fc = 250; fm = 350220; Io = 5; tau = 2; dur = 5; fs = 11025;
t = 0:(1/fs):dur; %duration 6 seconds at 11025Hz
It = Io.*bellenv(tau,dur,fs);
fi = fc - It.*fm.*sin(2*pi*fm.*t - pi/2) - (Io/tau).*exp(-t./tau).*cos(2*pi*fm.*t - pi/2);

subplot(1,2,2); plot(t, fi); xlabel("Time"); ylabel("f_{i}(t)"); title("Case 5")
sgtitle("Instantaneous Frequency (Cases 1 and 5)")

%% 4.3d) - Visual Representation (Spectrograms)
%% 4.3d) -> Case 1 Spectrogram
% We already calculated the fundamental frequency (by the process given in
% the lab) to be 110, but from the spectrogram you can see that the
% frequencies are strongest at the start and fall off over time, just like
% the instantaneous frequency. See case 5 for comparisons
figure(4)
% ASIDE: Wrestled with the spectrogram function, took a while to get a feel
% for the time-frequency resolution uncertainty, but I found that a window
% size of 400 does a decent job of showing the harmonic behavior over time,
% while preserving the harmonic resolution. Note, to switch from samples
% and normalized frequency, I needed to specify the sample rate.
subplot(1,2,1); spectrogram(bell([110,220], 10, 2, 6, 11025), 400, [],[], fs); 
title("Case 1")
% (Clean-ish) Harmonics!
% Interestingly, harmonics seem to be driven by integer multiples of the
% modulation frequency being added/subtracted from the carrier frequency.
% I only found this out when observing case 5, but found it worked for case
% 1 as well, except that case 1 has repeated harmonics due to the
% modulation frequency being an integer multiple of the carrier frequency.
% Extremely cool!
xline(abs(110 - 1*220)/1000, '-', "|f_c - 1*f_m| = 110 Hz")
xline(abs(110 + 0*220)/1000, '-', "|f_c +/- 0*f_m| = 110 Hz")
xline(abs(110 - 2*220)/1000, '-', "|f_c - 2*f| = 330 Hz")
xline(abs(110 + 1*220)/1000, '-', "|f_c + 1*f_m| = 330 Hz")
xline(abs(110 - 3*220)/1000, '-', "|f_c - 3*f_m| = 550 Hz")
xline(abs(110 + 2*220)/1000, '-', "|f_c + 2*f_m| = 550 Hz")

%% 4.3d) -> Case 5 Spectrogram
% We already calculated the fundamental frequency (by the process given in
% the lab) to be 50, but from the spectrogram you can see that it's
% stronger at the start and drops off slightly slower. However, you can see
% a lot more harmonic levels rippling out at the frequencies fm and fc.
% You can see that around the fundamental frequencies the tones are the
% strongest, which holds with our idea that it would "sound" right to
% compare the fundamental frequency to the overall sound.
subplot(1,2,2); spectrogram(bell([250,350], 5, 2, 5, 11025), 400, [], [], fs);
title("Case 5")
% Modulation harmonics that start at the difference between carrier and modulation
% frequency, as well as modulation harmonics starting at the carrier
% frequency
xline(abs(250 - 1*350)/1000, '-', "|f_c - 1*f_m| = 100 Hz")
xline(abs(250 + 0*350)/1000, '-', "|f_c +/- 0*f_m| = 250 Hz")
xline(abs(250 - 2*350)/1000, '-', "|f_c - 2*f| = 450 Hz")
xline(abs(250 + 1*350)/1000, '-', "|f_c + 1*f_m| = 600 Hz")
xline(abs(250 - 3*350)/1000, '-', "|f_c - 3*f_m| = 800 Hz")
xline(abs(250 + 2*350)/1000, '-', "|f_c + 2*f_m| = 950 Hz")
sgtitle("Bell Spectrograms (Cases 1 and 5)")

%% 4.3e) - Signal/Envelope Comparison
%% 4.3e) -> Case 1
% This point is actually just a comparison of what we graphed in 4.1 and
% 4.2, so in the code we'll just refer to figures 1 and 2 to talk about
% this. For case 1, you can see in Figure 1 that the line represented there
% essentially covers the outer limit of the graph in figure 2. That tracks
% even just by the name, since an envelope is something that contains
% another piece of information/etc. 

%% 4.3e) -> Case 5
% The analysis here is essentially identical to case 1, just on another
% example. The envelope function in figure 1 represents the outer limit of
% the sound in figure 2. When zoomed in far, you can see that the bell
% sound is a strange combination of sinusoids, but that they're all
% contained within the envelope, which accurately represents the harmonics
% and other components contained in the bell sound beyond the fundamental
% frequency.

%% 4.3f) - Signal Makeup
%% 4.3f) -> Case 1
% Here we will graph about 200 samples in the middle of the signal and
% discuss. I mentioned this slightly in 4.3e) Case 5, but we'll get to see
% this compared directly here.
% It's pretty easy to see that the fundamental frequency of this signal is
% one of the limits fc/fm, because all the oscillations are contained
% within another larger oscillation. This gives the result that it looks
% almost like a square wave with ripples all across the upper/lower limits.
figure(5); start = 4*10^4; end_p = start+200;
subplot(1,2,1); plot(bell([110,220],10,2,6,11025)); title("Case 1"); xlabel("Time"); ylabel("Magnitude"); xlim([start,end_p])

%% 4.3f) -> Case 5
% This is a case where you can clearly see that the fundamental frequency
% is not fc/fm, because unlike case 1, it doesn't contain the ripples
% within a larger oscillation, which leads to strange detours of the signal
% across the oscillation at unusal points. 
subplot(1,2,2); plot(bell([250, 350],5,2,5,11025)); title("Case 5"); xlabel("Time"); ylabel("Magnitude");xlim([start,end_p])
sgtitle("Bell Sound Graph--Close Up (Cases 1 and 5)")

%% 4.4) Comments about the bell

%% Helper Function Declarations


