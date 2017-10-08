# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: electro-drum-pattern-with-2-sliced-samples.rb
# use '#stop'/'stop' to listen to the example


# Have meaningful 8-bar pieces
# try to start pieces dependant on each other

use_bpm 120

live_loop :beat do
  sleep 1
end

live_loop :metro, sync: :beat do
  sleep 8
end

live_loop :samples do
  stop
  sample loopmaster, 29, beat_stretch: 16
  #sleep 16
  #sample loopmaster, 30, beat_stretch: 16
  sleep 16
end

live_loop :ed_ptn1, sync: :metro do
  stop
  
  # Slices 16 beat long sample into 8 slices (each 2 beats long)
  # Collect slices into patterns
  # Whole sample would look like:
  # ptn = (ring 0,1,2,3,4,5,6,7) or ptn = (range 0,7)
  ptn = (ring 2,2,2,6,  2,2,6,2,  2,2,6,2,  2,6,6,7)
  
  with_fx :hpf, cutoff: 35 do
    sample loopmaster, 29, beat_stretch: 16, num_slices: 8, slice: ptn.tick
  end
  sleep 2
end

live_loop :ed_pnt2, sync: :metro do
  #stop
  
  ptn = (ring 5,1,2,1,  2,1,2,5,  2,1,2,1,  2,1,2,5)
  #ptn = (ring 5) # without crash: 1,2,5
  
  2.times do
    with_fx :hpf, cutoff: (range 35, 130, step: 10).ramp.look(:hp) do
      sample loopmaster, 30, beat_stretch: 16, num_slices: 8, slice: ptn.tick
    end
    sleep 2
  end
end

