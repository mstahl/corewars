# Corewars

This is a Corewars simulation (similar to pMARS) written in Ruby. It's set up 
specifically to aid in writing Corewars evolvers using Ruby or environments
that can interface with it. It will almost certainly include a web service 
very soon. 

## Configuring

The simulation can be configured using the following options:

 * `:core_size` -- Size of the core (in words). _Default:_ 8,192
 * `:cycles_before_tie` -- The number of cycles the simulation will perform 
   before declaring a tie if more than one warrior remains. _Default:_ 100,000
 * `:fill` -- Instruction to fill the core with initially. _Default:_ `DAT #0,#0`
 * `:size_limit` -- Maximum size in words for any warriors. _Default:_ 256
 * `:thread_limit` -- Maximum number of threads or forked processes a warrior can spawn. _Default:_ 4
 * `:min_separation` -- Minimum distance between warriors, in words. _Default:_ 512
 * `:read_limit` -- Maximum distance from the program counter where a warrior can read. _Default:_ -1 (infinity)
 * `:separation` -- Default separation between warriors. Can be `:random`. _Default:_ `:random`
 * `:write_limit` -- Maximum distance from the program counter where a warrior can write. _Default:_ -1 (infinity)

## Compiling warriors

Warriors can be added to the simulation with the Corewars.register method. This
will parse and compile them, and throw an exception if there is a parse error.

## Contributing to corewars

 * Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
 * Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
 * Fork the project
 * Start a feature/bugfix branch
 * Commit and push until you are happy with your contribution
 * Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
 * Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 max thom stahl. See LICENSE.txt for
further details.

