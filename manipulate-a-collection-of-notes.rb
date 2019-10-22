# How to manipulate a collection of notes (a list)
# Of course the list could contain other values such
# as a number of cutoff values aso.
#
# manipulate-a-collection-of-notes.rb

# Note: Not all of these methods are officially supported
# by Sonic Pi, but some of them are pure Ruby; they do work
# by the time I wrote this file though.
# For a list of officially supported Sonic Pi functions see:
# chapter 8.5 of the tutorial.

# We start with this note collection
ptn0 = (scale :d, :aeolian)
puts "Original: #{ptn0}"

# Remove first (base) note
ptn1 = ptn0.delete_at(0)
puts "Remove first: #{ptn1}"

# Reverse
ptn2 = ptn0.reverse
puts ": #{ptn}"

# .reverse - gibt eine umgedrehte Version des Rings zurück
# .sort - stellt eine sortierte Version des Rings her
puts ": #{ptn}"

# .shuffle - liefert eine neu gemischte Version des Rings
puts ": #{ptn}"

# .pick(3) - liefert einen Ring nachdem 3-mal .choose angewendet wurde
puts ": #{ptn}"

# .take(5) - liefert einen neuen Ring, der nur die ersten 5 Elementen enthält
puts ": #{ptn}"

# .drop(3) - liefert einen neuen Ring, der alles außer den ersten 3 Elementen enthält
puts ": #{ptn}"

# .butlast - liefert einen neuen Ring ohne das letzte Element
puts ": #{ptn}"

# .drop_last(3) - liefert einen neuen Ring ohne die letzten 3 Elemente
puts ": #{ptn}"

# .take_last(6)- liefert einen neuen Ring, der nur die letzten 6 Elemente enthält
puts ": #{ptn}"

# .stretch(2) - wiederholt jedes Element im Ring zweimal
puts ": #{ptn}"

# .repeat(3) - wiederholt den ganzen Ring 3-mal
puts ": #{ptn}"

# .mirror - hängt eine umgekehrte Version des Rings an die ursprüngliche an
puts ": #{ptn}"

# .reflect - wie .mirror, verdoppelt aber nicht die mittleren Werte
puts ": #{ptn}"

# .scale(2) - gibt einen neuen Ring zurück, der alle Elemente des ursprünglichen Rings mit 2 multipliziert enthält (Voraussetzung: Ring enthält nur Zahlen)
puts ": #{ptn}"