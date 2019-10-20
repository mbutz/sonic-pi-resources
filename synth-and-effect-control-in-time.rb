# Experiments with control
# synth-and-effect-control-in-time.rb

use_bpm 120

live_loop :metro do
  sleep 4
end


live_loop :bd, sync: :metro do
  #stop
  at (ring 0, 1, 2, 3) do
    sample :bd_fat, amp: 4
  end
  sleep 4
end

live_loop :percussion, sync: :metro do
  with_fx :rhpf, cutoff: 95, res: 0.95 do
    sample :loop_tabla, beat_stretch: 16, amp: 3
  end
  at (ring 0, 4, 8) do
    sample :loop_amen, beat_stretch: 4, amp: 1
  end
  at (12) do
    8.times do
      sample :loop_amen, beat_stretch: 4, amp: 1, num_slices: 8, slice: pick
      sleep 0.5
    end
  end
  sleep 16
end


live_loop :modulate, sync: :metro do
  use_synth :dsaw
  use_synth_defaults attack: 0.01, attack_level: 10, sustain: 2, release: 2

  with_fx :reverb, room: 0.75, mix: 0 do | rev |

    with_fx :lpf, cutoff: 30, amp: 1 do | lpf |
      with_fx :slicer, phase: 0.25, wave: 0, mix: 0 do | slc |
        s = synth :dsaw, note: :c2, amp: 1

        if one_in 3
          in_thread do
            sleep (ring 1, 2).choose
            control s, note: (ring :eb2, :g2).choose, note_slide: 2
            sleep 2
            control s, note: :c2, note_slide: 0.25
          end
        end

        in_thread do
          control slc, mix: 1, mix_slide: 0.25
          sleep 1.5
          control slc, mix: 0, mix_slide: 0.5
          sleep 2
        end

        in_thread do
          control lpf, cutoff: 90, cutoff_slide: 2
          sleep 2
          control lpf, cutoff: 30, cutoff_slide: 2
          sleep 1
        end
      end

    end
    control rev, mix: 1, mix_slide: 2.5
  end #/reverb
  sleep 4
end
