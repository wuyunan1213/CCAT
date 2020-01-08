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
nPics = 12;

Screen('Preference', 'SyncTestSettings', 0.001);
% Open an on screen window using PsychImaging and color it grey.
debugRect = [10,10, 800,800];
[window, windowRect] = Screen('OpenWindow', screenNumber, grey, debugRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
picName1 = 'pic1.jpg';
theImage1 = imread(picName1);
imageTexture1 = Screen('MakeTexture', window, theImage1);
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
Screen('DrawTextures', window,imageTexture1,[], dstRects);

% Flip to the screen
Screen('Flip', window);


Screen('CloseAll');


