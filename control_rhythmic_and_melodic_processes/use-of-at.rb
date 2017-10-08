# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: use_of_at.rb

# use 'stop' resp. '#stop' to play the loops

use_bpm 120

# a metronom counting and synchronizing bars
# uncomment samples if you need to hear bar and quarter notes
live_loop :bar do
  #sample :elec_blip2, amp: 1
  sleep 1
  3.times do
    #sample :elec_blip2, amp: 1, rate: 1.5
    sleep 1
  end
end

# 'at' has the advantage, that you mark the instance when an event (e. g. note, sample)
# starts (compared to the logic of 'sleep' where you measure the time distance from one
# event to another); 'at' behaves like marking a certain point with respect to the complete
# timeline (f. e. the length of a live_loop)

# Pattern for at-times
# |         Bar 1       |         Bar 2       |         Bar 3       |         Bar 4       |
# | 0.00 0.25 0.50 0.75 | 1.00 1.25 1.50 1.75 | 2.00 2.25 2.50 2.75 | 3.00 3.25 3.50 3.75 |
# | x    -    -    -    | x    -    -    -    | x    -    -    -    | x    -    -    -    |


###########################################
# Simple Rhythms
###########################################

# | x - - - | x - - - | x - - - | x - - - |
live_loop :hat_4th_onbeat, sync: :bar do
  stop
  at (range 0, 4, step: 1) do # (ring 0.0, 1.0, 2.0, 3.0), no 4, except you set: inclusive: true
    sample :drum_cymbal_closed, rate: 1.0
  end
  sleep 4
end

# Another example from the Sonic Pi documentation
# with alternating amp
live_loop :example, sync: :bar do
  #stop
  at [0,1,2,3],
     [{:amp=>1.0}, {:amp=> 0.25}] do |p|
    sample :drum_cymbal_closed, p
  end
  sleep 4
end



# | - - x - | - - x - | - - x - | - - x - |
live_loop :hat_4th_offbeat, sync: :bar do
  stop
  at (range 0.5, 4, step: 1) do # (ring 0.5, 1, 2.0, 3.0)
    sample :drum_cymbal_closed, rate: 1.75
  end
  sleep 4
end

# | x - x - | x - x - | x - x - | x - x - |
live_loop :hat_8th_onbeat, sync: :bar do
  stop
  at (range 0, 4, step: 0.5) do # (ring 0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5)
    sample :drum_cymbal_closed
  end
  sleep 4
end

# | - x - x | - x - x | - x - x | - x - x |
live_loop :hat_8th_offbeat, sync: :bar do
  stop
  at (range 0.25, 4, step: 0.5) do # (ring 0.25, 0.75, 1.25, 1.75, 2.25, 2.75, 3.25, 3.75)
    sample :drum_cymbal_closed, rate: 1.75
  end
  sleep 4
end

# Random-rate-16th-notes
live_loop :hat_random, sync: :bar do
  stop
  at (range 0.0, 4, step: 0.25) do
    sample :drum_cymbal_closed, rate: rrand(0.25, 1.0), amp: rrand(0.125, 0.5)
  end
  sleep 4
end

# Random-rate-16th-notes with negative values
# Breaking ice floes
live_loop :hat_random_negative, sync: :bar do
  stop
  at (range 0.0, 4, step: 0.25) do
    sample :drum_cymbal_closed, rate: rrand(-0.25, 0.25), amp: rrand(0.25, 0.5)
  end
  sleep 4
end

###########################################
# Playing Melodies
###########################################
live_loop :melody, sync: :bar do
  stop
  use_synth :fm
  use_synth_defaults depth: 0.125, divisor: 1.0, attack: 0, release: 0.125

  puts "Look: #{look} ---------------"

  mel = (ring :d3, :c4, :a3, :f3, :a3, :c3)
  ptn = (ring 0,   1,   2,   3,   6.5, 7.5)
  at ptn, mel do |n|
    play n
  end
  sleep 8
end

# add more params than just note
live_loop :bass, sync: :bar do
  stop
  use_synth :fm
  use_synth_defaults release: 0.25, depth: 1
  at (ring 0, 2.5, 2.75, 3.5, 3.75), (ring [:a2,1.5],[:g2,0.25],[:a2,0.75],[:a2,0.25],[:e3,0.25]) do |n|
    play n[0], release: n[1]
  end
  sleep 4
end

# Trying to combine "at" with "synth"; does not work as I expect,
# but causes a very interesting effect:
# creates as many voices as there are values given to "at"
live_loop :synthi do
  stop
  use_bpm 60
  nts = (ring :a3, :c, :e, :g).tick
  at (ring 0.5, 0.75, 1.25) do
    s = synth :fm, note: nts, release: 0.125, depth: 0.5, divisor: 0.5
    control s, depth_slide: 0.125, depth: 2
  end
  sleep 0.5
end

