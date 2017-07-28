# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: samba-with-spread-and-at.rb

# use 'stop' resp. '#stop' to play the loops

use_bpm 180
metro_on = 0 # audible metronom beats
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

#########################################################
# A samba rhythm
#########################################################

# See Victor Lopez, Latin Rhythms: MYSTERY UNRAVELED, page 16
# https://www.midwestclinic.org/user_files_1/pdfs/clinicianmaterials/2005/victor_lopez.pdf
#

live_loop :shaker_cabasa, sync: :bar do
  #stop
  # Shaker
  # >       >       | >       >       |
  # _______ _______ | _______ _______ |
  # | | | | | | | | | | | | | | | | | |
  # x x x x x x x x | x x x x x x x x |
  with_synth :cnoise do
    with_synth_defaults attack: 0.0125, release: 0.25 do
      with_fx :hpf, cutoff: 115 do
        if spread(4,16).tick
          play :c, amp: 1.5
        elsif
          play :c, amp: 0.75
        end
      end
    end
    
    # Cabasa
    #     >       >   |     >       >   |
    #     ___     ___ |     ___     ___ |
    # |   | | |   | | | |   | | |   | | |
    # x   x x x   x x | x   x x x   x x |
    with_synth_defaults attack: 0.1, release: 0.25 do
      with_fx :hpf, cutoff: 70 do
        if spread(6, 8, rotate: 2).reverse.look
          play :c, amp: 0.25
        end
      end
    end
  end
  
  sleep 0.5
end

live_loop :cabasa_accents, sync: :bar do
  #stop
  # Cabasa accents
  #     >       >   |     >       >   |
  #     ___     ___ |     ___     ___ |
  # |   | | |   | | | |   | | |   | | |
  # x   x x x   x x | x   x x x   x x |
  with_synth :cnoise do
    with_synth_defaults attack: 0.1, release: 0.25 do
      with_fx :hpf, cutoff: 60 do
        at(ring 1,3) do
          play :c, amp: 0.25
        end
      end
    end
  end
  sleep 4
end

live_loop :agogo_congas, sync: :bar do
  #stop
  # Agogo Bell
  #         ___   _ |   _   _         |
  # |   |   | |   | |   |   | |   |   |
  # x   x   | | 7 x | 7 x 7 x |   |   |
  #         x x     |         x   x   |
  at(ring 0,1,3.5,4.5,5.5) do
    sample :elec_bell, rate: 2.125, amp: 1.0
  end
  at(ring 2,2.5,6,7) do
    sample :elec_bell, rate: 1.7, amp: 1.0
  end
  
  # Congas
  #       _       _ |       _ ___     |
  # |     |  |    | | 7   7 | | | |   |
  # x.    x  x.   x | 7     x x x x   |
  at(ring 0,1.5,2,3.5,5.5,6,6.5,7) do
    sample :tabla_tas3, rate: 0.65
  end
  
  sleep 8
end

# Drum-Set
#     _______ ___   _______     ___ |
# |   | | | | | | | | | | | |   | | |
# x   x x x | x x | x | x x x   x x | closed hihat
#     |     |     |   |     |   |   |
#     x     x     |   x     x   x   | snare
#                 |                 |
# x     x x     x | x     x x     x | bassdrum
# |   7 | |   7 | | |   7 | |   7 | |
#       -       - |       -       - |
live_loop :snare_bassdrum, sync: :bar do
  #stop
  at (ring 1,3,4.5,6,7) do
    sample :drum_snare_hard, amp: 0.75
  end
  at (ring 0,1.5,2,3.5,4,5.5,7,7.5) do
    sample :tabla_ghe4, rate: 0.5, amp: 2, finish: 0.75, release: 0.25
  end
  sleep 8
end

live_loop :hihat, sync: :bar do
  #stop
  if spread(6, 8, rotate: 2).reverse.tick
    sample :drum_cymbal_closed
  end
  sleep 0.5
end
