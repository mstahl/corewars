# Corewars

This is a Corewars simulation (similar to pMARS) written in Ruby. It's set up 
specifically to aid in writing Corewars evolvers using Ruby or environments
that can interface with it. It will almost certainly include a web service 
very soon. 

This is in the extremely early stages of development, so please do not use this
yet.

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

## The Redcode Language

This MARS emulates the ICWS '94 Redcode standard **only**. Warrior programs
written in the old '88 or '86 standards will not work. Below are the opcodes
you can use in ICWS'94 Redcode:

#### DAT
No additional processing takes place.  This effectively removes the
current task from the current warrior's task queue.

#### MOV
Move replaces the B-target with the A-value and queues the next
instruction (PC + 1).

#### ADD
ADD replaces the B-target with the sum of the A-value and the B-value
(A-value + B-value) and queues the next instruction (PC + 1).  ADD.I
functions as ADD.F would.

#### SUB
SUB replaces the B-target with the difference of the B-value and the
A-value (B-value - A-value) and queues the next instruction (PC + 1).
SUB.I functions as SUB.F would.

#### MUL
MUL replaces the B-target with the product of the A-value and the
B-value (A-value * B-value) and queues the next instruction (PC + 1).
MUL.I functions as MUL.F would.

#### DIV
DIV replaces the B-target with the integral result of dividing the
B-value by the A-value (B-value / A-value) and queues the next
instruction (PC + 1).  DIV.I functions as DIV.F would. If the
A-value is zero, the B-value is unchanged and the current task is
removed from the warrior's task queue.

#### MOD
MOD replaces the B-target with the integral remainder of dividing the
B-value by the A-value (B-value % A-value) and queues the next
instruction (PC + 1).  MOD.I functions as MOD.F would. If the
A-value is zero, the B-value is unchanged and the current task is
removed from the warrior's task queue.

#### JMP
JMP queues the sum of the program counter and the A-pointer.

#### JMZ
JMZ tests the B-value to determine if it is zero.  If the B-value is
zero, the sum of the program counter and the A-pointer is queued.
Otherwise, the next instruction is queued (PC + 1).  JMZ.I functions
as JMZ.F would, i.e. it jumps if both the A-number and the B-number
of the B-instruction are zero.

#### JMN
JMN tests the B-value to determine if it is zero.  If the B-value is
not zero, the sum of the program counter and the A-pointer is queued.
Otherwise, the next instruction is queued (PC + 1).  JMN.I functions
as JMN.F would, i.e. it jumps if both the A-number and the B-number
of the B-instruction are non-zero. This is not the negation of the
condition for JMZ.F.

#### DJN
DJN decrements the B-value and the B-target, then tests the B-value
to determine if it is zero.  If the decremented B-value is not zero,
the sum of the program counter and the A-pointer is queued.
Otherwise, the next instruction is queued (PC + 1).  DJN.I functions
as DJN.F would, i.e. it decrements both both A/B-numbers of the B-value
and the B-target, and jumps if both A/B-numbers of the B-value are
non-zero.

#### CMP
CMP compares the A-value to the B-value.  If the result of the
comparison is equal, the instruction after the next instruction
(PC + 2) is queued (skipping the next instruction).  Otherwise, the
the next instruction is queued (PC + 1).

#### SLT
SLT compares the A-value to the B-value.  If the A-value is less than
the B-value, the instruction after the next instruction (PC + 2) is
queued (skipping the next instruction).  Otherwise, the next
instruction is queued (PC + 1).  SLT.I functions as SLT.F would.

#### SPL
SPL queues the next instruction (PC + 1) and then queues the sum of
the program counter and A-pointer. If the queue is full, only the
next instruction is queued.

## Contributing to corewars

 * Check out the latest master to make sure the feature hasn't been implemented 
   or the bug hasn't been fixed yet
 * Check out the issue tracker to make sure someone already hasn't requested 
   it and/or contributed it
 * Fork the project
 * Start a feature/bugfix branch
 * Commit and push until you are happy with your contribution
 * Make sure to add tests for it. This is important so I don't break it in a 
   future version unintentionally.
 * Please try not to mess with the Rakefile, version, or history. If you want
   to have your own version, or is otherwise necessary, that is fine, but
   please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 max thom stahl. See LICENSE.txt for
further details.

