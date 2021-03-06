function [ features, targets] = get_lsf( mix_sig, voice_sig, order_lpc, fs, win_len)%, win_shift)

%win_fun = hanning(win_len);
win_fun = ones(win_len,1); %%Use Rectangular Window

% check the length of mixture and voice signal
len_mix = length(mix_sig);
len_voice = length(voice_sig);

if len_mix~= len_voice
	min_len = min(len_mix, len_voice);
	mix_sig = mix_sig(1:min_len);
	voice_sig = voice_sig(1:min_len);
end

mix_sig(mix_sig == 0) = 1e-13;
voice_sig(voice_sig == 0 ) = 1e-13;
mix_frame = enframe(mix_sig, win_fun);%, win_shift);
voice_frame = enframe(voice_sig, win_fun);%, win_shift);

num_frame = size(mix_frame, 1);

features = [];
targets = [];

% get lsf for every frame
for i = 1:num_frame

	[ar_mix,q_mix] = lpc(mix_frame(i, :), order_lpc);
	[ar_voice,q_clean] = lpc(voice_frame(i, :), order_lpc);
	
    lsf_mix = ar2lsf(ar_mix)';
	lsf_voice = ar2lsf(ar_voice)';

	features = [features; lsf_mix];
	targets = [targets; lsf_voice];

% 	features = [features; q_mix];
% 	targets = [targets; q_clean];

end

features = single(features');
targets = single(targets');
end
