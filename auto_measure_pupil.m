function auto_measure_pupil(exp_ref)

    original_video = VideoReader([exp_ref '_eye.mp4']);
    num_frames = original_video.NumFrames;
    
    % Process video
    source_video_array = read(original_video, [1 num_frames]);
    video_array = min(source_video_array, [], 3);
    %video_array = (video_array >= low_threshold) & (video_array <= high_threshold);
    
    radius_list = nan(num_frames, 1);
    center_x_list = nan(num_frames, 1);
    center_y_list = nan(num_frames, 1);
    
    ppm = ParforProgressbar(num_frames);
    
    parfor i = 1 : num_frames
    
        this_frame = video_array(:, :, :, i);
    
        [center, radius, metric] = imfindcircles(this_frame, [6 30], 'ObjectPolarity', 'dark');
        
    
        % Take the best circle
        if numel(metric) > 1
            center = center(1, :);
            radius = radius(1);
        elseif numel(metric) == 0
            center = [NaN NaN];
            radius = NaN;
        end
    
        
        center_x_list(i) = center(1);
        center_y_list(i) = center(2);
        radius_list(i) = radius;
    
        ppm.increment();
    
    end
    
    delete(ppm);
    
    frames = 1:num_frames;
    t_eye = getEventTimes(exp_ref, 'eye_camera_strobe'); 
    
    output_table = table(frames', t_eye, radius_list, center_x_list, center_y_list);
    output_table.Properties.VariableNames = {'frame', 'timeline', 'radius', 'center_x', 'center_y'};
    
    writetable(output_table, [exp_ref '_eye.csv'])

end