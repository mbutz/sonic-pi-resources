# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: use-of-spread.rb

# use 'stop' resp. '#stop' to play the loops

use_bpm 120
metro_on = 1 # audible metronom beats
metro_lv = 0.25

# a metronom counting and synchronizing bars
# uncomment samples if you need to hear bar and quarter notes
live_loop :bar do
  if metro_on == 1
    sample :elec_blip2, amp: metro_lv
    sleep 1
    3.times do
      sample :elec_blip2, amp: metro_lv, rate: 1.5
      sleep 1
    end
  else
    sleep 4
  end
end

###########################################
# Simple Rhythms
###########################################
# | x - - - | x - - - | x - - - | x - - - |
live_loop :hat_8th_onbeat, sync: :bar do
  stop
  8.times do
    if spread(4, 8).tick
      sample :drum_cymbal_closed, amp: 0.5
    end
    sleep 0.5
  end
end

# | - - x - | - - x - | - - x - | - - x - |
live_loop :hat_8th_offbeat, sync: :bar do
  stop
  8.times do
    if spread(4, 8).reverse.tick
      sample :drum_cymbal_closed, amp: 0.5
    end
    sleep 0.5
  end
end

# | x - x - | x - x - | x - x - | x - x - |
live_loop :hat_16th_onbeat, sync: :bar do
  stop
  16.times do
    if spread(16, 16).tick
      sample :drum_cymbal_closed, amp: 0.5
    end
    sleep 0.25
  end
end

# | - x - x | - x - x | - x - x  | - x - x |
live_loop :hat_16th_offbeat, sync: :bar do
  stop
  16.times do
    if spread(8, 16).reverse.tick
      sample :drum_cymbal_closed, amp: 0.5
    end
    sleep 0.25
  end
end

# For a list of (more or less common) used irregular rhythms created with spread see Sonic Pi language reference, `spread`, example #4

###########################################
# Baseline using two live_loops and `spread`
###########################################

# set the synth for the following two live_loops
use_synth :fm
use_synth_defaults release: 0.25, amp: 3

# A very simple bassline
live_loop :bass, sync: :bar do
  stop
  play :e2
  sleep 4
  play :a2
  sleep 4
end

# A second accentuating bassline
bass_spread = (ring :g3, :c3, :c3, :d3, :g2, :d3, :a3, :a2)

live_loop :bass_spread, sync: :bar do
  stop
  # Let this live_loop be 1 bar long => 16 x sleep 0.25
  16.times do
    # `spread` returns `true` (hit or accent) or `false` (rest) e.g.
    # `(spread 3, 16)` = (ring true, false, false, false, false, false, true, false, false, false, false, true, false, false, false, false)
    #
    # Next line: If spread returns true, look up the current note of bass_spread and play it
    # To randomize the number of notes choosen from `bass_spread`, `choose` one value from
    # the given list `[7,11,13]` each iteration. You can provide any value between 0 and 16.
    # Uneven values such as 5, 9, 13 sound better if you like syncopation
    play bass_spread.look if spread([7,11,13].choose,16).tick
    #play bass_spread.look if spread(16,16).tick # try this in comparison...
    sleep 0.25
  end
end

#########################################################
# Creating overlayed cowbell (hihat or whatever) rhythms
#########################################################

live_loop :cowbell, sync: :bar do
  stop
  with_fx :reverb, room: 0.25, mix: 0.5 do
    16.times do
      # You see: you can base your accents (4, 7, 13) on different
      # rhythm patterns (16, 12, 32) creating quite complex outcomes.
      # Would probably be interesting to
      sample :elec_bell, rate: 1.5, amp: 1.0 if spread(4,16).tick
      sample :elec_bell, rate: 2.0, amp: 1.0 if spread(7,12).look
      sample :elec_bell, rate: 2.75, amp: 1.0 if spread(13,32).look
      sleep 0.25
    end
  end
end

###########################################
# Baseline using two live_loops and `spread`
###########################################

