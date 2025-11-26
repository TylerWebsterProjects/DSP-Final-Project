function out = FM_Synth_4(casenum, verbose, nosound)
    %FM_SYNTH_4 plays a bell sound according to the case number of the
    % table in 4.3. Uses soundsc function.
    %
    %   usage: FM_Synth_4(casenum, verbose)
    %
    %   where: casenum = integer between 1 and 6
    %          verbose = boolean, optional argument if you want case info
    %                    output. false by default
    %          nosound = boolean, optional argument if you want the bell
    %                    sound to play. false by default
    %   returns:
    %              out = if verbose is true, provides 1x2 cell array
    %                    containing case information and bell sound profile
    %                    array
    %   note:
    %          case information in out is formatted in the order of:
    %               (1) fc - Carrier frequency (Hz)
    %               (2) fm - Modulation frequency (Hz)
    %               (3) Io - Modulation Index Envelope
    %               (4) tau - decay parameter (sec)
    %               (5) dur - Duration of output signal (sec)
    %               (6) fsamp - sampling rate of the sound profile signal 
    %                           (Hz)

    arguments
        casenum 
        verbose = false;
        nosound = false;
    end

    cases = [110, 220, 10,  2, 6, 11025;
             220, 440,  5,  2, 6, 11025;
             110, 220, 10, 12, 3, 11025;
             110, 220, 10, .3, 3, 11025;
             250, 350,  5,  2, 5, 11025;
             250, 350,  3,  1, 5, 11025];

    % Override user input:
    % casenum = 1; %just the index of above table you'd like to test. You could do a loop if you wanted to test all of them
    
    ff = [cases(casenum, 1), cases(casenum, 2)];
    
    xx = bell(ff, cases(casenum,3), cases(casenum,4), cases(casenum,5), cases(casenum,6));
    
    if ~nosound
        soundsc(xx)
    end

    if verbose
        % If we specify verbosity, output relevant case information and
        % bell profile in cell array
        out = {cases(:,1), xx};
    end
end