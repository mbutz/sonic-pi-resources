# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: several-ways-to-play-a-melody.rb

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
  n_list = (scale :c3, :minor_pentatonic, num_octaves: 2)
  d_list = [0.25,0.5,0.25,0.25,0.25,0.5,0.5,0.5]
  play_pattern_timed n_list, d_list
end

#-----------------------------------------------------
# `tick` & `look`
#-----------------------------------------------------
live_loop :tick_look do
  stop
  n_list = (scale :f3, :minor_pentatonic, num_octaves: 2)
  # remember to use a `ring` to wrap values around
  d_list = (ring 0.25,0.5,0.25,0.25,0.25,0.5,0.5,0.5)
  play n_list.tick
  sleep d_list.look
end

#-----------------------------------------------------
# Iterating with `each`
#-----------------------------------------------------
live_loop :each do
  stop
  n_list = [:g,:bb,:c,:d,:bb,:c,:f,:g]
  n_list.each do |n|
    play n
    sleep 0.5
  end
end

#-----------------------------------------------------
# Iterating with `times`
#-----------------------------------------------------
live_loop :times do
  stop
  n_list.size.times do |i|
    play n_list[i]
    sleep 0.5
  end
end

#-----------------------------------------------------
# With `each` and use 'vector' as data structure
#-----------------------------------------------------
live_loop :vector_1 do
  stop
  n_vector = [:g, :c, :bb, :d, :c, :bb, :f, :g]
  n_vector.each do | n |
    play n + 2
    sleep 0.25
  end
end

######################################################
# Ok, those are ways to play notes and rests
# How about controling the duration of the notes
# and other params such as `amp` for each note?
######################################################

#-----------------------------------------------------
# Using several `vectors` and an index
#-----------------------------------------------------
live_loop :vector_times_index do
  stop
  n = (vector :g3, :c4, :r, :bb3, :c3, :bb3, :f3, :g3)
  n_amp = (vector 1, 0.25, 0.25, 0.75, 0.25, 0.5, 0.75, 1)
  n_rel = (vector 0.5, 0.25, 0.15, 0.5, 0.1, 0.15, 0.1, 0.25)


  8.times do |i|
    play n[i], release: n_rel[i], amp: n_amp[i]
    sleep 0.5
    puts "---> Note: #{n[i]}; Release: #{n_rel[i]}; Amp: #{n_amp[i]}"
  end
end

#-----------------------------------------------------
# All params in one `vector`
#-----------------------------------------------------
live_loop :one_vector_times_index do
  stop
  n = (vector [:g3,1,0.5], [:c4,0.25,0.25], [:r,0.25,0.15], [:bb3,0.75,0.5], [:c3,0.25,0.1], [:bb3,0.5,0.15], [:f3,0.75,0.1], [:g3,1,0.25])

  8.times do |i|
    play n[i][0], release: n[i][1], amp: n[i][2]
    sleep 0.25
    puts "---> Note: #{n[i][0]}; Release: #{n[i][1]}; Amp: #{n[i][2]}"
  end
end

#-----------------------------------------------------
# The same with `ring`
#-----------------------------------------------------
live_loop :ring do
  stop
  n = (ring :g3, :c3, :r, :bb3, :c3, :bb3, :f3, :g3)
  n_amp = (ring 1, 0.25, 0.15, 0.75, 0.25, 0.5, 0.75, 1)
  n_rel = (ring 0.5, 0.25, 0.15, 0.5, 0.1, 0.15, 0.1, 0.25)
  8.times do | i |
    play n[i], amp: n_amp[i], release: n_rel[i]
    sleep 0.25
    "Note: #{n[i]}"
  end
end

#-----------------------------------------------------
# The same with `ring`, `tick` and `look`
#-----------------------------------------------------
live_loop :one_ring_tick_look_1 do
  stop
  n = (ring [:g3,1,0.5], [:c4,0.25,0.25], [:r,0.25,0.15], [:bb3,0.75,0.5], [:c3,0.25,0.1], [:bb3,0.5,0.15], [:f3,0.75,0.1], [:g3,1,0.25])
    play n.tick[0], amp: n.look[1], release: n.look[2]
    sleep 0.5
end

live_loop :one_ring_tick_look_2 do
  #stop
  use_bpm 120
  amp_master = 0.5
  n = (ring [:g4, 2, 1, 0.25],
            [:c4, 1, 1, 0.5],
            [:f4, 0.5, 3, 0.5],
            [:bb4, 1, 1, 0.25],
            [:c4, 2, 1, 0.5],
            [:bb4, 0.5, 1, 0.25],
            [:f4, 0.5, 3, 0.5],
            [:g4, 2, 1, 0.25])


  play n.tick[0], amp: n.look[1] * amp_master, release: n.look[2]
  sleep n.look[3]
end

#-----------------------------------------------------
# `tick` and `look`; 3 rings
#-----------------------------------------------------
live_loop :play_with_tick do
  stop
  note = (ring :g3, :c3, :r, :bb3, :c3, :bb3, :f3, :g3)
  amp = (ring 1, 0.25, 0.15, 0.75, 0.25, 0.5, 0.75, 1)
  rel = (ring 0.5, 0.25, 0.15, 0.5, 0.1, 0.75, 0.1, 0.25)

  play note.tick, amp: amp.look, release: rel.look
  sleep 0.5
end

#-----------------------------------------------------
# `tick` and `look`; 3 rings and `synth`
#-----------------------------------------------------
live_loop :play_with_tick_and_synth do
  stop
  note = (ring :g3, :c3, :r, :bb3, :c3, :bb3, :f3, :g3)
  amp = (ring 1, 0.25, 0.15, 0.75, 0.25, 0.5, 0.75, 1)
  rel = (ring 0.5, 0.25, 0.15, 0.5, 0.1, 0.75, 0.1, 0.25)
s = synth :fm, note: note.tick, depth: 1, divisor: 1, release: rel.look, amp: amp.look
  sleep 0.5
end


######################################################
# Play Pattern + Basenote
######################################################
live_loop :play_pattern_timed_base_note do
  stop
  intervals = ( ring, 0, 4, 7, 9, 10, 9, 7, 4)
  # just for checking
  comment do
    n = intervals + :c3
    puts "---> Note: #{n}"
  end
  play_pattern_timed intervals + :c3, (ring 0.5), release: 0.75
  # You can't interchange `intervals` and `:c3`; does NOT work
  #play_pattern_timed :c5 + intervals, (ring 0.5)
end

######################################################
# Play Pattern + Basenote
######################################################

live_loop :spread_and_synth do
  stop
  if spread((ring 7,9,11,15).choose,16).reverse.tick
    s = synth :fm, note: (invert_chord (chord_degree [1,2,3].choose, :a1, :minor_pentatonic, 3), 3).look,
              attack: 0,
              sustain: 0,
              release: 0.25,
              divisor: 1,
              depth: 1,
              amp: (ring 0.15,0.25,0.05,0.25).choose
    control s, depth_slide: 0.125, depth: 4
  end
  sleep 0.25
end
