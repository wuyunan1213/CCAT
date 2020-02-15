%BeerPier cueweighting MMN script
%
%   FILE NAME       : Beer vs Pier VOT and F0 test
%   DESCRIPTION     : This is a
%
%RETURNED ITEMS
%
%   XXX_BPCW_date   : *.mat and *.csv containing sID, blocks, stimulus
%   details and stimulus categories and subject responses.
%
%(C)This script was written by Charles Wu 
%

%% INITIALIZATION
close all;
clear all; %#ok<CLALL>
clc;

%cd('C:\Users\Lab User\Desktop\Experiments\Charles\EEG')

fprintf('Beginning BP passive explore.\n\n')

% Get the screen numbers. This gives us a number for each of the screens
% attached to our computer.
screens = Screen('Screens');

% To draw we select the maximum of these numbers. So in a situation where we
% have two screens attached to our monitor we will draw to the external
% screen.
screenNumber = 0;

% Define black and white (white will be 1 and black 0). This is because
% in general luminace values are defined between 0 and 1 with 255 steps in
% between. All values in Psychtoolbox are defined between 0 and 1
white = 255;
screenNumber = max(screens);
black = BlackIndex(screenNumber);
white = WhiteIndex(screenNumber);


% Do a simply calculation to calculate the luminance value for grey. This
% will be half the luminace values for white
grey = white / 2;

%%%all experiment perimeters

Screen('Preference', 'SyncTestSettings', 0.001);
% Open an on screen window using PsychImaging and color it grey.

oX=0;
oY=0;
eX=600;
eY=600;

