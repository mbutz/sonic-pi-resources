# Little snippets and solutions for various things
# howto-miscellaneous.rb

# Off-Beat pattens with hihat: spread + rotate

live_loop :hat do
  if spread(2, 4).rotate(1).tick
    sample :drum_cymbal_closed, finish: 0.125
  end
  sleep 0.5
end

# Modulo for regular events

# syncoping with kick
# solution 1
live_loop :kick1 do
  cnt = tick % 4 # count 0..3
  sample :bd_ada, amp: 1.5, attack_level: 3
  at (ring 0.75) do # a syncope every fourth beat
    sample :bd_ada, amp: 1.5, attack_level: 3 if cnt == 3
  end
  sleep 1
end

# solution 2
live_loop :kick2 do
  #stop
  at (ring 0,1,2,3) do
    sample :bd_ada, amp: 1.5
  end
  at (ring 3.875) do
    sample :bd_ada, amp: 1.5
  end
  sleep 4
end

# change note
live_loop :bass do
  use_synth :fm
  use_synth_defaults release: 0.5, depth: 1, divisor: 1
  cnt = tick % 8
  if cnt < 4
    n = :cs2
  elsif cnt < 6
    n = :e2
  elsif cnt < 8
    n = :fs2
  end
  play n
  sleep 0.5
end
