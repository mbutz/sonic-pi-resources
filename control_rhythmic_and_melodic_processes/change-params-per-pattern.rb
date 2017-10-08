# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: change-params-per-pattern.rb
# 'uncomment' the example you wan't to listen to...

use_bpm 120

# A very (very!) common task while creating music is that
# you want to set up certain recurrent pattern such as e. g.
# a bassline that repeats three times and than is variated
# in a certain way to start over all again.

# One of the easiest and (arguably) most transparent ways to do that
# in Sonic Pi is to note the whole pattern. The downside is: it is
# much to write and not very flexible if you want to change something.

######################################################
# Toggle Two Melodic Patterns using `tick` and `at`
######################################################

# Toggle beteen two melodies every 4 bars i. e. every run of the live_loop i. e. 8 beats
# use tick and use fact that tick increases each run of live_loop
live_loop :melody do
  stop

  use_synth :fm
  use_synth_defaults depth: 0.125, divisor: 1, attack: 0, release: 0.5

  tick
  puts "=====> Starting pattern now: 'Look is': #{look}."

  # Set up your melodic patterns
  mel1 = (ring :d3, :c4, :a3, :f3, :a3, :c3)
  mel2 = (ring :c3, :bb3, :g3, :eb3, :g3, :bb2)
  # Set up the succession of patterns, tick/look will walk through it
  mel = (ring mel1, mel1, mel2, mel2)
  # or:
  # mel = (knit mel1, 2, mel2, 2)
  # Set up the patterns rhythm (you could adjust the rhythm like the melody)
  ptn = (ring 0,1,2,3,6.5,7.5)

  at ptn, mel.look do |n|
    play n
  end
  sleep 8
end

######################################################
# Chord Arppegio Sequence using `tick` and `include`
######################################################

live_loop :chord_arppegio_sequence do
  stop
  # Set cycle length, 16 times 0.5 beats = 2 bars
  cycle = (range 1, 16)
  # if look = 15 reset; remember: tick starts with 0
  # and goes to 15 = 16.times until reset
  tick_reset if look == cycle.length

  use_synth :fm
  use_synth_defaults release: 0.5, depth: 0.25, divisor: 0.5

  # section 1
  if (range 0,4).include?(tick) # one time you have to call tick to advance...
    ptn = (invert_chord (chord :c, :major), 1)
    puts "| #{look} | _ | _ | _ |"
  end

  # section 2
  if (range 4,8).include?(look)
    ptn = (invert_chord (chord :a, :minor),-1)
    puts "| _ | #{look} | _ | _ |"
  end

  # section 3
  if (range 8,12).include?(look)
    ptn = (invert_chord (chord :f, :major),0)
    puts "| _ | _ | #{look} | _ |"
  end

  # section 4
  if (range 12,16).include?(look)
    ptn = (invert_chord (chord :g, :major),-1)
    puts "| _ | _ | _ | #{look} |"
  end

  play ptn.look

  sleep 0.5
end

######################################################
# Chord Sequence with Human Readable Counter
######################################################

# If you think as a musician you might want to do
# something like this: To play C-Major in
# the first bar, then A-Minor in the second aso.
# (You don't want to count from 0-3 and from 4-7 to
# cover the first two bars, but rather count from
# 1 to 4 and furthermore up to 8 aso.); that is
# the reason why in this example `tick` is offset to 1.
# You can set any variables and/or options for the
# duration of one, two or more bars; just adjust
# the values.
# Nevertheless, for me it is not the most intuitive
# method to create musical patterns and sequences...

live_loop :counting_tick_offset do
  stop
  use_synth_defaults release: 0.25
  i = tick offset: 1
  bar = 4
  if i <= bar * 1
    ptn = (invert_chord (chord :c, :major), 1)
    puts "================== (1 _ _ _) #{i} ==============="
  elsif i <= bar * 2
    ptn = (invert_chord (chord :a, :minor),-1)
    puts "================== (_ 2 _ _) #{i} ==============="
  elsif i <= bar * 3
    ptn = (invert_chord (chord :f, :major),0)
    puts "================== (_ _ 3 _) #{i} ==============="
  elsif i <= bar * 4
    ptn = (invert_chord (chord :g, :major),-1)
    puts "================== (_ _ _ 4) #{i} ==============="
    tick_reset if i == bar * 4
  end
  play ptn
  sleep 0.5
end

######################################################
# Bass Phrase with Modulo
######################################################

live_loop :bass do

  #stop
  use_bpm 130

  # length of a bar in beats = length of live_loop's sleep time
  beats_per_bar = 4
  # How many bars should we count until the pattern starts all over again?
  # Note: Has to be aligned with the beats_per_bar i. e. the runtime of the live_loop
  bars = 16
  # Return the bar number (the +1 makes sure we start counting from 1 and not from 0)
  num_of_bar = tick % bars + 1

  puts "============================="
  puts "Tick: #{look} - No. of Bar: #{num_of_bar}"
  puts "============================="


  master_vol = 0.5

  if num_of_bar <= beats_per_bar * 1 then # range from bar 1-4
    note = :c1
  elsif num_of_bar <= beats_per_bar * 2 then # range from bar 5-8
    note = :c1
  elsif num_of_bar <= beats_per_bar * 3 then # range from bar 9-12
    note = :eb1
  elsif num_of_bar <= beats_per_bar * 4 then # range from bar 13-16
    note = :f1
  end

  use_synth :fm
  use_synth_defaults attack: 0, sustain: 4, release: 0.5, amp: 0.5, depth: 0.5, divisor: 1, cutoff: 60

  s = play note

  # This pattern is 4 beats long
  control s, depth: 2, pan: -1, cutoff: 60, amp: 2 * master_vol
  sleep 0.5
  control s, depth: 4, pan: -0.75, cutoff: 70, amp: 2 * master_vol
  sleep 0.5
  control s, depth: 6, pan: -0.5, cutoff: 80, amp: 1 * master_vol
  sleep 0.5
  control s, depth: 8, pan: -0.25, cutoff: 90, amp: 1 * master_vol
  sleep 0.5
  control s, depth: 10, pan: 0, cutoff: 100, amp: 0.75 * master_vol
  sleep 0.5
  control s, depth: 12, pan: 0.25, cutoff: 110, amp: 0.75 * master_vol
  sleep 0.5
  control s, depth: 14, pan: 0.5, cutoff: 120, amp: 0.5 * master_vol
  sleep 0.5
  control s, depth: 16, pan: 1, amp: 0.5 * master_vol
  sleep 0.5
end
