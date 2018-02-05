# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: slicing_samples.rb

# use 'uncomment' resp. 'comment' to play selected examples or
# 'stop' resp. '#stop' to play the loops

use_bpm 120

live_loop :choose_slice do
  stop
  16.times do
    sample :loop_amen, beat_stretch: 4, num_slices: 16, slice: pick(16)
    sleep 0.25
  end
end

live_loop :detect_onset_and_pick do
  stop
  16.times do
    sample :loop_amen, beat_stretch: 4, onset: pick
    sleep 0.25
  end
end

live_loop :detect_onset_and_shuffle do
  #stop
  16.times do
    sample :loop_amen, beat_stretch: 4, num_slices: 16, slice: (line 0, 16, step: 1).shuffle.tick
    sleep 0.25
  end
end

live_loop :slice_rrand16 do
  sample :loop_amen, beat_stretch: 4, num_slices: 16, slice: rrand_i(0, 15)
  sleep 0.25
end

live_loop :slice_rrand8 do
  sample :loop_amen, beat_stretch: 4, num_slices: 8, slice: rrand_i(0, 7)
  sleep 0.5
end

# See what can be used of that:

live_loop :amen do
  stop
  #sample :loop_amen, beat_stretch: 2, amp: 0.75
  sample :loop_amen, beat_stretch: 4, amp: 0.75, start: 0.25
  #sample :loop_amen, beat_stretch: 4, amp: 0.75, start: 0, finish: 0.25
  at [0,1] do
    sample :loop_amen, beat_stretch: 1, amp: 0.25
  end

  sleep 2
end

live_loop :amen_slice1 do
  stop
  sample :loop_amen, num_slices: 8, slice: (range 0,8).choose
  sleep 0.25
end

live_loop :amen_slice2 do
  stop
  sample :loop_amen, num_slices: 8, attack: 0.025, release: 0.025, slice: (line 0,8, steps: 8).choose
  sleep 0.25
end

live_loop :amen_slice3 do
  #stop
  sample :loop_amen, attack: 0.0125, release: 0.0125, num_slices: 16, slice: (range 0,16).choose
  sleep 0.125
end

live_loop :amen_onset do
  stop
  with_swing 0.025, pulse: 3 do
    sample :loop_amen, onset: pick
  end
  sleep 0.25
end
