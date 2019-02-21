# CompRDL Artifact VM

## Requirements

* [VirtualBox](https://www.virtualbox.org/).
* [Vagrant](https://www.vagrantup.com/).

## Setup

It is straightforward to use Vagrant along with the files in this repository to produce a VM image that contains CompRDL and all the benchmarks used in our evaluations. Equivalently, you can use the [provided VM image](FILL IN HERE).

To use Vagrant to produce a VM, simply clone and navigate into this repo, and call `vagrant up`:
```
git clone https://github.com/ngsankha/pldi-19-artifact.git
cd pldi-19-artifact
vagrant up              # Build the VM
```

After this, you can call `vagrant ssh` from within the same directory to access the VM.

In order to use the provided image, FILL IN HERE.

## Navigating the VM

The VM includes CompRDL, the library comp types used for type checking, and the six apps type checked in our benchmarks.

CompRDL can be found in the directory FILL IN HERE. CompRDL includes within it the comp types we wrote for Ruby's core libraries (corresponding to Table 1 in the paper). The Array types can be found in /lib/types/core/array.rb, The Hash types can be found in /lib/types/core/hash.rb, the Integer types can be found in /lib/types/core/integer.rb, the Float types in /lib/types/core/float.rb, and the String types in /lib/types/core/string.rb.

The comp types for database query libraries can be found in a separate directory. The comp types for ActiveRecord can be found in FILL IN HERE, and the comp types for Sequel can be found in.

Finally, you can find the type checked versions of the six apps used in our evaluations in Section 5 in the following directories: 

* Discourse:
* Journey:
* Code.org:
* Huginn:
* Wikipedia:
* Twitter: 

## Table 2

Table 2 measures the type checking results for the six applications. Please note that there are some
very minor differences on the VM from the original results. The differences arise from fixes to bugs
in the type checker which allowed us to reduce the number of type casts, and other type casts that we
mistakenly did not count. Overall, the differences are minimal. We have included a new version of the table
below:

FILL IN HERE


# Collecting Data

In order to collect data on the VM, first navigate into one of the application directories listed above,
e.g., `cd FILL IN HERE`. Within each app directory, there are four shell scripts that can be run:

* tc_comp.sh type checks the application using comp types (`sh tc_comp.sh` will run it). Running this will
collect the data corresponding to the _Meths_, _Casts_, and _Time_ columns of Table 2. You can find
the type annotations for the methods being type checked inside of the file typecheck.rb within each app directory.
This file also contains the extra method and variable annotations used (corresponding to the _Extra Annots._ column of Table 2).

* tc_noncomp.sh type checks the application using non comp types (`sh tc_noncomp.sh` will run it). The reported number of type casts corresponds to the _Casts (RDL)_ column of Table 2.

* run_tests_chks.sh runs a subset of the app's tests after dynamic checks corresponding to comp types have
been inserted (`sh run_tests_chks.sh`) will run it. The reported runtime corresponds to the _Test Time w/Chk._ column of Table 2.

* run_tests_no_chks.sh runs the same tests without dynamic checks (`sh run_tests_no_chks.sh` will run it). The reported runtime corresponds to the
_Test Time No Chk_ column of Table 2.

## Type and Termination Checking for Type-Level Code



## Notation

There are slight differences of notation between the types described in the paper and types in our implementation.
We note these differences below:

* In the paper, type-level computations are delimited by angle brackets, i.e., &laquo ... &raquo.
In our implementation, type-levle computations are delimited by double backticks, i.e., ``...``.

* In the paper, type-level computations refer to the receiver type of a method call using the name `tself`.
In the implementation, we use the name `trec`.

* In the paper, comp types bind a name to an input type as follows: `t<:Integer`, where `t` is the name given to
an input of type `Integer`. In addition to this binding notation, our implementation
allows us to refer to *all* input types using a special variable `targs`,
which is bound to an array containing the types of all inputs.

* In the paper, the purity and termination effects of a method are included in its type annotation
as two separate labels, e.g., `type ..., pure: :-, terminates: :+`. In the implementation, these
are condensed into a single effect array, the first element of which indicates purity and the second of
which indicates termination, e.g., `type ..., effect: [:-, :+]`. If a type annotation does not include
any effects, the method is assumed to be impure and potentially nonterminating, i.e., `effect: [:-, :-]`. 
