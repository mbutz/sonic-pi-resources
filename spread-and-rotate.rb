# spread-and-rotate.rb
# rotate

# rotate takes n elements from the start and
# puts them at the end of the array
puts (ring 1, 2, 3, 4).rotate(0) # 1, 2, 3, 4
puts (ring 1, 2, 3, 4).rotate(1) # 2, 3, 4, 1
puts (ring 1, 2, 3, 4).rotate(3) # 4, 1, 2, 3

use_bpm 120

# experiments with kick and hihat
comment do
  
  # | x - - - | x - - - | x - - - | x - - - |
  live_loop :kick do
    sample :bd_ada, amp: 1
    sleep 1
  end
  
  # spread(4, 16)
  # | x - - - | x - - - | x - - - | x - - - | rotate 0
  # | - - - x | - - - x | - - - x | - - - x | rotate 1
  # | - - x - | - - x - | - - x - | - - x - | rotate 2
  # | - x - - | - x - - | - x - - | - x - - | rotate 3
  # | x - - - | x - - - | x - - - | x - - - | rotate 4
  live_loop :spread_4_16 do
    stop
    if spread(4, 16).rotate(4).tick
      sample :drum_cymbal_closed
    end
    sleep 0.25
  end
  
  # Play 16 bars and go through all permutations
  
  # spread(5, 16)
  # | x - - - | x - - x | - - x - | - x - - | rotate(0)
  # | - - - x | - - x - | - x - - | x - - x | rotate(1)
  # | - - x - | - x - - | x - - x | - - x - | rotate(2)
  # | - x - - | x - - x | - - x - | - x - - | rotate(3)
  # | x - - x | - - x - | - x - - | x - - - | rotate(4)
  # | - - x - | - x - - | x - - x | - - - x | rotate(5)
  # | - x - - | x - - x | - - x - | - - x - | rotate(6)
  # | x - - x | - - x - | - x - - | - x - - | rotate(7)
  # | - - x - | - x - - | x - - - | x - - x | rotate(8)
  # | - x - - | x - - x | - - - x | - - x - | rotate(9)
  # | x - - x | - - x - | - - x - | - x - - | rotate(10)
  # | - - x - | - x - - | - x - - | x - - x | rotate(11)
  # | - x - - | x - - - | x - - x | - - x - | rotate(12)
  # | x - - x | - - - x | - - x - | - x - - | rotate(13)
  # | - - x - | - - x - | - x - - | x - - x | rotate(14)
  # | - x - - | - x - - | x - - x | - - x - | rotate(15)
  
  cnt = 0
  live_loop :spread_5_16 do
    stop
    puts "Run No.: #{cnt + 1}"
    16.times do
      if spread(5, 16).rotate(cnt).tick
        sample :drum_cymbal_closed
      end
      sleep 0.25
    end
    cnt += 1
  end
  
  # spread(6, 16)
  # repeats every 8 bars
  live_loop :spread_6_16 do
    #stop
    16.times do
      if spread(6, 16).rotate(cnt).tick
        sample :drum_cymbal_closed
      end
      sleep 0.25
    end
    cnt += 1
  end
  
  # spread(12, 16)
  # repeats every 4 bars
  live_loop :spread_12_16 do
    stop
    16.times do
      if spread(12, 16).rotate(cnt).tick
        sample :drum_cymbal_closed, finish: 0.0725
      end
      sleep 0.25
    end
    cnt += 1
  end
  
end #comment

live_loop :drums do
  with_fx :rbpf, centre: 80, res: 0.5 do
    sample :loop_amen, amp: 0.25, beat_stretch: 4
  end
  sleep 4
end

use_synth :fm
use_synth_defaults depth: 1, divisor: 1, release: 2

live_loop :bass_base do
  play :c2
  sleep 3.5
  play (ring :bb1, :bb1, :bb1, :g1).choose
  sleep 4.5
end

live_loop :spread_4_16 do
  if spread((ring 3, 5, 7).choose, 16).rotate(3).tick
    with_synth_defaults attack_level: rrand(1, 2) do
      play (scale :c3, :minor_pentatonic).choose, release: 0.25, amp: rrand(0, 0.5)
    end
  end
  sleep 0.25
end