debugRect = [oX, oY, eX, eY];
[win, winRect] = Screen('OpenWindow', screenNumber, grey, debugRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', win);
[scrX,scrY] = RectCenter(winRect);

dI = 2; %%list the audio device to be used
repNumber = 5; %%the baseline block should be repeated 4 times
blockNumber = 2;%change to 20 eventually number of exposure+test blocks in the actual experiment, 
                %%which is the canonical/reverse part. 
trialNumber = 30;%%Number of trials within an exposure block, should always be 30
                 %%%for this experiment

fs = 44100;
% Step One: Connect to and properly initialize RME sound card
devices = PsychPortAudio('GetDevices');
pamaster = PsychPortAudio('Open',devices(dI).DeviceIndex,1,1,fs,2);

% fs = Devices(i).defaultSampleRate;
% playDev = Devices(i).deviceID;
% playrec('init',fs,playDev,-1,14,-1);
% fprintf('Success! Connected to %s.\n', Devices(i).name);
% stimchanList=[1,2];

% Step Two: Yippee, we're online. Now, we establish the subject's ID number
% and load in Master List and Response templates.
fprintf('\nPlease follow the prompt in the pop-up window.\n\n')

subj = char(inputdlg('Please enter the subject ID number:','Subject ID'));

fprintf('Loading sound files. This may take a moment...')
load('BPmaster_baseline.mat');
load('BPmaster_canonical.mat');
load('BPmaster_reverse.mat');
load('BPresp.mat');
fprintf('Done.\n')
%%column names of the stimfiles: 
%%1.sound file 2. VOT value 3. F0 value 4. VOT level 5. F0 level. 6. block
%%7.stimulus type 8. audio

responseKeyIdx = KbName('space');
z = KbName('z');
m = KbName('m');

enabledkeys = RestrictKeysForKbCheck([responseKeyIdx,z,m]);

%% STIMULUS PRESENTATION FOR BASELINE BLOCKS DURING EEG CAPING
curText = ['<color=ffffff>In this experiment, you will hear either the word '...
    '<color=ffff00><b>"Beer"<b> <color=ffffff>or the word <color=ffff00><b>"Pier'...
    '"<b> <color=ffffff>\n\n'...
    'If you hear "beer" click the box labeled "beer"'...
    '\nIf you hear "pier", click the box labeled "pier".'...
    '\n\nIf you are unsure, '...
    'make your best guess.\n\n'...
    'This is the first part of the experiment while the experimenter '...
    'is setting up the EEG equipment on your scalp. \n'...
    'There is only one block in this part \n\n'...
    '<b>Press "spacebar" to begin.<b>'];
%curText = 'In this experiment, you will hear either the word "BEER" or the word "PIER" \n\n\n\n If you hear "BEER", click the box labelled "BEER". \n\n If you hear "PIER" click the box labelled "PIER". \n\n If you are unsure, make your best guess.\n\n\n\n Every once in a while, you can take a break \n\n and we will show you a short cartoon with the same sounds in the background. \n\n You just need to watch the cartoon and relax and ignore the sounds. \n\n\n\n Press SPACEBAR to begin';
DrawFormattedText2(curText,'win',win,'sx',eX/10,'sy',eY/8,'xalign','left','yalign','top','wrapat',200);
%DrawFormattedText(win, curText, 'center', 'center', white);
Screen('Flip',win);
oldtype = ShowCursor(0);
KbWait([],2);

baselineTN = 25*repNumber;

presentation = [];
for i = 1:repNumber
    A = randperm(25);
    presentation=[presentation, A];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BASELINE BLOCKS  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%baselineTN
for j=1:5 %change the trial number
    %Flip Screen to be Beer Pier blocks
    respToBeMade = true;
    rect1 = CenterRectOnPoint([20 80 eX-eX/2 eY-eY/3],scrX-eX/3,eY/2);
    rect2 = CenterRectOnPoint([20 80 eX-eX/2 eY-eY/3],scrX+eX/3,eY/2);   
    Screen('FillRect', win, [135 206 250], rect1);
    Screen('FillRect', win, [135 206 250], rect2);
    curText='Beer                                                     Pier';
    DrawFormattedText(win,curText,'center','center',[0 0 0]);
    Screen('Flip',win);

    signal=BPCWmaster_baseline.Stimuli{presentation(j),8};

    BPCWresp(j,1:7)=BPCWmaster_baseline.Stimuli(presentation(j),1:7);

    signaltwo=[signal';signal'];
    
    PsychPortAudio('FillBuffer', pamaster, signaltwo);
    PsychPortAudio('Start', pamaster, 1, 0, 1);
    PsychPortAudio('Stop', pamaster, 1, 1);
    %PsychPortAudio('FillBuffer', pamaster, signaltwo);
    %t1 = PsychPortAudio('Start', pamaster, 1, 0, 1);
    %PsychPortAudio('Stop', pamaster , 1, 1);
    while respToBeMade == true
        [keyIsDown, secs, keyCode] = KbCheck;
        if keyCode(z) %selected 'beer'
                BPCWresp{j,8}='beer'; 

                %Flip Screen to be Beer Pier blocks
                [scrX,scrY] = RectCenter(winRect);
                rect1 = CenterRectOnPoint([20 80 eX-eX/2 eY-eY/3],scrX-eX/3,eY/2);
                rect2 = CenterRectOnPoint([20 80 eX-eX/2 eY-eY/3],scrX+eX/3,eY/2); 
                Screen('FillRect', win, [255 255 204], rect1);
                Screen('FillRect', win, [135 206 250], rect2);
                curText='Beer                                                     Pier';
                DrawFormattedText(win,curText,'center','center',[0 0 0]);

                respToBeMade = false;

        elseif keyCode(m) %clicked "pier"
                BPCWresp{j,8}='pier';
                %LOOK LATER

                %Flip Screen to be Beer Pier blocks
                [scrX,scrY] = RectCenter(winRect);
                rect1 = CenterRectOnPoint([20 80 eX-eX/2 eY-eY/3],scrX-eX/3,eY/2);
                rect2 = CenterRectOnPoint([20 80 eX-eX/2 eY-eY/3],scrX+eX/3,eY/2); 
                Screen('FillRect', win, [135 206 250], rect1);
                Screen('FillRect', win, [255 255 204], rect2);
                curText='Beer                                                     Pier';
                DrawFormattedText(win,curText,'center','center',[0 0 0]);

                respToBeMade = false;
        end

    end
   Screen('Flip',win);
   WaitSecs(1);
end


stimchanList=[1,2];%%%change the stimulus channels to 
%%3 because we are adding an EEG trigger channnel here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% STIMULUS PRESENTATION FOR CANONICAL AND REVERSE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Step Five: Play the canonical and reverse blocks with the MMN block at the
%end
silence = zeros(fs,1);
ISI_length = 700; %%%ISI should not be jittered!!
ISI = int16(ISI_length/1000*44100);

curText = ['<color=ffffff>Now we are ready to start the second part.\n'...
    'You will be doing the same thing in this part.\n\n'...
    'There will be XXXX blocks. At the end of each block, you will watch a short video.\n'...
    'The video will have some embedded speech sounds. You can ignore those sounds and focus on the video.\n\n'...
    '\n<b>Please wait until the experimenter is ready.<b>'];
DrawFormattedText2(curText,'win',win,'sx',400,'sy',400,'xalign','left','yalign','top','wrapat',59);
%DrawFormattedText(win, curText, 'center', 'center', white);
Screen('Flip',win);
oldtype = ShowCursor(0);
KbWait([],2);

trig_len = 441; %10ms of trigger length

presentation = [];
for i=1:blockNumber
    A=randperm(10);
    B=randperm(10);
    C=randperm(10);
    presentation=[presentation;A(1:10),B(1:10),C(1:10)];
end

for i=1:blockNumber %%change the block number
    curText = [sprintf('Beginning block %d of %d.',i,blockNumber)...
        '\nNow you can take a break and stretch a little. \n'...
        'But Please try to minimize your movement during the block,'...
        'especially during the movie\n'...
        '\n\nPress "spacebar" to continue.'];
    DrawFormattedText(win,curText,'center','center',[255 255 255]);
    Screen('Flip',win);
    KbWait([],2);
    %%%exposure block(canonical/reverse)
    for j=1:trialNumber %change the trial number

        %Flip Screen to be Beer Pier blocks
%         [scrX,scrY] = RectCenter(winRect);
%         rect1 = CenterRectOnPoint([0 0 500 500],scrX-325,scrY);
%         rect2 = CenterRectOnPoint([0 0 500 500],scrX+325,scrY);   
%         Screen('FillRect', win, [135 206 250], rect1);
%         Screen('FillRect', win, [135 206 250], rect2);
%         curText='Beer                                                     Pier';
%         DrawFormattedText(win,curText,'center','center',[0 0 0]);
%         Screen('Flip',win);
%           instead of presenting instructions, we want to play a movie
%           here. 

        if i <= blockNumber/2 %%present the canonical blocks first
            stim=BPCWmaster_can.Stimuli(presentation(i,j),1:8);
        else
            stim=BPCWmaster_rev.Stimuli(presentation(i,j),1:8);
            stream = [stim{8}; ISI];
        end
        %%%concatenate all 3 channels of signals
        
    signal = [silence; stream; silence];
    signalthree=[signal'; signal'];
        
    
        % Select screen for display of movie:
    moviename = ['C:\Users\Lab User\Desktop\Experiments\Charles\EEG\crunch\clip', int2str(i),'.mp4' ];
    screenid = max(Screen('Screens'));
    % Open 'windowrect' sized window on screen, with black [0] background color:
    screen=max(Screen('Screens'));
    % Open movie file:
    movie = Screen('OpenMovie', win, moviename, [], [], 2);

    % Start playback engine:
    Screen('PlayMovie', movie, 1);
    
    PsychPortAudio('FillBuffer', pamaster, signalthree);
    PsychPortAudio('Start', pamaster, 1, 0, 1);
    
    while(1)
        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', win, movie);

        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end

        % Draw the new texture immediately to screen:
        Screen('DrawTexture', win, tex, [], debugRect);

        % Update display:
        Screen('Flip', win);

        % Release texture:
        Screen('Close', tex);
    end

    PsychPortAudio('Stop', pamaster, 1, 1);
    %PsychPortAudio('Stop', pamaster , 1, 1);

    % Stop playback:
    Screen('PlayMovie', movie, 0);
    % Close movie:
    Screen('CloseMovie', movie);
    
        
%         PsychPortAudio('FillBuffer', pamaster, signalthree);
%         t1 = PsychPortAudio('Start', pamaster, 1, 0, 1);
%         PsychPortAudio('Stop', pamaster , 1, 1);
    end

    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Test blocks with test stim  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%UNDONE!!!! 
    %%%first create 1s silent period
    silence = zeros(fs,1);
    %%%Then create our counterbalancing conditions such that in odd blocks,
    %%%we have b as standard, p as deviant and in even blocks, we have the
    %%%opposite
    %%%we do this by loading different scripts depending on the block
    %%%number
    %%Now counterbalance the standard/deviant stimuli
    load('BPmaster_test_v1.mat')
        repIndex = baselineTN+(i-1)*trialNumber+j;
    if i <= blockNumber/2 %%present the canonical blocks first
        stim=BPCWmaster_can.Stimuli(presentation(i,j),1:8);

        BPCWresp(repIndex,1:7)=stim(1:7);%%%fill the stim info

    else %%%%then the reverse blocks
        BI = 10;
        stim=BPCWmaster_rev.Stimuli(presentation(i,j),1:8);
        trig = zeros(length(stim{8}),1);
        %%4 different trigger conditions

        BPCWresp(repIndex,1:7)=stim(1:7);%%%fill the stim info

    end
    signal = [silence; build; silence];
    trigger_MMN = [silence; trigger_build; silence];
    

    signalthree=[scale*signal,scale*signal,trigger_MMN];
    
    pageno = playrec('play',signalthree,stimchanList);
    

            %get user response
        [clicks,x,y,whichButton]=GetClicks(win,0);
        while ~((((x>=scrX-575)&&(x<=scrX-75))&&((y>=scrY-250)&&(y<=scrY+250)))||(((x>=scrX+75)&&(x<=scrX+575))&&((y>=scrY-250)&&(y<=scrY+250))))
            [clicks,x,y,whichButton]=GetClicks(win,0);
            if (((x>=scrX-575)&&(x<=scrX-75))&&((y>=scrY-250)&&(y<=scrY+250))) %clicked "beer"
                BPCWresp{repIndex,8}='beer'; 

                %Flip Screen to be Beer Pier blocks
                [scrX,scrY] = RectCenter(winRect);
                rect1 = CenterRectOnPoint([0 0 500 500],scrX-325,scrY);
                rect2 = CenterRectOnPoint([0 0 500 500],scrX+325,scrY);
                Screen('FillRect', win, [255 255 204], rect1);
                Screen('FillRect', win, [135 206 250], rect2);
                curText='Beer                                                     Pier';
                DrawFormattedText(win,curText,'center','center',[0 0 0]);
                Screen('Flip',win);

                WaitSecs(1);

            else %clicked "pier"
                BPCWresp{repIndex,8}='pier';

                %Flip Screen to be Beer Pier blocks
                [scrX,scrY] = RectCenter(winRect);
                rect1 = CenterRectOnPoint([0 0 500 500],scrX-325,scrY);
                rect2 = CenterRectOnPoint([0 0 500 500],scrX+325,scrY);
                Screen('FillRect', win, [135 206 250], rect1);
                Screen('FillRect', win, [255 255 204], rect2);
                curText='Beer                                                     Pier';
                DrawFormattedText(win,curText,'center','center',[0 0 0]);
                Screen('Flip',win);

                WaitSecs(1);
            end
        end
        %record user response (in correct location)
    
%     PsychPortAudio('FillBuffer', pamaster, signalthree);
%     t1 = PsychPortAudio('Start', pamaster, 1, 0, 0);
end

%% CLOSEOUT
% Close PTB Screen
Screen('CloseAll');

% Save subject response file. The data saves as BOTH a
% *.mat and *.csv file for extra security. Also, there's a if/else
% statement that will warn the experimenter if an issue with the *.csv save
% process occurs, lest it tells you everything saved properly.

fnamemat = ['C:\Users\Lab User\Desktop\Experiments\Charles\EEG\Results\' subj '_BP_' datestr(datetime('now'),'yyyymmdd') '.mat'];
save(fnamemat,'BPCWresp')

sIDcell=cell(length(BPCWresp),1);
sIDcell(:)={subj};
BPCWresp=cell2table([sIDcell,BPCWresp]);
fnamecsv = ['C:\Users\Lab User\Desktop\Experiments\Charles\EEG\Results\' subj '_BP_' datestr(datetime('now'),'yyyymmdd') '.csv'];
BPCWresp.Properties.VariableNames={'sID','Sound','VOT','F0','VOTlevel','F0level','Block','StimulusType','Response'};
writetable(BPCWresp,fnamecsv);

% Disconnect RME
fprintf('Disconnecting PsychPortAudio...\n')
%playrec('reset');
PsychPortAudio('Close')
fprintf('Playrec successfully disconnected. Goodbye!\n')
