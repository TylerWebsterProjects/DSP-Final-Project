%% Lab S-7: Spectrograms of AM and FM Signals -- Benson Willie

%% 2.1.1 MATLAB Code for Beat Signals

Amp = 10;        % B
fc  = 1024;      % center frequency (Hz)
fDelta = 4;      % modulating frequency f_Δ (Hz)
phic = 2*pi*rand;        % random phase φ_c
phiDelta = 2*pi*rand;    % random phase φ_Δ
tStart = 0;      % start time (s)
tStop  = 5;      % stop time (s)
fs = 8000;       % sampling rate (samples/s)

tt = tStart:1/fs:tStop;
xx = Amp*cos(2*pi*fc*tt + phic) .* cos(2*pi*fDelta*tt + phiDelta);

% Plot time signal (first 0.5 sec to see beat envelope)
figure; plot(tt, xx); xlim([0 0.5]); grid on;
title('Beat signal, f_\Delta = 4 Hz');
xlabel('Time (s)'); ylabel('Amplitude');


%% 2.1.2 Beat Note Spectrograms

% Expected spectral lines from:
% cos a cos b = (1/2)[cos(a+b) + cos(a-b)]
% -> tones at f_c ± f_Δ

f1 = fc - fDelta;
f2 = fc + fDelta;
disp("Expected spectral lines (Hz): " + f1 + " and " + f2);

% Spectrograms with increasing section length
Llist = [256 512 1024 2048 2500 3000 3500 4096 8192];

for Lsect = Llist
    do_spec(xx, fs, Lsect, sprintf('Beat spectrogram, L_{SECT}=%d', Lsect), false);
end

% Smallest section length that resolves two lines (from your observation)
Lsect_min = 3000;
Tsect_min = Lsect_min/fs;

% Comment for 2.1.2(c):
% At L_SECT=256, the spectrogram shows a single thick band near 1024 Hz
% (not two separate horizontal lines) → insufficient frequency resolution.

% RESULTS (2.1.2):
% Expected spectral lines: f1 = 1020 Hz, f2 = 1028 Hz.
% Smallest L_SECT resolving two lines: L_SECT,min = 3000 samples.
% T_SECT,min = L_SECT,min / fs = 3000/8000 = 0.375 s.


%% 2.1.3 Inverse Relationship: Section Length vs Frequency Resolution

% (a) Determine proportionality constant C from:
% |f1 - f2| = C / T_SECT

df = abs(f2 - f1);        % separation for fDelta = 4  (8 Hz)
C  = df * Tsect_min;      % C = |f1-f2| * T_SECT,min = 8 * 0.375 = 3.0
disp("Computed C = " + C);

% (b) Change fDelta to 16 Hz, predict Lsect, then verify
fDelta2 = 16;
f1b = fc - fDelta2;       % 1008 Hz
f2b = fc + fDelta2;       % 1040 Hz
df2 = abs(f2b - f1b);     % 32 Hz separation

Tsect_pred = C/df2;       % predicted section duration
Lsect_pred = Tsect_pred * fs;    % predicted length in samples (≈ 750)
Lsect_use  = 1024;        % convenient power-of-two window close to prediction

disp("Predicted Tsect for fDelta=16: " + Tsect_pred + " s");
disp("Predicted Lsect (theoretical) for fDelta=16: " + Lsect_pred);
disp("Using Lsect = " + Lsect_use + " samples for spectrogram.");

% Generate new beat signal and verify resolution
xx2 = Amp*cos(2*pi*fc*tt + 2*pi*rand) .* cos(2*pi*fDelta2*tt + 2*pi*rand);
do_spec(xx2, fs, Lsect_use, ...
    sprintf('f_\\Delta=16 spectrogram, L_{SECT}=%d', Lsect_use), false);

% RESULTS (2.1.3):
% |f1-f2| = 8 Hz for fDelta = 4.
% Measured minimum section length: L_SECT,min = 3000 samples
% → T_SECT,min = 3000/8000 = 0.375 s.
% Proportionality constant: C = |f1-f2| * T_SECT,min = 8 * 0.375 = 3.0.
%
% For fDelta = 16, the two tones are at 1008 Hz and 1040 Hz
% → |f1-f2| = 32 Hz.
% Predicted T_SECT = C / |f1-f2| = 3 / 32 ≈ 0.09375 s
% → Predicted L_SECT ≈ 0.09375 * 8000 = 750 samples.
% In practice, we used L_SECT = 1024 (a nearby power of two).
% The spectrogram with L_SECT = 1024 clearly shows two distinct lines
% near 1008 Hz and 1040 Hz, confirming that the inverse relationship
% is a good approximation.

%% Functions

function do_spec(x, fs, Lsect, titleStr, twoSided)
    if nargin < 5, twoSided = false; end
    figure;

    % If DSP-First plotspec exists, use it
    if exist('plotspec','file') == 2
        if twoSided
            plotspec(x + 1j*1e-12, fs, Lsect); % two-sided trick
        else
            plotspec(x, fs, Lsect);
        end
        colorbar; grid on; title(titleStr);
        return;
    end

    % ---- Toolbox-free STFT fallback ----
    overlap = floor(Lsect/2);
    hop = Lsect - overlap;
    Nfft = Lsect;

    % Custom Hamming window (no toolbox)
    n = (0:Lsect-1).';
    w = 0.54 - 0.46*cos(2*pi*n/(Lsect-1));

    nFrames = floor((length(x) - Lsect)/hop) + 1;
    S = zeros(Nfft, nFrames);

    for m = 1:nFrames
        idx = (1:Lsect) + (m-1)*hop;
        frame = x(idx);
        frame = frame(:).*w;
        S(:,m) = fft(frame, Nfft);
    end

    T = ((0:nFrames-1)*hop + Lsect/2)/fs;

    if twoSided
        Splot = fftshift(S,1);
        F = (-Nfft/2:Nfft/2-1)/Nfft * fs;
    else
        halfN = floor(Nfft/2);
        Splot = S(1:halfN+1, :);
        F = (0:halfN)/Nfft * fs;
    end

    Mag = 20*log10(abs(Splot) + 1e-12);

    imagesc(T, F, Mag);
    axis xy; colorbar;
    xlabel('Time (s)'); ylabel('Frequency (Hz)');
    title([titleStr ' (STFT fallback)']);
    grid on;
end
