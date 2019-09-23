# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: several-ways-to-play-a-melody.rb

# Use 'un/comment' or 'stop' to listen to the examples.

use_bpm 120

# a metronom counting and synchronizing bars
# uncomment samples if you need to hear the beggining of a bar
# and/or quarter notes
live_loop :bar do
  #sample :elec_blip2, amp: 1
  sleep 1
  3.times do
    #sample :elec_blip2, amp: 1, rate: 1.5
    sleep 1
  end
end

use_synth :fm
use_synth_defaults depth: 0.25, divisor: 2, release: 0.5

######################################################
# Playing notes and rests
######################################################

#-----------------------------------------------------
# `play_pattern_timed`
#-----------------------------------------------------
live_loop :play_pattern_timed do
  stop
  notes = (scale :c3, :minor_pentatonic, num_octaves: 2)
  durations = [0.25,0.5,0.25,0.25,0.25,0.5,0.5,0.5]
  play_pattern_timed notes, durations
end

#-----------------------------------------------------
# `tick` & `look`
#-----------------------------------------------------
live_loop :tick_look do
  stop
  notes = (scale :f3, :minor_pentatonic, num_octaves: 2)
  # remember to use a `ring` to wrap values around
  durations = (ring 0.25,0.5,0.25,0.25,0.25,0.5,0.5,0.5)
  play notes.tick
  # Note: Use 'tick' to advance the counter, to check
  # for the position of the counter use 'look'.
  # If you use 'tick' twice or more in the same
  # 'live_loop' this can cause very unpredictable behaviour.
  sleep durations.look
end

#-----------------------------------------------------
# Iterating with `each`
#-----------------------------------------------------
live_loop :each do
  stop
  notes = [:g,:bb,:c,:d,:bb,:c,:f,:g]
  # Sonic Pi will do what is in the loop ('play' and 'sleep')
  # for 'each' element (= 8 times); you tell what should behaviour
  # worked on you have to get 'notes' into the loop via
  # the parameter 'n'.
  notes.each do | n |
    play n
    sleep 0.5
  end
end

#-----------------------------------------------------
# With `each` and use 'vector' as data structure
#-----------------------------------------------------
# You do not have to use a 'ring'; you could also use
# a simple list called a 'vector'
live_loop :simple_list do
  stop
  notes = [:g, :c, :bb, :d, :c, :bb, :f, :g]
  notes.each do | n |
    play n
    sleep 0.25
  end
end

######################################################
# Ok, those are ways to play notes and rests
# How about controling the duration of the notes
# and other params such as `amp` for each note?
######################################################

#-----------------------------------------------------
# 'Ticking' through 3 'ring's
#-----------------------------------------------------
live_loop :three_rings do
  stop
  notes = (ring :g3, :c3, :r, :bb3, :c3, :bb3, :f3, :g3)
  # You can do funny things with 'adding' another 'ring'
  # to the previous one; I used 'reverse' to invert the
  # order of the first 'ring'. Try 'shuffle' instead of 'reverse'
  # Uncomment the next 2 lines after the following; the first
  # assignment to 'notes' will then be overwritten by the following one:
  # notes = (ring :g3, :c3, :r, :bb3, :c3, :bb3, :f3, :g3) +
  #         (ring :g3, :c3, :r, :bb3, :c3, :bb3, :f3, :g3).reverse
  volume = (ring 1, 0.25, 0.15, 0.75, 0.25, 0.5, 0.75, 1)
  release = (ring 0.5, 0.25, 0.15, 0.5, 0.1, 0.15, 0.1, 0.25)

  play notes.tick, amp: volume.look, release: release.look

  # By the way: You often want to use the 'synth' command instead of
  # play; the main reason is, that you then can easily use 'control';
  # Comment the line starting with 'play' before and uncomment the
  # next lines:

  # s = synth :fm, note: notes.tick, depth: 1, divisor: 1, release: release.look, amp: volume.look, cutoff: 130
  # control s, depth: 6, depth_slide: 0.25, cutoff: 70, cutoff_slide: 0.025

  sleep 0.25
end

#-----------------------------------------------------
# 'Ticking' through 1 'ring' containing lists
#-----------------------------------------------------
# This example contains a nested structure, 8 lists within a ring.
# The 'tick/look' goes though the lists [enclosed in square braquets]
# the index [0], [1] and [2] address the values for note, volume
# and length (i. e. release), so you can keep all information within a
# single structure. I do prefer the former solution; although it is
# longer to have one ring for each of three parameters it makes
# things very transparent.

live_loop :ring_nested_list do
  stop
  n = (ring
       [:g3,1,0.5],
       [:c4,0.25,0.25],
       [:r,0.25,0.15],
       [:bb3,0.75,0.5],
       [:c3,0.25,0.1],
       [:bb3,0.5,0.15],
       [:g3,1,0.25],
       [:f3,0.75,0.1])
  play n.tick[0], amp: n.look[1], release: n.look[2]
  sleep 0.5
end


#-----------------------------------------------------
# 'Ticking' through 1 'ring's, calling 'tick' 3 times
#-----------------------------------------------------
# A somehow elegant but abstract solution. 'tick' is called
# three times; as every group contains of three parts
# (note, volume, release) this does work. But generally it
# it not advised to call 'tick' more than once within the
# same context. If you e. g. set the 'release' option _before_
# the 'amp' in the line starting with 'play', you will also 
# switch the volume with the duration of a note.
live_loop :rings_with_three_ticks do
  stop
  n = (ring
       :d3,1,0.5,
       :d4,0.25,0.25,
       :r,0.25,0.15,
       :bb3,0.75,0.5,
       :r,0.25,0.1,
       :bb3,0.5,0.15,
       :f3,0.75,0.1,
       :d4,1,0.25)
  play n.tick, amp: n.tick, release: n.tick
  sleep 0.25
end

######################################################
# Using Ruby's Multiple Assignment Features
######################################################
live_loop :double_assignment do
  stop
  the_note, the_relealse = (ring [:c, 0.75,],
                                 [:e, 0.25], [:e, 0.25],
                                 [:g, 0.125], [:g, 0.125], [:g, 0.125], [:g, 0.125]).tick
  play the_note, release: the_release
  sleep 0.5
end


######################################################
# Play Pattern + Basenote
######################################################
# An experiment: You can provide a base note (':c4'),
# convert it to an integer and add intervals as midi
# notes to play a Boogie Woogie bassline

live_loop :play_pattern_timed_base_note do
  stop
  basenote = :c4
  #                  c  e  g  a  bb  a  g  e
  intervals = (ring, 0, 4, 7, 9, 10, 9, 7, 4)
  play intervals.tick + basenote.to_i, release: 0.75
  sleep 0.5
end

######################################################
# Bassline with some variation
######################################################
# A somehow advanced example using 'chord_degree' and
# 'invert_chord' with some randomisation operating on
# on a minor pentatonic scale to provide the tone
# material; also 'control' to modifiy the sound while
# playing to add some variation.

live_loop :spread_and_synth do
  #stop
  if spread((ring 7,9,11,15).choose,16).reverse.tick
    s = synth :fm, note: (invert_chord (chord_degree [1,2,3].choose, :a1, :minor_pentatonic, 3), 3).look,
              attack: 0,
              sustain: 0,
              release: 0.25,
              divisor: 1,
              depth: 0,
              amp: (ring 0.15,0.25,0.05,0.25).choose
    control s, depth_slide: 0.125, depth: 2
  end
  sleep 0.25
end
