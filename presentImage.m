clear all;
close all;

doublebuffer = 1;

myKeyCheck;
rand('state',sum(100*clock));


%=========== display ===========
dp.fps = 60; % frames per second
dp.ifi = 1/dp.fps;
dp.hifi = dp.ifi/2;
% dp.vdmm = 225; % visual distance in mm
dp.vdmm = 570; % visual distance in mm
% dp.wmm = 315; % screen width in mm
dp.wmm = 520; % screen width in mm
dp.wpix = get(0,'ScreenSize'); % dp.wpix(3): screen width in pixel
dp.wdeg = atan2(dp.wmm/2, dp.vdmm)*2*180/pi; % screen width in visual angle (deg)
dp.ppd = dp.wpix(3)/dp.wdeg; % pixel per digree

[width height] = Screen('WindowSize', 0);
[center.x center.y] = RectCenter([0 0 width height]);

%=========== response ===========
KbName('UnifyKeyNames')
keys.r = KbName('rightarrow');
keys.l = KbName('leftarrow');
keys.u = KbName('uparrow');
keys.d = KbName('downarrow');
keys.esc = KbName('escape');
keys.spc = KbName('Space');

%=========== image load ==========
pic_original = imread('.\images\casserole-dish-2776735_960_720.jpg');
pic_type1 = imread('.\images\test01.jpg');
pic_type2 = imread('.\images\test02.jpg');

% ======================================
%            open the screen
% ======================================
screens = Screen('Screens');
screenNumber = max(screens);
[width height] = Screen('WindowSize', screenNumber);
[wptr rect] = Screen('OpenWindow', screenNumber, 0);
Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[center.x center.y] = RectCenter(rect);

black=BlackIndex(wptr);
white=WhiteIndex(wptr);

ListenChar(2);
HideCursor;


%---- open offScreen to draw flicker stimuli ----
ind_type1 = Screen('MakeTexture', wptr, pic_type1);
ow(1) = Screen('OpenOffscreenWindow', wptr, 0);
Screen('DrawTexture', ow(1), ind_type1);

ind_type2 = Screen('MakeTexture', wptr, pic_type2);
ow(2) = Screen('OpenOffscreenWindow', wptr, 0);
Screen('DrawTexture', ow(2), ind_type2);

%------- set text parameters --------
Screen('Preference', 'TextAlphaBlending', 1);
while KbCheck; end
KbWait(-1);
while KbCheck; end
% t1 = GetSecs;

vbl = Screen('Flip', wptr);

%----- Maximum priority level --------
topPriorityLevel = MaxPriority(wptr);
Priority(topPriorityLevel);

%====== start presentation =========
for ii = 1:60*5
  % type1
  Screen('CopyWindow', ow(1), wptr);
  vbl = Screen('Flip', wptr, vbl + dp.hifi);
  % type2
  Screen('CopyWindow', ow(2), wptr);
  vbl = Screen('Flip', wptr, vbl + dp.hifi);
end

ShowCursor;
ListenChar(0);
Screen('CloseAll');