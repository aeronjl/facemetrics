function plot_aligned_pupil(exp_ref)
    pupil_data = readtable([exp_ref '_eye.csv'], 'Delimiter', ',');
    pupil_data.radius = smooth(pupil_data.radius);
    
    t_sample_epoch = linspace(-0.5,1,100);
    warp_sizes = [30, 40, 12, 60];
    behaviour = getBehavData(exp_ref, 'Grating2AFC');
    behaviour.outcomeTime = mean([behaviour.rewardTime, behaviour.punishSoundOnsetTime], 2, 'omitnan');
    
    warp_samples = nan(length(behaviour.choice), sum(warp_sizes));
    for tr = 1:length(behaviour.choice)
        epoch1 = linspace(behaviour.stimulusOnsetTime(tr)-0.5, behaviour.stimulusOnsetTime(tr), warp_sizes(1));
        epoch2 = linspace(behaviour.stimulusOnsetTime(tr), behaviour.choiceCompleteTime(tr), warp_sizes(2));
        epoch3 = linspace(behaviour.choiceCompleteTime(tr), behaviour.outcomeTime(tr), warp_sizes(3));
        epoch4 = linspace(behaviour.outcomeTime(tr), behaviour.outcomeTime(tr)+1, warp_sizes(4));
        warp_samples(tr,:) = [epoch1, epoch2, epoch3, epoch4];
    end
    
    aligned_pupil = table;
    aligned_pupil.exp_ref = repmat(exp_ref, height(behaviour), 1);
    aligned_pupil = align_to_event('pupil_radius', aligned_pupil, pupil_data.radius, pupil_data.timeline, t_sample_epoch, warp_samples, behaviour.stimulusOnsetTime, behaviour.choiceCompleteTime, behaviour.outcomeTime);
    
    writetable(aligned_pupil, [exp_ref '_eye_aligned.csv'])
end