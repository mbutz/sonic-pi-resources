# Change release every 2 bars (length of the live_loop)
# use tick and use fact that tick increases each run of live_loop i. e. 8 beats
live_loop :melody, sync: :bar do
  stop
  use_synth :fm

  rel = (ring 0.75, 0.5, 0.5, 0.125, 0.125, 0.125)
  use_synth_defaults depth: 0.125, divisor: 1.0, attack: 0, release: rel.tick #release: 0.125

  puts "Look: #{look} ---------------"

  mel = (ring :d3, :c4, :a3, :f3, :a3, :c3)
  ptn = (ring 0,   1,   2,   3,   6.5, 7.5)
  at ptn, mel do |n|
    play n
  end
  sleep 8
end

# add modulo
# and other examples
# change filename

