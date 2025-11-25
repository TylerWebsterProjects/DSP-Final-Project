function FM_Synth_4()

cases = [110, 220, 10,  2, 6, 11025;
         220, 440,  5,  2, 6, 11025;
         110, 220, 10, 12, 3, 11025;
         110, 220, 10, .3, 3, 11025;
         250, 350,  5,  2, 5, 11025;
         250, 350,  3,  1, 5, 11025];
casenum = 6; %just the index of above table you'd like to test. You could do a loop if you wanted to test all of them

ff = [cases(casenum, 1), cases(casenum, 2)];

xx = bell(ff, cases(casenum,3), cases(casenum,4), cases(casenum,5), cases(casenum,6));

soundsc(xx)

end
