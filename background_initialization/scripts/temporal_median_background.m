clear all, close all, clc;
%% Setting of paths
path_to_change_detection = 'D:\gf\dataset2014\dataset'; % Change this line with your path to the change detection database
background_inti_algorithm = 'median_filter';
%%
folder_challenges = {'badWeather';'baseline';'cameraJitter';'dynamicBackground';...
    'intermittentObjectMotion';'lowFramerate';'nightVideos';'PTZ';'shadow';...
    'thermal';'turbulence'};
folders_categories = {{'blizzard';'skating';'snowFall';'wetSnow'};...
    {'PETS2006';'highway';'office';'pedestrians'};...
    {'badminton';'boulevard';'sidewalk';'traffic'};...
    {'boats';'canoe';'fall';'fountain01';'fountain02';'overpass'};...
    {'abandonedBox';'parking';'sofa';'streetLight';'tramstop';'winterDriveway'};...
    {'port_0_17fps';'tramCrossroad_1fps';'tunnelExit_0_35fps';'turnpike_0_5fps'};...
    {'bridgeEntry';'busyBoulvard';'fluidHighway';'streetCornerAtNight';'tramStation';'winterStreet'};...
    {'continuousPan';'intermittentPan';'twoPositionPTZCam';'zoomInZoomOut'};...
    {'backdoor';'bungalows';'busStation';'copyMachine';'cubicle';'peopleInShade'};...
    {'corridor';'diningRoom';'lakeSide';'library';'park'};...
    {'turbulence0';'turbulence1';'turbulence2';'turbulence3'}};
for i=1:size(folder_challenges,1)
    path_to_results = [pwd,'/../',background_inti_algorithm,'/',folder_challenges{i},'/'];
    if ~exist(path_to_results, 'dir')
        mkdir(path_to_results);
    else
        disp(['Directory "', path_to_results, '" already exists.']);
    end
    for j=1:size(folders_categories{i},1)
        path_raw_imgs = [path_to_change_detection,'/',folder_challenges{i},'/',...
            folders_categories{i}{j},'/input/'];
        disp('Path to raw images:');
        disp(path_raw_imgs);

        list_img_path = dir(path_raw_imgs);
        disp(list_img_path);
        disp(length(list_img_path));

        image_k = imread([path_raw_imgs list_img_path(4).name]);
        [x y z] = size(image_k);
        whole_video = uint8(zeros(length(list_img_path)-2,x*y,'int8'));
        for k=1:length(list_img_path)-2
            image_k = imread([path_raw_imgs list_img_path(k+2).name]);
            image_k = rgb2gray(image_k);
            whole_video(k,:) = reshape(image_k,[1,x*y]);
        end
        background_image = median(whole_video);
        background_image = reshape(background_image,[x y]);
        imwrite(uint8(background_image),[path_to_results,folders_categories{i}{j},'_background.png']);
    end
end
