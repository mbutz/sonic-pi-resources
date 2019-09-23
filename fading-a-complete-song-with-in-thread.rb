# Sonic Pi resources collected by Martin Butz, mb@mkblog.org
# filename: blending-a-complete-song-with-in-thread.rb

# beats and bars:
# 1 bar = 4 beats = 16 * 0.25 beats
# if you count all the sleeps, the tune is 16 bars or 64 beats long
use_bpm 120

# Set amp and slide values to 0 and give SP time to notice
# This makes sure that with repeated runs you will always reset
# the values for amp and slide.
set_mixer_control! amp: 0, amp_slide: 0
sleep 0.1

# Set amp for the following code to slide from 0 to 1 within
# 8 beats or 4 bars:
set_mixer_control! amp: 2, amp_slide: 8

# one loop = one bar
# let the drums play for 16 bars, 4 bars fade in
in_thread do
  16.times do
    sample :loop_amen, beat_stretch: 4
    sleep 4
  end
end

sleep 16
puts "After the 4-bar-fade start the the bassline."

# bassline is 2 bars long (8 beats)
# let it play along the drums which will last for
# 12 bars from here on ...
in_thread do
  with_synth :fm do
    with_synth_defaults release: 0.5, cutoff: 60, depth: 2, amp: 1.5 do
      6.times do
        play :c2
        sleep 0.5
        play :c2
        sleep 3.5
        play :g2, release: 0.5, amp: 0.75
        sleep 0.5
        play :g2, release: 1
        sleep 3
        play :bb2
        sleep 0.5
      end
    end
  end
end

# = 16 beats
sleep 16
puts "Start the keyboard after the bass phrase has played 2 times."

in_thread do
  with_fx :reverb, room: 0.75, mix: 0.5 do
    with_synth :dsaw do
      with_synth_defaults cutoff: 80, amp: 1.5 do
        4.times do
          play (chord :c4, :minor7), release: 0.25
          sleep 1.5
          play (chord :c4, :minor7), release: 1.25
          sleep 1.5
          play (chord :d4, :minor7), release: 0.25
          sleep 3.5
          play (chord :d4, :minor7), release: 0.25
          sleep 1.5
        end
      end
    end
  end
end

#remaining beats/beats for the track is 32 beats / 8 bars
# let 4 bars play and then fade out for 4 bars
sleep 16
set_mixer_control! amp: 0, amp_slide: 8
puts "Start fading out ..."
stop
