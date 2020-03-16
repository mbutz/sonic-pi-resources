# How to manipulate a collection of notes (a list)
# Of course the list could contain other values such
# cutoff values aso.
#
# manipulate-a-collection-of-notes.rb

# Note: _Not_ all of these methods are officially supported
# by Sonic Pi, some of them are pure Ruby; they do work
# by the time I wrote this file though (Sonic Pi 3.1).
# For a list of officially supported Sonic Pi functions see:
# chapter 8.5 of the tutorial.

# We start with this note collection
a_scale = (scale :d, :aeolian)
puts "A scale (original): #{a_scale}"
puts "------------------------------------------------------------"
one_to_five = (range 0, 6, step: 1)
puts "One to five (original): #{one_to_five}"
puts "------------------------------------------------------------"
random_notes = (ring 122, 8, 20, 39, 87)
puts "Random notes (original): #{random_notes}"
puts "------------------------------------------------------------"
a_chord = (chord :a, :major7)
puts "A chord (A Major 7): #{a_chord}"
puts "============================================================"

# Remove first (base) note
ptn1 = a_chord.delete_at(0)
puts "delete_at(0):"
puts "#{a_chord} =>"
puts "#{ptn1}"
puts "------------------------------------------------------------"

# Reverse
ptn2 = a_chord.reverse
puts "reverse:"
puts "#{a_chord} =>"
puts "#{ptn2}"
puts "------------------------------------------------------------"

# Sort
ptn3 = random_notes.sort
puts "sort:"
puts "#{random_notes} =>"
puts "#{ptn3}"
puts "------------------------------------------------------------"

# Shuffle
ptn4 = one_to_five.shuffle
puts "shuffle:"
puts "#{one_to_five} =>"
puts "#{ptn4}"
puts "------------------------------------------------------------"

# Random pick, apply 'choose' 3 times
ptn5 = a_scale.pick(3)
puts "pick(3):"
puts "#{a_scale} =>"
puts "#{ptn5}"
puts "------------------------------------------------------------"

# .take(3) - return head
ptn6 = a_scale.take(3)
puts "take(3):"
puts "#{a_scale} =>"
puts "#{ptn6}"
puts "------------------------------------------------------------"

# .drop(5) - remove head
ptn7 = a_scale.drop(5)
puts "drop(5):"
puts "#{a_scale} =>"
puts "#{ptn7}"
puts "------------------------------------------------------------"

# .butlast - remove last
ptn8 = a_scale.butlast
puts "butlast:"
puts "#{a_scale} =>"
puts "#{ptn8}"
puts "------------------------------------------------------------"


# .drop_last(5) - remove tail
ptn9 = a_scale.drop_last(5)
puts "drop_last(5):"
puts "#{a_scale} =>"
puts "#{ptn9}"
puts "------------------------------------------------------------"

# .take_last(3) - return tail
ptn10 = a_scale.take_last(3)
puts "take_last(3):"
puts "#{a_scale} =>"
puts "#{ptn10}"
puts "------------------------------------------------------------"

# .stretch(3) - repeat each n times
ptn11 = a_chord.stretch(3)
puts "stretch(3):"
puts "#{a_chord} =>"
puts "#{ptn11}"
puts "------------------------------------------------------------"

# .repeat(3) - repeat ring n times
ptn12 = a_chord.repeat(3)
puts "repeat(3):"
puts "#{a_chord} =>"
puts "#{ptn12}"
puts "------------------------------------------------------------"

# .mirror - 2 center elements
ptn13 = a_chord.mirror
puts "mirror:"
puts "#{a_chord} =>"
puts "#{ptn13}"
puts "------------------------------------------------------------"

# .reflect - only one center element
ptn14 = a_chord.reflect
puts "reflect:"
puts "#{a_chord} =>"
puts "#{ptn14}"
puts "------------------------------------------------------------"

# .scale(2) - multiply each element
ptn15 = a_chord.scale(2)
puts "scale(2):"
puts "#{a_chord} =>"
puts "#{ptn15}"
puts "------------------------------------------------------------"

# .values_at(0, 2, 4, 6) - select element(s)
puts (scale :e3, :minor).values_at(0, 2, 4)
ptn16 = a_scale.values_at(0, 2, 4, 6)
puts "values_at(0, 2, 4, 6):"
puts "#{a_scale} =>"
puts "#{ptn16}"
puts "------------------------------------------------------------"
