# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: filter-control.rb

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

