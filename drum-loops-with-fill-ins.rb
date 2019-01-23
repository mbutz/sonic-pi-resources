# Drums-Loops with and Fill-ins
# drum-loops-with-fill-ins.rb

# Comment 'stop' in 'live_loop' to listen to specific example
# Take care that you have only one live_loop running

# Example 1 -----------------------------------------------------------------
# Last bar as fill-in
live_loop :amen1 do
  stop
  3.times do
    # sample runs 3 bars
    sample :loop_amen, beat_stretch: 2
    sleep 2
  end
  4.times do
    # sample sliced into 4 pieces, runs/sleeps 4 times/beats resp. 1 bar
    # => pick a random slice each run
    sample :loop_amen, beat_stretch: 2, num_slices: 4, slice: pick
    sleep 0.5
  end
end

# Example 2 -----------------------------------------------------------------
# Last 2 beats as fill-in
live_loop :amen2 do
  stop
  # sample runs 3.5 bars
  3.times do
    sample :loop_amen, beat_stretch: 2
    sleep 2
  end
  1.times do
    # finish sample after 50% because it should only play for 1/2 bar
    # get a sample portion be using e. g. 'start: 0.25, finish: 0.75
    sample :loop_amen, beat_stretch: 2, finish: 0.5
    sleep 1
  end
  2.times do
    # sample sliced into 4 pieces, runs/sleeps 2 times/beats resp. 1/2 bar
    # => pick a random slice each run
    sample :loop_amen, amp: 0.5, beat_stretch: 2, num_slices: 4, slice: pick
    sleep 0.5
  end
end

# Example 3 -----------------------------------------------------------------
# Randomly choose to have last 2 beats as fill-in or not
live_loop :amen3 do
  stop
  # sample runs 3.5 bars
  3.times do
    sample :loop_amen, beat_stretch: 2
    sleep 2
  end
  1.times do
    # finish sample after 50% because it should only play first half
    sample :loop_amen, beat_stretch: 2, finish: 0.5
    sleep 1
  end
  
  # play a fill-in with 33% probability
  if one_in 3
    2.times do
      # sample sliced into 4 pieces, runs/sleeps 2 times/beats resp. 1/2 bar
      # => pick a random slice each run
      sample :loop_amen, beat_stretch: 2, num_slices: 4, slice: pick
      sleep 0.5
    end
  else
    # start sample after 50% because it should play second half
    sample :loop_amen, beat_stretch: 2, start: 0.5
    sleep 1
  end
  
end

# Example 4 -----------------------------------------------------------------
# Randomly play a 4 or 1 beat fill-in
live_loop :amen4 do
  stop
  # of course you can have another bpm then the default of 60
  # it then gets a bit more complicated because you
  # will probably have to adjust the times of:
  # beat_stretch, sleep, num_slices
  use_bpm 120
  # sample runs 3.5 bars
  
  3.times do
    sample :loop_amen, beat_stretch: 4
    sleep 4
  end
  
  # to get a bit of variation:
  # fill the last 3 beats with 50% probability with the last 3 quarters of the :loop_amen
  # else play the first 3 quarters and then the fill-in
  if one_in 2
    # finish sample after 75% because it should only play for 3/4 bar
    sample :loop_amen, beat_stretch: 4, start: 0.25, finish: 1.0
    sleep 3
  else
    # finish sample after 75% because it should only play for 3/4 bar
    sample :loop_amen, beat_stretch: 4, finish: 0.75
    sleep 3
  end
  
  # play the 1 beat fill-in
  2.times do
    # sample sliced into 8 pieces, runs/sleeps 1 times/beat resp. 1/4 bar
    # => pick a random slice each run
    sample :loop_amen, beat_stretch: 4, num_slices: 8, slice: pick
    sleep 0.5
  end
  
end

# Example 5 -----------------------------------------------------------------
# Here is a totally different approach creating using an echoed sample
live_loop :amen5 do
  stop
  use_bpm 120
  # to change the fill-in set 'phase' value to values such as 0.5, 0.75, 1.25
  # 0.25 sounds unnatural but interesting
  # you can also increase the decay to stress the break even more
  with_fx :echo, decay: 1, phase: (ring 0.5,0.75).choose, mix: 0.0, amp: 0.75 do |echo|
    # choose the time, when the echo comes in; with :amen beat 10 is a good choice
    # to land at the beginning of the 16-bar phrase without another echo
    at (ring 10) do
      sample :elec_blip2, rate: 1.5 # just for testing: here the echo and the break start
      # reduce the amp because otherwise original plus echo gets to loud
      control echo, mix: 0.5, mix_slide: 0.0, amp: 0.5, amp_slide: 0.0
    end
    sample :elec_blip2 # just for testing: start of the 4 bar phrase
    4.times do
      sample :loop_amen, beat_stretch: 4, pitch: 0, finish: 1, amp: 1.25
      sleep 4
    end
  end
end

# Example 6 -----------------------------------------------------------------
# Same principle as examples 1-4 but this time we are leaving out some
# slices in the fill-in by setting the volume for each slice randomly to 0 or 1
live_loop :breakbeat1 do
  stop
  3.times do
    sample :loop_breakbeat, beat_stretch: 2
    sleep 2
  end
  1.times do
    sample :loop_breakbeat, beat_stretch: 2, finish: 0.5
    sleep 1
  end
  4.times do
    sample :loop_breakbeat, beat_stretch: 2, num_slices: 8, slice: pick,
      amp: (ring 0,1).choose
    sleep 0.25
  end
end

# Example 7 -----------------------------------------------------------------
# Use shorter and more slices and 'rate' variation for a glitchy effect
live_loop :breakbeat2 do
  stop
  
  3.times do
    sample :loop_breakbeat, beat_stretch: 2
    sleep 2
  end
  1.times do
    sample :loop_breakbeat, beat_stretch: 2, finish: 0.5
    sleep 1
  end
  8.times do
    sample :loop_breakbeat, beat_stretch: 2, num_slices: 16, slice: pick,
      amp: (ring 0,1).choose, rate: (ring 1,-1).choose
    sleep 0.125
  end
end

# Example 8 -----------------------------------------------------------------
# Same as 7 adding a fake hihat
live_loop :breakbeat3 do
  #stop
  
  # use 'onset' to separate a snare hit, 'attack_level' and 'hpf' to adjust the sound
  # for a kind of hihat-like sound
  # 'at' plus a 'range' for the timing, will result in (see: documentation: `range`):
  # (ring 0.25, 0.75, 1.25, 1.75, ..., 6.25, 6.75)
  at (range 0.25, 7, 0.5) do
    sample :loop_breakbeat, beat_stretch: 2, onset: 11, attack_level: 10, release: 0.25, hpf: 125, amp: 3
  end
  
  3.times do
    sample :loop_breakbeat, beat_stretch: 2
    sleep 2
  end
  1.times do
    sample :loop_breakbeat, beat_stretch: 2, finish: 0.5
    sleep 1
  end
  8.times do
    sample :loop_breakbeat, beat_stretch: 2, num_slices: 16, slice: pick,
      amp: (ring 0,1).choose, rate: (ring 1,-1).choose
    sleep 0.125
  end
  
end
