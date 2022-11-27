function visualise_aligned_pupil(exp_ref)
    
    pupil_data = readtable([exp_ref '_eye.csv'], 'Delimiter', ',');
    
    disp('Loading video...')
    original_video = VideoReader([exp_ref '_eye.mp4']);
    num_frames = original_video.NumFrames;
    source_video_array = read(original_video, [1 num_frames]);
    
    v = VideoWriter([exp_ref '_eye_annotated.avi']);
    open(v)

    disp('Visualising...')

    for i = 1 : num_frames
        this_frame = source_video_array(:, :, :, i);
        imshow(this_frame);
        viscircles([pupil_data.center_x(i) pupil_data.center_y(i)], pupil_data.radius(i), 'LineWidth', 0.5);
        annotated_frame = getframe(gcf);
        writeVideo(v, annotated_frame);
    end

    close(v);
end