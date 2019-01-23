# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: change-params-per-pattern.rb
# Use 'un/comment' or 'stop' to listen to the examples.

use_bpm 120

# A very common task while creating music is that
# you want to set up certain recurrent pattern such as e. g.
# a bassline that repeats three times and than is variated
# in a certain way to start over all again.

# The general principle of the next two examples is the following:
# 1. We count the `live_loop` runs with `tick`
# 2. As we want to count a recurrent pattern such as
#    48 beats in the following example we can not count
#    the raw tick, because this will not count e. g. from 0 to 48
#    but go on forever (as long as the `live_loop` is running).
#    So we use the modulo operator `%` to create a counter i
#    that runs through our 48 beats and then starts all over
#    again: Modulo gives us the remainder of an integer division,
#    meaning 5 / 48 will return 5, because as a whole number 5 can't
#    be devided by 48. 48 / 48 will return 0 because there is no remainder.
#    In essence `tick % 48` will return a number that counts from 0 to 47
#    and then starts with 0 again.

######################################################
# Blues Bassline: Counting Beats with Modulo
######################################################

comment do
  
  # Not very musical but meant as a simple proof of concept
  # Of course you could achieve the same result in using `play_pattern_timed`
  # or `at`; but it is meant as a simple example before we come to more
  # complicated stuff.
  
  live_loop :blues1 do
    use_bpm 120
    i = tick % 48
    puts "Counter is at: #{i}"
    
    if i < 4
      n = :c2
    elsif i < 8  # First two bars/8 beats
      n = :f2
    elsif i < 16 # 3rd and 4th bar / from beat #8 to #16
      n = :c2
    elsif i < 24 # aso.
      n = :f2
    elsif i < 32
      n = :c2
    elsif i < 36
      n = :g2
    elsif i < 40
      n = :f2
    elsif i < 48
      n = :c2
    end
    
    with_synth :fm do
      with_synth_defaults cutoff: 70, depth: 1, divisor: 1, release: 0.5 do
        play n
      end
    end
    sleep 1
  end
  
end # comment

######################################################
# Bass Phrase: Counting Bars with Modulo
######################################################

comment do
  
  # a musically more advanced example following the same idea
  
  use_bpm 130
  
  live_loop :beat do
    sleep 1
  end
  
  live_loop :bass, sync: :beat do
    
    # We can also count bars; that's a simple matter of how long
    # your live_loop runs. This one runs for 4 beats, thus our
    # counter `bar` with every step advances one bar.
    
    # On the whole we will have to count 8 bars (32 beats), so we
    # will modulo-devide through 8
    bar = tick % 8
    
    puts "================================"
    puts "Tick: #{look} - Actual No. of Bar: #{bar +1}"
    puts "================================"
    
    master_vol = 0.75
    
    if bar < 4 then # range from bar 1-4 (resp. 0-3)
      note = :c1
    elsif bar < 6 then # range from bar 5-6 (resp. 4-5)
      note = :eb1
    elsif bar < 8 then # range from bar 7-8 (resp. 6-7)
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
# Chord Sequence: Counting Bars with Modulo
######################################################

# One last example for the modulo solution:

comment do
  
  live_loop :counting_tick_offset do
    
    use_synth_defaults release: 0.25
    
    bar =  4
    i = tick % 32
    if i < bar * 1
      ptn = (invert_chord (chord :c, :major), 1)
      puts "Bar Counter: (1 _ _ _ _ _ _ _) #{i} ==============="
    elsif i < bar * 2
      ptn = (invert_chord (chord :a, :minor),-1)
      puts "Bar Counter: (_ 2 _ _ _ _ _ _) #{i} ==============="
    elsif i < bar * 3
      ptn = (invert_chord (chord :f, :major),0)
      puts "Bar Counter: (_ _ 3 _ _ _ _ _) #{i} ==============="
    elsif i < bar * 4
      ptn = (invert_chord (chord :g, :major),-1)
      puts "Bar Counter: (_ _ _ 4 _ _ _ _) #{i} ==============="
    elsif i < bar * 5
      ptn = (invert_chord (chord :e, :minor),0)
      puts "Bar Counter: (_ _ _ _ 5 _ _ _) #{i} ==============="
    elsif i < bar * 6
      ptn = (invert_chord (chord :a, :minor),-1)
      puts "Bar Counter: (_ _ _ _ _ 6 _ _) #{i} ==============="
    elsif i < bar * 7
      ptn = (invert_chord (chord :bb3, :major),1)
      puts "Bar Counter: (_ _ _ _ _ _ 7 _) #{i} ==============="
    elsif i < bar * 8
      ptn = (invert_chord (chord :g, :major),-1)
      puts "Bar Counter: (_ _ _ _ _ _ _ 8) #{i} ==============="
    end
    play ptn
    sleep 0.5
  end
  
end # comment

######################################################
# Blues Form: Using `at` to create pattern
######################################################
comment do
  
  # As you just change one note, you might be better off
  # using `at` to change the to play the blues bass; or
  # you could take `play_pattern_timed`; so 1st there are
  # usually several options and 2nd the modulo solution is
  # not necessarily a good choice for just playing a melody
  
  live_loop :blues2 do
    use_bpm 120
    use_synth :fm
    use_synth_defaults cutoff: 70, depth: 0.5, divisor: 1
    
    at (ring 0,4,8, 12,16,20, 24,28,32, 36,40,44),
    (ring :c2,:f2,:c2,:c2, :f2,:f2,:c2,:c2, :g2,:f2,:c2,:c2) do |n|
      4.times do
        play n
        sleep 1
      end
    end
    sleep 48
  end
  
end # comment

comment do
  
  # To save a bit of writing you can use `knit`
  
  live_loop :blues_alt_notation do
    use_bpm 120
    use_synth :fm
    use_synth_defaults cutoff: 70, depth: 0.5, divisor: 1
    
    bar   = (line 0,48, steps: 12) # every beat of a bar
    notes = (knit :c2, 1, :f2, 1,
             :c2, 2,
             :f2, 2,
             :c2, 2,
             :g2, 1, :f2, 1,
             :c2, 2)
    
    at bar,notes do |n|
      4.times do
        play n
        sleep 1
      end
    end
    sleep 48
  end
  
end # comment

######################################################
# Toggle Two Melodic Patterns using `tick` and `at`
######################################################

# Finally a very diffent approach but quite easy solution
# where you setup melody phrases
# Toggle beteen two melodies every 4 bars i. e. every run of the live_loop i. e. 8 beats
# use tick and use fact that tick increases each run of live_loop

comment do
  
  live_loop :melody do
    
    use_synth :fm
    use_synth_defaults depth: 0.125, divisor: 1, attack: 0, release: 0.5
    
    tick # call 'tick' once, then use 'look'
    
    # Set up your melodic patterns
    mel1 = (ring :d3, :c4, :a3, :f3, :a3, :c3)
    mel2 = (ring :c3, :bb3, :g3, :eb3, :g3, :bb2)
    
    # Set up the patterns rhythm (you could adjust the rhythm like the melody)
    ptn = (ring 0,1,2,3,6.5,7.5)
    
    # Set up the succession of patterns, tick/look will walk through it
    mel = (ring mel1, mel1, mel2, mel2)
    # and alternative and slightly shorter way of notation is to use 'knit':
    # mel = (knit mel1, 2, mel2, 2)
    
    at ptn, mel.look do |n|
      play n
    end
    sleep 8
  end
  
end # comment