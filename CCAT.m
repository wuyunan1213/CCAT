% Clear the workspace and the screen
sca;
close all;
clearvars;

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
black = BlackIndex(screenNumber);

% Do a simply calculation to calculate the luminance value for grey. This
% will be half the luminace values for white
grey = white / 2;

%%%all experiment perimeters

Screen('Preference', 'SyncTestSettings', 0.001);
% Open an on screen window using PsychImaging and color it grey.
debugRect = [10,10, 800,800];
[window, windowRect] = Screen('OpenWindow', screenNumber, grey, debugRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);

%%load the master file(s)
%%load('something.mat')

%%start with the familiarization block. This will just be a combination of text
%%and picture to be presented in the actual experiment. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Familiariation block%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for F = 1:12
    %%present each picture paired with their name in reading. 
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Actual Experiment%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%there are total of 12 pictures so we will loop through pic1 to pic12
imageTexture = [];
picNames = {'cattle', 'sheep', 'kettle', 'flower', 'burger', 'cash', 'bag',...
            'bed', 'shepard', 'shadow', 'house', 'keg'};
%%number of pictures
nPics = numel(picNames);
%%ITI, intertrial interval
waitTime = 3;
%%%trial level presentation
for t = 1:nTrials
    
    picNames_shuffled = picNames(randperm(nPics));
    for i = 1:nPics
        picName = [picNames_shuffled{i},'.jpg'];
        theImage = imread(picName);
        imageTexture = [imageTexture, Screen('MakeTexture', window, theImage)];
    end
    % Linearly interpolate the x and y positions based on the current screen
    % size
    yPos = linspace(screenYpixels * 0.2, screenYpixels * 0.8, 3);
    xPos = linspace(screenXpixels * 0.2, screenXpixels * 0.8, 4);

    % Define the destination rectangles for our spiral textures. For this demo
    % these will be the same size as out actualy texture, but this doesn't have
    % to be the case. See: ScaleSpiralTextureDemo and CheckerboardTextureDemo.
    s1 = 100;
    s2 = 100;

    baseRect = [0 0 s1 s2];
    dstRects = nan(4, nPics);
    for i = 1:4
        for j = 1:3
            dstRects(:,(i-1)*3+j) = CenterRectOnPointd(baseRect, xPos(i), yPos(j));
        end
    end

    % Batch Draw all of the texures to screen
    Screen('DrawTextures', window,imageTexture,[], dstRects);

    %%Finish playing the speech sounds before screen is flipped
    %%some psychportaudio code here. 

    % Linearly interpolate the x and y positions based on the current screen
    % size
    yPos = linspace(screenYpixels * 0.2, screenYpixels * 0.8, 3);
    xPos = linspace(screenXpixels * 0.2, screenXpixels * 0.8, 4);

    % Define the destination rectangles for our spiral textures. For this demo
    % these will be the same size as out actualy texture, but this doesn't have
    % to be the case. See: ScaleSpiralTextureDemo and CheckerboardTextureDemo.
    s1 = 100;
    s2 = 100;

    baseRect = [0 0 s1 s2];
    dstRects = nan(4, nPics);
    for i = 1:4
        for j = 1:3
            dstRects(:,(i-1)*3+j) = CenterRectOnPointd(baseRect, xPos(i), yPos(j));
        end
    end

    % Batch Draw all of the texures to screen
    Screen('DrawTextures', window,imageTexture,[], dstRects);

    %%Finish playing the speech sounds before screen is flipped
    %%some psychportaudio code here. 






    % Flip to the screen
    Screen('Flip', window);


    %get user response
    [clicks,x,y,whichButton]=GetClicks(window,0);
    %as long as the x value is within the frames of pic 1,4,7,10 and y value is
    %withn the frames of 1,2,3, then we save these x, y coordinates.
    while ~(((x>=dstRects(1, 1)&&x<=dstRects(3, 1))||...
           (x>=dstRects(1, 4)&&x<=dstRects(3, 4))||...
           (x>=dstRects(1, 7)&&x<=dstRects(3, 7))||...
           (x>=dstRects(1, 10)&&x<=dstRects(3, 10)))&&...
           ((y>=dstRects(1, 2)&&y<=dstRects(1, 4))||...
           (y>=dstRects(2, 2)&&y<=dstRects(4, 2))||...
           (y>=dstRects(2, 3)&&y<=dstRects(4, 3))))

        [clicks,x,y,whichButton]=GetClicks(window,0);
    end

    %recording subjects' response
    %find which image was selected based on the absolute value of the distances
    absDist = abs(dstRects(1, :) - x) + abs(dstRects(2, :) - y);
    selectedIndex = find(absDist == min(absDist));
    picNames_shuffled{selectedIndex}; %%This is the picture that was selected

    %%%highlight the selected image
    colorMod = repmat(255,3,12);
    colorMod(:, selectedIndex) = repmat(100,3,1); 
    Screen('DrawTextures', window,imageTexture,[], dstRects, [],[],[],colorMod);
    % Flip to the screen
    Screen('Flip', window);
    %%wait this long before starting the next trial
    WaitSecs(waitTime);
end

%%test changes
Screen('CloseAll');