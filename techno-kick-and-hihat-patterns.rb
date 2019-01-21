# Off-beat hihat
# how-to-off-beat-hihat.rb

# (un)comment the `stop` to switch live_loop's on/off
# Note: do carefully check which stop's are uncommented
#       to be sure what exactly is playing right now.

use_bpm 120

live_loop :metro do
  sleep 1
end

########################################################
### Kick Patterns ######################################
########################################################

# let's start very simple
live_loop :kick1, sync: :metro do
  stop
  sample :bd_ada
  sleep 1
end

# custom timing made with `at`
# easy to remove/add more (off)beats
live_loop :kick2, sync: :metro do
  stop
  at(ring 0, 1, 2, 3) do
    sample :bd_ada
  end
  sleep 4
end

# four-on-the-floor with range (default stepsize = 1)
# add offbeat random accents with + (ring [list].choose)
live_loop :kick3, sync: :metro do
  stop
  at(range 0, 4) + (ring [3.25, 3.75].choose) do
    sample :bd_ada
  end
  sleep 4
end

# same as `kick3` but with adjusted volume for accents
# `at` can get an additional parameter list, see the documentation
live_loop :kick4, sync: :metro do
  stop
  at(range 0, 4) + (ring [3.25, 3.75].choose), (ring 1, 1, 1, 1, 0.5) do | a |
    sample :bd_ada, amp: a
  end
  sleep 4
end

# alternative way of putting it to broaden the knowledge of Sonic Pi expressions
live_loop :kick5, sync: :metro do
  #stop
  at(range 0, 4) + (ring [3.25, 3.75].choose), (knit 1, 4, 0.5, 1) do | a |
    sample :bd_ada, amp: a
  end
  sleep 4
end

########################################################
### Hihat Patterns #####################################
########################################################

# simple sleep / sample / sleep-patten
# | - x - x | -> sleep 0.5 = 8th
# | - x - x - x - x | -> sleep 0.25 = 16th
live_loop :hihat1, sync: :metro do
  stop
  sleep 0.5
  sample :drum_cymbal_closed
  sleep 0.5
end

# another option, easier to manipulate
#
live_loop :hihat2, sync: :metro do
  stop
  sample :drum_cymbal_closed, amp: (ring 0, 1).tick
  sleep 0.5
end

# easier to speed up/change but needs more performance: sleep 0.25
live_loop :hihat3, sync: :metro do
  stop
  sample :drum_cymbal_closed, amp: (ring 0, 0, 1, 0).tick
  sleep 0.25
end

# you can increase and variate pattern length like so:
live_loop :hihat4, sync: :metro do
  #stop
  sample :drum_cymbal_closed, amp: (ring 0, 0, 1, 0,   0, 0, 1, 0.5).tick
  sleep 0.25
end

# syncopating 2nd hihat
# if spread() with sleep 0.25 (16th)
live_loop :hihat_sync1, sync: :metro do
  stop
  sample :drum_cymbal_closed, finish: 0.125, rate: 1.25 if spread((ring 5, 7, 9).choose, 16).tick
  sleep 0.25
end

# same as :hihat_sync1 but with noise synth instead of sample
live_loop :hihat_sync2, sync: :metro do
  stop
  use_synth :cnoise
  use_synth_defaults release: 0.025, amp: 1
  with_fx :hpf, cutoff: rrand_i(100, 120) do
    play :c if spread([5, 7, 13].choose, 16).tick
  end
  sleep 0.25
end