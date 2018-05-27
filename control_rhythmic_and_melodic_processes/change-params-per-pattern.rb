# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: change-params-per-pattern.rb
# 'uncomment' the example you wan't to listen to...

# Use 'un/comment' or 'stop' to listen to the examples.

use_bpm 120

# A very common task while creating music is that
# you want to set up certain recurrent pattern such as e. g.
# a bassline that repeats three times and than is variated
# in a certain way to start over all again.

######################################################
# Bass Phrase with Modulo
######################################################

comment do

  use_bpm 130

  live_loop :beat do
    sleep 1
  end

  live_loop :bass, sync: :beat do

    # length of a bar in beats = length of live_loop's sleep time
    beats_per_bar = 4
    # How many bars should we count until the pattern starts all over again?
    # Note: Will be as long as the runtime of the live_loop.
    bars = 8 # 8 bars * 4 beats = 32 = length of phrase.
    # Return the bar number of the current bar/tick.
    # Modulo returns actually the tick but starts all over again,
    # once 'bars' (length of the phrase has been reached).
    num_of_bar = tick % bars

    # This is just for information and surely can be deleted
    puts "================================"
    puts "Tick: #{look} - Actual No. of Bar: #{num_of_bar +1}"
    puts "================================"
    # /This is just for information and surely can be deleted

    master_vol = 0.75

    # Because we work with tick we start counting of bars at 0 (instead of 1) and
    # therefore the setting of the if-condition asks:
    # 'current bar' < than 'bar number where something should change'
    if num_of_bar < 4 then # range from bar 1-4 (resp. 0-3)
      note = :c1
    elsif num_of_bar < 6 then # range from bar 5-6 (resp. 4-5)
      note = :eb1
    elsif num_of_bar < 8 then # range from bar 7-8 (resp. 6-7)
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
    control s, depth: 16, pan: 1, cutoff: 130, amp: 0.5 * master_vol
    sleep 0.5
  end

  live_loop :amen, sync: :beat do
    sample :loop_amen, beat_stretch: 4
    sleep 4
  end

end # comment


######################################################
# Chord Sequence with Human Readable Counter
######################################################

# A slightly different approach and more complicated
# (at least for me), because we set a 'custom' 'tick'
# and work with 'offset' to create a counter beginning
# with 1 instead of 0.
# Surely you can delete the 'puts' statements as they
# are just a visual aid to check whether everything
# works as expected.

live_loop :counting_tick_offset do
  stop
  use_synth_defaults release: 0.25
  i = tick offset: 1
  beats_per_bar = 4
  if i <= beats_per_bar * 1
    ptn = (invert_chord (chord :c, :major), 1)
    puts "Bar Counter: (1 _ _ _ _ _ _ _) #{i} ==============="
  elsif i <= beats_per_bar * 2
    ptn = (invert_chord (chord :a, :minor),-1)
    puts "Bar Counter: (_ 2 _ _ _ _ _ _) #{i} ==============="
  elsif i <= beats_per_bar * 3
    ptn = (invert_chord (chord :f, :major),0)
    puts "Bar Counter: (_ _ 3 _ _ _ _ _) #{i} ==============="
  elsif i <= beats_per_bar * 4
    ptn = (invert_chord (chord :g, :major),-1)
    puts "Bar Counter: (_ _ _ 4 _ _ _ _) #{i} ==============="
  elsif i <= beats_per_bar * 5
    ptn = (invert_chord (chord :e, :minor),0)
    puts "Bar Counter: (_ _ _ _ 5 _ _ _) #{i} ==============="
  elsif i <= beats_per_bar * 6
    ptn = (invert_chord (chord :a, :minor),-1)
    puts "Bar Counter: (_ _ _ _ _ 6 _ _) #{i} ==============="
  elsif i <= beats_per_bar * 7
    ptn = (invert_chord (chord :bb3, :major),1)
    puts "Bar Counter: (_ _ _ _ _ _ 7 _) #{i} ==============="
  elsif i <= beats_per_bar * 8
    ptn = (invert_chord (chord :g, :major),-1)
    puts "Bar Counter: (_ _ _ _ _ _ _ 8) #{i} ==============="
    tick_reset if i == beats_per_bar * 8
  end
  play ptn
  sleep 0.5
end

######################################################
# Toggle Two Melodic Patterns using `tick` and `at`
######################################################

# Finally a very diffent approach but quite easy solution
# where you setup melody phrases
# Toggle beteen two melodies every 4 bars i. e. every run of the live_loop i. e. 8 beats
# use tick and use fact that tick increases each run of live_loop
live_loop :melody do
  stop

  use_synth :fm
  use_synth_defaults depth: 0.125, divisor: 1, attack: 0, release: 0.5

  tick # call 'tick' once, then use 'look'

  # Set up your melodic patterns
  mel1 = (ring :d3, :c4, :a3, :f3, :a3, :c3)
  mel2 = (ring :c3, :bb3, :g3, :eb3, :g3, :bb2)

  # Set up the succession of patterns, tick/look will walk through it
  mel = (ring mel1, mel1, mel2, mel2)
  # and alternative way of writing is to use 'knit':
  # mel = (knit mel1, 2, mel2, 2)

  # Set up the patterns rhythm (you could adjust the rhythm like the melody)
  ptn = (ring 0,1,2,3,6.5,7.5)

  at ptn, mel.look do |n|
    play n
  end
  sleep 8
end
