# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: synchronization-of-live-loops.rb
# 'uncomment' the example you wan't to listen to...

use_bpm 120

###########################################
# Simple synchronisation
###########################################
comment do

  live_loop :hihat1 do
    sleep 0.5
    sample :drum_cymbal_closed
    sleep 0.5
  end

  # sync this live loop with :hihat1
  live_loop :bass1, sync: :hihat1 do
    sample :bd_ada, amp: 1
    sleep 1.75
    sample :bd_ada, amp: 1
    sleep 0.25
    sample :bd_ada, amp: 1
    sleep 2
  end

  # sync this live loop with :hihat1
  live_loop :snare1, sync: :hihat1 do
    sleep 1
    sample :drum_snare_soft
    sleep 1
  end

end #comment

####################################################
# Keeping patterns synchroneous (simple drum rhythm)
####################################################

comment do

  # Use this poor-man's mixer to start/stop hihat, bass and/or snare. You will
  # notice, that all three instruments will always continue to finish two bars
  # and also always start after a two bar-phrase has been finished. This is
  # because they do listen to `:phrase`, which counts 8 beats = 2 bars.
  run_hiht = 1
  run_bass = 1
  run_snre = 1

  # Marks the beats like a metronome
  live_loop :beat do
    sample :elec_blip2, rate: 1.5, amp: 0.125
    sleep 1 # counts every beat
  end

  # Marks a phrase of 2 bars; as it listens to `:beat` it'll
  # start as soon as `:beat` has run one time (you will hear
  # `:elec_blip2` one time solo.
  # If you remove the `sync: :beat`-command from the first line,
  # you will notice that `:phrase` will run one time solo or in
  # other words: it'll take two bars until the drums will run.
  live_loop :phrase, sync: :beat do
    sample :elec_blip2, amp: 0.25
    sleep 8 # counts 2 bars
  end

  live_loop :hihat2, sync: :phrase do
    stop if run_hiht == 0
    ptn = (ring 0.5,0.25,0.5,0.25,0.5,0.25,0.5)
    32.times do
      sample :drum_cymbal_closed, amp: ptn.tick
      sleep 0.25
    end
  end

  live_loop :bass2, sync: :phrase do
    stop if run_bass == 0
    4.times do
      sample :bd_ada, amp: 1.5
      sleep 1.75
      sample :bd_ada, amp: 1
      sleep 0.25
      sample :bd_ada, amp: 1
      if rand_i(5) > 2
        sleep 1.75
        sample :bd_ada, amp: 0.5, rate: 1.5
        sleep 0.25
      elsif
        sleep 2
      end
    end
  end

  live_loop :snare2, sync: :phrase do
    stop if run_snre == 0
    4.times do
      sleep 1
      sample :drum_snare_soft, finish: 0.5, release: 0.25
      sleep 1
    end
  end

end #comment

###############################################################
# Keeping patterns and phrases synchroneous (keyboard and bass)
###############################################################

comment do

  use_bpm 110

  # Marks the beats like a metronome
  live_loop :beat do
    sleep 1 # counts every beat
  end

  # Marks the beats like a metronome
  live_loop :four_bars, sync: :beat do
    sample :elec_blip2, rate: 1.5, amp: 1
    sleep 16 # counts 4 bars
  end

  # chords
  live_loop :pad, sync: :four_bars do
    #stop
    use_synth :beep
    use_synth_defaults amp: 0.45, attack: 0.1, sustain: 0.5, release: 3
    with_fx :reverb, room: 1, mix: 0.75 do
      with_fx :flanger do
        play [:b3, :b4, :d4, :fs4, :a4, :fs5]
        sleep 1.5
        play [:d3, :g4, :a4, :d4, :g5]
        sleep 6.5
        play [:a3, :e4, :a4, :b4, :e5]
        sleep 1.5
        play [:gs3, :gs4, :e4, :b4, :e5]
        sleep 6.5
      end
    end
  end

  # Bass Line "Radio Musicola", Nik Kershaw
  bassline = (ring :b2,:b3,:e2,:e2,:r,:r,:e3,:g2,
              :r,:e2,:g3,:e2,:r,:g3,:e2,:g2,
              :r,:e3,:e2,:g3,:e2,:r,:g2,:r,
              :e2,:g3,:e2,:g2,:r,:d2,:e2,:g2,
              :a2,:r,:e2,:a2,:r,:e3,:a3,:a2,
              :gs2,:r,:r,:e2,:gs2,:gs3,:e2,:gs3,
              :r,:e2,:e3,:gs3,:e2,:r,:gs3,:e2,
              :gs2,:r,:e3,:gs2,:r,:e2,:a2,:as2)

  # bassline
  live_loop :bass_line, sync: :four_bars do
    #stop
    use_synth :fm
    use_synth_defaults amp: 0.75, attack: 0.0, sustain: 0.15, release: 0.01, cutoff: 70
    play_pattern_timed bassline, 0.25
  end

end #comment
