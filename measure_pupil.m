function measure_pupil(exp_ref)

    original_video = VideoReader([exp_ref '_eye.mp4']);
    num_frames = original_video.NumFrames;
    
    % Set the threshold
    test_frame = min(read(original_video, randi(num_frames, 1, 1)), [], 3);
    initial_low_threshold = 0.0;
    initial_high_threshold = 48;
    
    [low_threshold, high_threshold] = ...
        threshold(initial_low_threshold, initial_high_threshold, test_frame);
    %TODO: Make threshold checking more intelligent, allowing setting ahead
    %of time and checking at this stage if previous threshold exists. Use
    %flag in function to force overwrite threshold if previous exists.
    %e.g., (exp_ref, 'force', true)

    % Process video
    source_video_array = read(original_video, [1 num_frames]);
    video_array = min(source_video_array, [], 3);
    video_array = (video_array >= low_threshold) & (video_array <= high_threshold);
    
    radius_list = nan(num_frames, 1);
    center_x_list = nan(num_frames, 1);
    center_y_list = nan(num_frames, 1);
    
    ppm = ParforProgressbar(num_frames);
    
    parfor i = 1 : num_frames
    
        this_frame = video_array(:, :, :, i);
        this_frame = bwareafilt(this_frame, 1);
        this_frame = imfill(this_frame, 'holes');
        
        [center, radius, ~] = imfindcircles(this_frame, [8, 30], 'ObjectPolarity', 'Dark', 'EdgeThreshold', 0.6);
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
    
    end
    
    delete(ppm);
    
    frames = 1:num_frames;
    t_eye = getEventTimes(exp_ref, 'eye_camera_strobe'); 

    output_table = table(frames', t_eye, radius_list, center_x_list, center_y_list);
    output_table.Properties.VariableNames = {'frame', 'timeline', 'radius', 'center_x', 'center_y'};

    writetable(output_table, [exp_ref '_eye.csv'])

end