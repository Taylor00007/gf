
function [S_opt_random,indentifier_category_in_nodes,indx_category] = unseen_sampling_pattern(percentage_sampling,...
                        path_to_change_detection,indx_first_image_in_list,...
                        list_of_images_cell,list_raw_images,sequence_excluded)
                      

% This function computes the sampling density for the change detection
% dataset such that any image from the sequence "sequence_excluded" is
% sampled. The sampling density is "percentage_sampling".
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
%%
indentifier_category_in_nodes = [];
random_sampling_pattern = [];
cont_y = 1;
for kk=1:size(folder_challenges,1)
    for y=1:size(folders_categories{kk},1)
        %%
        disp('Debugging path_to_category:');
        disp(path_to_change_detection);
        disp(folder_challenges{kk});
        disp(folders_categories{kk}{y});
        disp('/'); % 添加一个斜杠，确保路径分隔符
        path_to_category = [path_to_change_detection, folder_challenges{kk}, '/', folders_categories{kk}{y}, '/'];
        disp(path_to_category);

        path_to_category = [path_to_change_detection,folder_challenges{kk},'/',...
            folders_categories{kk}{y},'/'];
        file_txt_ID = fopen([path_to_category,'temporalROI.txt'],'r');
        if (file_txt_ID == -1)
            disp([path_to_category,'temporalROI.txt']);
        end
        range_eval = fscanf(file_txt_ID,'%f');
        fclose(file_txt_ID);
        disp('Contents of range_eval:');
        disp(range_eval);
        number_sampling_images = round((range_eval(2)-range_eval(1))*percentage_sampling);
        images_per_category = range_eval(2)-range_eval(1);
        %%
        selected_images_indx = randperm(images_per_category,number_sampling_images);
        selected_images_indx = selected_images_indx + indx_first_image_in_list{kk}(y);
        indx_selected_image_in_node = zeros(length(list_of_images_cell{kk}{y}.list_of_images),1);
        for h=1:length(selected_images_indx)
            selected_image = list_raw_images{kk}{y}(selected_images_indx(h)).name;
            indx_point = strfind(selected_image,'.');
            selected_image(indx_point:end) = [];
            selected_image = [selected_image,'.jpg'];
            indx_selected_image_in_node = [indx_selected_image_in_node | ...
                strcmp(list_of_images_cell{kk}{y}.list_of_images,selected_image)];
        end
        sampling_pattern_in_category = indx_selected_image_in_node;
        if strcmp(folders_categories{kk}{y},sequence_excluded)
            random_sampling_pattern = [random_sampling_pattern;...
                zeros(length(sampling_pattern_in_category),1)];
            indx_category = cont_y;
        else
            random_sampling_pattern = [random_sampling_pattern;...
                sampling_pattern_in_category];
        end
        indentifier_category_in_nodes = [indentifier_category_in_nodes;...
            cont_y*ones(length(sampling_pattern_in_category),1)];
        cont_y = cont_y + 1;
    end
end
S_opt_random = logical(random_sampling_pattern);
