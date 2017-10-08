# Sonic Pi Resources

This repository is a personal and (more or less) structured collection of my experiments, ideas and notes of how I use Sonic Pi. As this it will be under permanent construction. Much of this is borrowed and/or inspired by other people.

[Sonic Pi](http://sonic-pi.net/) is - among others - a live coding environement created by [Sam Aaron](https://github.com/samaaron/). For a thorough introduction to Sonic Pi it is best to download and install the program and work through the inbuild tutorial.

A preliminary outline of issues I have in mind and will gradually complete:

* Control rhythmic and melodic processes in time
  * [Several Ways to play a melody](https://github.com/mbutz/sonic-pi-resources/blob/master/control_rhythmic_and_melodic_processes)
  * [Use of `at`](https://github.com/mbutz/sonic-pi-resources/blob/master/control_rhythmic_and_melodic_processes/use-of-at.rb)
  * [Use of `spread`](https://github.com/mbutz/sonic-pi-resources/blob/master/control_rhythmic_and_melodic_processes/use-of-spread.rb)
  * [Simple Samba with `spread` and `at`](https://github.com/mbutz/sonic-pi-resources/blob/master/control_rhythmic_and_melodic_processes/samba-with-spread-and-at.rb)
  * [Synchronisation of `live_loops`](https://github.com/mbutz/sonic-pi-resources/blob/master/control_rhythmic_and_melodic_processes/synchronisation-of-live-loops.rb)
  * [Change Parameters per Pattern](https://github.com/mbutz/sonic-pi-resources/blob/master/control_rhythmic_and_melodic_processes/change-params-per-pattern.rb)
* Manipulate sound
  * Filters
   * `control` a filter
   * Echo and break
   * Noise to music using `:bpf`
   * Hall-Schwanz
   * Filter (un)wanted frequencies
     * FIXME: band_eq
     * FIXME: hpf
  * Synths
  * `:fm` (frequency modulation)
  * `control` a running synth
  * `control` and samples
  * [Volume (Blending)]((https://github.com/mbutz/sonic-pi-resources/blob/master/blending.rb))
  * Fake L(ow)F(requency)O(sscilator)
* Drums
   * FIXME: synthetic kick with synth
   * FIXME: technique to create 32-bar-pattern
   * FIXME: Create drum loop from sliced samples
* Miscellaneous musical ideas and effects
  * Percussion with noise
  * `slicer` and rhythm
  * `reverb`
  * Echo and canon
  * Layered samples with different rates
* Music and chance
* Linear flow versus loo
* [Working with Samples](https://github.com/mbutz/sonic-pi-resources/blob/master/working_with_samples)
  * [Slicing Samples](https://github.com/mbutz/sonic-pi-resources/blob/master/working_with_samples/slicing_samples.rb)
  * FIXME: Referencing samples in collections
  * FIXME: Rhythmic sample overlays (running samples at different rates, same duration, one live_loop) 
* Live Looper
  * FIXME: Recorder
  * FIXME: Recorder with fading sound

(I will write in English. This is not my first language. If you find errors and misspellings ignore it or let me know so I can fix that and improve my English.)
