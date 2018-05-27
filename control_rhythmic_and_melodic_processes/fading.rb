# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: fading.rb

# use 'uncomment' resp. 'comment' to play selected examples or
# 'stop' resp. '#stop' to play the loops

use_bpm 120

# Fading with `tick`, `range` and `line`

# Why you have to `ramp` the `range` or `line`:
# `range`/`line`:
# Create a new ring buffer from the range/line arguments.
# Indexes wrap around; that is where `ramp` comes into play:
# ramp:
# Create a new immutable ramp vector. Indexes always return first or
# last value if out of bounds.

#-----------------------------------------------------
# Fading using `line`
#-----------------------------------------------------

# Note:
# How short or how long your fade will be depends
# 1. The amount of values resp. the stepsize of your `range`/`line`
# 2. The duration of your `live_loop`

# This is probably more intuitive because you define the amount of steps
# rather than the step size: if you have a `live_loop` running 0.25 beats
# long 16 steps = 1 bar will bring the volume from 0 to 1 (so if your fade
# should take 4 bars to go from 0 to 1 you'll have to set 64 steps).

#-----------------------------------------------------
# Fading using `line`
#-----------------------------------------------------

# fade in
live_loop :fade_in_with_line_ramp do
  stop
  vol = (line 0, 1, inclusive: true, steps: 100).ramp
  ptn = (ring 1,0,0,0,1,0,0,0.25,1,0,0,0,1,0,0,0.25)
  sample :bd_tek, amp: vol.tick * ptn.look
  sleep 0.25
end

# fade out
live_loop :fade_out_with_line_ramp do
  stop
  vol = (line 1, 0, inclusive: true, steps: 100).ramp
  ptn = (ring 1,0,0,0,1,0,0,0.25,1,0,0,0,1,0,0,0.25)
  sample :bd_tek, amp: vol.tick * ptn.look
  sleep 0.25
end

# fade in and out
live_loop :fade_in_and_out_with_line_ramp do
  stop
  vol = (line 0, 1, inclusive: true, steps: 100).mirror
  ptn = (ring 1,0,0,0,1,0,0,0.25,1,0,0,0,1,0,0,0.25)
  sample :bd_tek, amp: vol.tick * ptn.look
  sleep 0.25
end

#-----------------------------------------------------
# Fading using `range`
#-----------------------------------------------------

# "range": from, to, step size
# (range 1, 5) => (ring 1, 2, 3, 4)

# fade in
live_loop :fade_in_with_range_ramp do
  stop
  vol = (range 0, 1, step: 0.005).ramp
  ptn = (ring 1,0,0,0,1,0,0,0.25,1,0,0,0,1,0,0,0.25)
  sample :bd_tek, amp: vol.tick * ptn.look
  sleep 0.25
end

# fade out
live_loop :fade_out_with_range_ramp do
  stop
  vol = (range 1, 0, step: 0.005).ramp # swap 1st two `range` params
  ptn = (ring 1,0,0,0,1,0,0,0.25,1,0,0,0,1,0,0,0.25)
  sample :bd_tek, amp: vol.tick * ptn.look
  sleep 0.25
end

# fade in/out
live_loop :fade_out_with_range_ramp do
  stop
  vol = (range 0, 1, step: 0.005).mirror # swap 1st two `range` params
  ptn = (ring 1,0,0,0,1,0,0,0.25,1,0,0,0,1,0,0,0.25)
  sample :bd_tek, amp: vol.tick * ptn.look
  sleep 0.25
end
#-----------------------------------------------------
# Fading using `line` and `at`
#-----------------------------------------------------

# `at` is very useful to create rhythmical patterns because
# it is somehow more intuitive to musicians then working e. g.
# with `sleep`; `sleep` defines the time distance from a previous
# event whereas `at` defines an event on the base of larger unit
# as e. g. a bar; see the following `live_loop` which has 4 beats
# = 1 bar; to fade while using at we will have to to devide our
# line into groups with a length matching the number of values
# passed to `at`. In the following case I use `vol` to define the
# base values for the fading operation; then I multiply each base
# value with the number of kicks per beat so that each run of the
# loop the volume is raised. (Sorry, I feel that this explanation
# could be much clearer, I will have to fix that)

live_loop :fade_in_with_line_and_at do
  stop
  # define the kick pattern
  ptn = (ring 0,1,2,3,3.25)
  # define the fade
  vol = (line 0, 1, inclusive: true, steps: 10).ramp
  # make groups of values with a length that matches the one of ptn
  vols = (knit vol.tick, ptn.size)

  at ptn, vols do |v|
    sample :bd_tek, amp: v
    puts "Current Volume: #{v}"
  end
  sleep 4
end

#-----------------------------------------------------
# Fade using control and double-tick
#-----------------------------------------------------
live_loop :fade_inout_amen do
  #stop

  vol = (line 0, 1, inclusive: true, steps: 4).mirror

  s = sample :loop_amen, beat_stretch: 4, amp: vol.tick
  puts "---------- Vol 1: #{vol.look} ----------"
  control s, amp_slide: 4, amp: vol.tick
  puts "---------- Vol 2: #{vol.look} ----------"
  sleep 4
end

live_loop :fade_inout_synth do
  stop
  vol = (line 0, 1, inclusive: true, steps: 125).mirror
  notes = (scale :e3, :minor_pentatonic, num_octaves: 2).shuffle
  s = synth :dtri, cutoff: 70, note: :e3, sustain: 8, release: 0, amp: vol.tick(:v)
  puts "---------- Vol 1: #{vol.look(:v)} ----------"
  32.times do
    control s, note: notes.tick, note_slide: 0.005, amp_slide: 0.125, amp: vol.tick(:v)
    puts "---------- Vol 1: #{vol.look(:v)} ----------"
    sleep 0.25
  end
end



live_loop :fade_in_keys do
  stop
  ptn = (ring
         (chord :a4, :minor7, invert: 0),
         :r,
         (chord :e4, :minor7, invert: -2), #
         (chord :a4, '7sus4', invert: -2),
         :r,
         :r,
         (chord :d4, '7sus4', invert: -1), #
         :r,
         :r,
         (chord :a4, :minor7, invert: -3),
         :r,
         (chord :e4, '7sus4', invert: -1),
         :r,
         (chord :a4, '7sus2', invert: -1), #
         (chord :d4, '7sus4', invert: 0),
         :r
        )

    vol = (line 0, 1, inclusive: true, steps: 500).mirror
    with_fx :wobble, mix: vol.look(:v) do
    s = synth :dpulse, note: ptn.tick, attack: 0.075, release: 0.25, cutoff: 50, pulse_width: 0.015, dpulse_width: 0.025, amp: vol.tick(:v)
    control s, cutoff_slide: 0.015, cutoff: 110, pulse_width_slide: 0.25, pulse_width: 0.95, dpulse_width: 0.5, dpulse_width_slide: 0.25, amp_slide: 0.25, amp: vol.tick(:v)
  end
  sleep 0.25
end

