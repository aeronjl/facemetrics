addpath utility\

original_video = VideoReader('2021-05-13_2_DAP029_eye.mp4');
num_frames = original_video.NumFrames;

test_frame = read(original_video, 10);
test_frame = min(test_frame, [], 3);

initial_low_threshold = 0.0;
initial_high_threshold = 48;

[low_threshold, high_threshold] = ...
    threshold(initial_low_threshold, initial_high_threshold, test_frame);

source_video_array = read(original_video, [1 num_frames]);
video_array = min(source_video_array, [], 3);
video_array = (video_array >= low_threshold) & (video_array <= high_threshold);


radius_list = nan(num_frames, 1);
center_x_list = nan(num_frames, 1);
center_y_list = nan(num_frames, 1);

ppm = ParforProgressbar(num_frames);

parfor i = 1 : num_frames
    tic
    this_frame = video_array(:, :, :, i);
    this_frame = bwareafilt(this_frame, 1);
    this_frame = imfill(this_frame, 'holes');
    
    [center, radius, metric] = imfindcircles(this_frame, [8, 30]);
    if numel(radius) == 1
        radius_list(i) = radius;
    else
        radius_list(i) = NaN;
    end

    if numel(center) == 2
        center_x_list(i) = center(1);
        center_y_list(i) = center(2);
    else
        center_x_list(i) = NaN;
        center_y_list(i) = NaN;
    end
    
    ppm.increment();
    toc
end

delete(ppm);
figure;
subplot(1, 2, 1)
plot(radius_list)

frames = 1:num_frames;
t_eye = getEventTimes('2021-05-13_2_DAP029','eye_camera_strobe'); 
output_table = table(frames', t_eye, radius_list, center_x_list, center_y_list);
output_table.Properties.VariableNames = {'frame', 'timeline', 'radius', 'center_x', 'center_y'};
writetable(output_table, '2021-05-13_2_DAP029_eye.csv')


center_x_list = output_table.center_x;
center_y_list = output_table.center_y;
radius_list = output_table.radius;
subplot(1, 2, 2)
for i = 1 : num_frames
    disp(i)
    this_frame = source_video_array(:, :, :, i);
    imshow(this_frame);
    viscircles([center_x_list(i) center_y_list(i)], radius_list(i), 'LineWidth', 0.5);
    annotated_frame = getframe;
end