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
soundsc(150*cos(2*pi*fund_1.*(0:(1/11025):5)), 11025)
pause;

%% 4.3b) -> Case 5: |fc,  fm,  Io, tau, dur, fs   |
%                   |250, 350, 5,  2,   5,   11025|
% This follows the same procedure.

fund_5 = gcd(250, 350)
FM_Synth_4(5)
pause;
soundsc(150*cos(2*pi*fund_5.*(0:(1/11025):5)), 11025) %FIXIT this was working on my version and it's SO quiet here?? I'm confused
pause;

%% 4.3c) -> Case 1:
% I(t) is the modulation index envelope, and it has the same form as A(t)
% except that the amplitude is determined by Io. When you increase Io, the
% "ringing" quality of the bell sound is intensified. At extremes, it makes
% the sound tinny and clashing. The close Io is to zero, the closer the
% sound is to a fully synthesized sound.


%% 4.4) Comments about the bell

%% Helper Function Declarations


