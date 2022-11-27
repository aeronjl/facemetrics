function tableOut = align_to_event(label, tableIn, x, t, t_sample_epoch, warp_samples, stimOnTime, choiceTime, outcomeTime)
% This function simply computes the event-aligned values for the signal x
% (at timestamps t) for stimulus, choice, and outcome times. Also does
% baseline correction.

tableOut = tableIn;

tableOut.([label '_stim']) = single(interp1(t,x,stimOnTime + t_sample_epoch));
tableOut.([label '_choice']) = single(interp1(t,x,choiceTime + t_sample_epoch));
tableOut.([label '_outcome'])  = single(interp1(t,x,outcomeTime + t_sample_epoch));
tableOut.([label '_timewarped']) = single(interp1(t,x,warp_samples));

%baseline correct
pre_stim_baseline = mean(tableOut.([label '_stim'])(:,t_sample_epoch<0,:),2, 'omitnan');
tableOut.([label '_stim']) = tableOut.([label '_stim']) - pre_stim_baseline;
tableOut.([label '_choice']) = tableOut.([label '_choice']) - pre_stim_baseline;
tableOut.([label '_outcome']) = tableOut.([label '_outcome']) - pre_stim_baseline;
tableOut.([label '_timewarped']) = tableOut.([label '_timewarped']) - pre_stim_baseline;

end