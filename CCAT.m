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

Screen('Preference', 'SyncTestSettings', 0.001);
% Open an on screen window using PsychImaging and color it grey.
debugRect = [10,10, 800,800];
[window, windowRect] = Screen('OpenWindow', screenNumber, grey, debugRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
picName1 = 'pic1.jpg';
picName2 = 'pic2.jpg';
picName3 = 'pic3.jpg';
picName4 = 'pic4.jpg';
theImage1 = imread(picName1);
theImage2 = imread(picName2);
theImage3 = imread(picName3);
theImage4 = imread(picName4);

imageTexture1 = Screen('MakeTexture', window, theImage1);
imageTexture2 = Screen('MakeTexture', window, theImage2);
imageTexture3 = Screen('MakeTexture', window, theImage3);
imageTexture4 = Screen('MakeTexture', window, theImage4);


% We are going to draw four textures to show how a black and white texture
% can be color modulated upon drawing.
yPos = yCenter;
xPos = linspace(screenXpixels * 0.2, screenXpixels * 0.8, 4);

% Define the destination rectangles for our spiral textures. For this demo
% these will be the same size as out actualy texture, but this doesn't have
% to be the case. See: ScaleSpiralTextureDemo and CheckerboardTextureDemo.
s1 = 50;
s2 = 50;
baseRect = [0 0 s1 s2];
dstRects = nan(4, 4);
for i = 1:4
    dstRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos);
end

% Batch Draw all of the texures to screen
Screen('DrawTextures', window,...
    [imageTexture1, imageTexture2, imageTexture3, imageTexture4],...
    [], dstRects);

% Flip to the screen
Screen('Flip', window);


Screen('CloseAll');
% Now we have drawn to the screen we wait for a keyboard button press (any
% key) to terminate the demo.
KbStrokeWait;
debugRect = [10,10, 400,400];
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, grey, debugRect);
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
[xCenter, yCenter] = RectCenter(windowRect);
xPos = linspace(screenXpixels * 0.2, screenXpixels * 0.8, 4);
yPos = yCenter;
s1 = 100;
s2 = 200;
baseRect = [0 0 s1 s2];
dstRects = nan(4, 4);
for i = 1:4
    dstRects(:, i) = CenterRectOnPointd(baseRect, xPos(i), yPos);
end

