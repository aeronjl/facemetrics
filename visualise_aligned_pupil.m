figure;
subplot(1, 2, 1)
plot(radius_list)

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