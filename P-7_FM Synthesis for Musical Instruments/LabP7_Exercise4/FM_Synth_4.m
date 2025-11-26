function FM_Synth_4(casenum)
    %FM_SYNTH_4 plays a bell sound according to the case number of the
    % table in 4.3. Uses soundsc function.
    %
    %   usage: FM_Synth_4(casenum)
    %
    %   where: casenum = integer between 1 and 6
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
    
    soundsc(xx)

end