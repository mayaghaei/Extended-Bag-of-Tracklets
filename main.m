%this is the main function of bag-of-tracklet tracking.

clc;clear all;close all;

%Load Data
addpath('input');
addpath('output');
addpath('SparseFlow')
addpath('SparseFlow/SparseFlow')
addpath('SparseFlow/Kovesi')
addpath('deepmatching')
addpath('faceDetector')

inPath = 'input/';
outPath = 'output/';
inDir = dir(inPath);
isDir = [inDir(:).isdir];
inList = {inDir(isDir).name}';
inList(ismember(inList,{'.','..'})) = [];
inLength = length(inList);
seedPath = 'output/seed/';
trPath = 'output/tracklet/';
cropPath = 'output/cropped/';
botPath = 'output/bot/';
prPath = 'output/prototype/';
confPath = 'output/confidence/';

%% variables
colorThr = 12;%10;higher include more examples
imgType = '.jpg';%change this if you have want to use another image type

%% Generate Seeds
run('genSeed');
fprintf('Seed generation completed successfully! press any key to continue\n') ;
pause;

%% Tracking
% Set the option to use deep-matching or sparse-matching!
% run('Runtracker');%for Sparse matching
run('RuntrackerDeep')%for Deep matching
fprintf('Tracklet generation completed successfully! press any key to continue\n') ;
pause;

%% Confidence
run ('calculateConfidence')
fprintf('Tracklet generation completed successfully! press any key to continue\n') ;
pause;

%% Bag-of-Tracklets
run('BOT');
fprintf('BOT generation completed successfully! press any key to continue\n') ;
pause;

%% Exclude Unreliable BoTs
run('excludeUnBot');
fprintf('Unreliable BOTs excluded successfully! press any key to continue\n') ;
pause;

%% Prototype Extraction
run('prototype');
fprintf('Prototypes extracted successfully! press any key to continue\n') ;
pause;

%% Occlusion treatment
run('finalPrototype');
fprintf('Final prototypes are extracted successfully! Find them in the folder "output\prototype" \n') ;
pause;

%% Show results

%% Validation results

%% ILDA % GMCP
