# Slicing and Remixing Drum Loops to create variety
# filename: slice-and-remix-drum-loops-to-create-variety.rb
# use '#stop' resp. 'stop' to listen to the individual examples...

use_bpm 120

live_loop :beat do
  sleep 1
end

live_loop :metro, sync: :beat do
  sleep 8
end

######################################################
# 16 bars Jive with 2 different drum rolls
######################################################

live_loop :jive_four_bars_with_break, sync: :metro do
  stop
  
  # Collect slices for 3 1/2 bars, each 1 beat long
  ptn = (ring 2,3,4,5,  4,5,6,7,  2,3,4,5,  6,7)
  
  tick(:cnt) # set up a counter for the whole live_loop
  
  # play 14 beats with the slice collection
  14.times do
    sample loopmaster, 11, beat_stretch: 8, num_slices: 8, slice: ptn.tick
    sleep 1
  end
  
  # play 2 beats of another sample to provide the drum roll
  if look(:cnt) % 2 == 0 # change drum roll every second time
    sample loopmaster, 12, beat_stretch: 8, num_slices: 8, slice: (range 5,6).look # fast roll
    sleep 1
    sample loopmaster, 12, beat_stretch: 8, num_slices: 8, slice: (range 5,6).look
  elsif
    sample loopmaster, 12, beat_stretch: 8, num_slices: 8, slice: (range 6,7).look # slow roll
    sleep 1
    sample loopmaster, 12, beat_stretch: 8, num_slices: 8, slice: (range 6,7).look
  end
  sleep 1
  
end

########################################################
# Overlaying a simple drum pattern with slices of itself
########################################################

live_loop :simple_drum_pattern_with_overlayed_slices, sync: :metro do
  stop
  # simple drum pattern
  at(ring 0,4) do
    sample loopmaster, 13, beat_stretch: 4
  end
  # same pattern sliced
  at(range 0, 8, step: 0.25) do
    with_swing 0.025, pulse: 3 do
      sample loopmaster, 13, beat_stretch: 4, num_slices: 16, slice: pick(16), amp: (rrand 0.125, 0.5)
      sleep 0.25
    end
  end
  
  sleep 8
end

########################################################
# Fake Break with Echo
########################################################

live_loop :simple_drum_pattern_with_fake_break, sync: :metro do
  stop
  # simple drum pattern
  at(ring 0,4,8,12) do
    sample loopmaster, 13, beat_stretch: 4
  end
  # same pattern sliced
  at 14 do
    with_fx :echo, phase: 0.75, decay: 1, mix: 1, amp: 1 do |del|
      control del, mix: 0, mix_slide: 1.5, amp: 0.5, amp_slide: 1
      sample loopmaster, 13, beat_stretch: 4
    end
  end
  sleep 16
end

# Here is another example for a fake break using an echoed sample
live_loop :breakbeat, sync: :metro do
  stop
  # to change the beak adust phase value to values such as 0.5, 0.75, 1.25
  # 0.25 sound echo like and more unnatural but interesting
  # you can also increase the decay to stress the break even more
  with_fx :echo, decay: 1, phase: (ring 0.5,0.75).choose, mix: 0.0, amp: 0.75 do |echo|
    # choose the time, when the echo comes in; with :amen beat 10 is a good choice
    # to land at the beginning of the 16-bar phrase without another echo
    at (ring 10) do
      sample :elec_blip2, rate: 1.5 # just for testing: here the echo and the break start
      # reduce the amp because otherwise original plus echo gets to loud
      control echo, mix: 0.5, mix_slide: 0.0, am2p: 0.5, amp_slide: 0.0
    end
    sample :elec_blip2 # just for testing: start of the 4 bar phrase
    4.times do
      sample :loop_amen, beat_stretch: 4, pitch: 0, finish: 1, amp: 1.25
      sleep 4
    end
  end
end



