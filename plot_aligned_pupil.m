t_sample_epoch = linspace(-0.5,1,100);
behaviour = getBehavData('2021-05-13_2_DAP029', 'Grating2AFC');

stimulus_aligned = interp1(output_table.timeline, output_table.radius, behaviour.stimulusOnsetTime + t_sample_epoch, 'linear', 'extrap');
outcome_aligned = interp1(output_table.timeline, output_table.radius, behaviour.choiceCompleteTime + t_sample_epoch, 'linear', 'extrap');

figure
hold on
plot(mean(outcome_aligned(behaviour.feedback == 'Unrewarded', :), 'omitnan'))
plot(mean(outcome_aligned(behaviour.feedback == 'Rewarded', :), 'omitnan'))
hold off

figure
hold on
plot(mean(stimulus_aligned(behaviour.contrastLeft == 0.5, :), 'omitnan'))
plot(mean(stimulus_aligned(behaviour.contrastLeft == 0.25, :), 'omitnan'))
plot(mean(stimulus_aligned(behaviour.contrastLeft == 0 & behaviour.contrastRight == 0, :), 'omitnan'))
plot(mean(stimulus_aligned(behaviour.contrastRight == 0.25, :), 'omitnan'))
plot(mean(stimulus_aligned(behaviour.contrastRight == 0.5, :), 'omitnan'))
hold off