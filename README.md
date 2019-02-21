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

This build should take approximately 30-40 minutes to complete. After this, you can call `vagrant ssh` from within the same directory to access the VM.

In order to use the provided image, FILL IN HERE.

## Navigating the VM

The VM includes CompRDL, the library comp types used for type checking, and the six apps type checked in our benchmarks.

CompRDL can be found in the directory `~/rdl/`. CompRDL includes within it the comp types we wrote for Ruby's core libraries (corresponding to Table 1 in the paper). The Array types can be found in `~/rdl/lib/types/core/array.rb`, The Hash types can be found in `~/rdl/lib/types/core/hash.rb`, the Integer types can be found in `~/rdl/lib/types/core/integer.rb`, the Float types in `~/rdl/lib/types/core/float.rb`, and the String types in `~/rdl/lib/types/core/string.rb`.

The comp types for database query libraries can be found in a separate directory. The comp types for ActiveRecord can be found in `~/db-types/active-record/db_types.rb`, and the comp types for Sequel can be found in `~/db-types/sequel/db_types.rb`.

Finally, you can find the type checked versions of the six apps used in our evaluations in Section 5 in the following directories: 

* Discourse: `~/discourse-typecheck/`
* Journey: `~/journey/`
* Code.org: `~/code-dot-org/`
* Huginn:
* Wikipedia:
* Twitter: 

## Table 2

Table 2 measures the type checking results for the six applications. Please note that there are some
very minor differences on the VM from the original results. The differences arise from fixes to bugs
in the type checker which allowed us to reduce the number of type casts, and other type casts or methods that we
mistakenly did not count. Overall, the differences are minimal. We have included a new version of the table
below:

| Programs  | Meths | LoC  | Extra Annots. | Casts | Casts (RDL) | Time (s) Median +/- SIQR | Test Time No Chk (s) | Test Time w/ Chk (s) | Type Errs |
|-----------|-------|------|---------------|-------|-------------|--------------------------|----------------------|----------------------|-----------|
| Wikipedia | 16    | 47   | 3             | 1     | 11          | 0.05 +/- 0.01            | 5.94 +/ 0.20         | 6.19 +/- 0.20        | 0         |
| Twitter   | 3     | 29   | 11            | 3     | 8           | 0.02 +/- 0.00            | 0.05 +/- 0.00        | 0.06 +/ 0.00         | 0         |
| Discourse | 36    | 261  | 32            | 13    | 22          | 14.00 +/- 1.19           | 84.90 +/- 0.69       | 88.59 +/- 3.98       | 0         |
| Huginn    | 7     | 54   | 6             | 3     | 6           | 2.88 +/- 0.24            | 6.43 +/- 0.34        | 4.56 +/- 0.28        | 0         |
| Code.org  | 49    | 530  | 53            | 3     | 68          | 0.33 +/- 0.02            | 3.23 +/- 0.25        | 3.15 +/- 0.20        | 1         |
| Journey   | 21    | 419  | 78            | 14    | 59          | 2.08 +/- 0.05            | 5.67 +/- 0.69        | 6.12 +/- 1.02        | 2         |
| Total     | 132   | 1340 | 183           | 37    | 174         | 19.37 +/- 1.51           | 106.22 +/- 2.17      | 108.67 +/- 5.73      | 3         |


# Collecting Data

In order to collect data on the VM, first navigate into one of the application directories listed above,
e.g., `cd ~/discourse-typecheck/`. Within each app directory, there are four shell scripts that can be run:

* tc_comp.sh type checks the application using comp types (`sh tc_comp.sh` will run it). Running this will
collect the data corresponding to the _Meths_, _Casts_, _Time_, and _Type Errs_ columns of Table 2. You can find
the type annotations for the methods being type checked inside of the file typecheck.rb within each app directory.
This file also contains the extra method and variable annotations used (corresponding to the _Extra Annots._ column of Table 2).

* tc_noncomp.sh type checks the application using non comp types (`sh tc_noncomp.sh` will run it). The reported number of type casts corresponds to the _Casts (RDL)_ column of Table 2.

* run_tests_chks.sh runs a subset of the app's tests after dynamic checks corresponding to comp types have
been inserted (`sh run_tests_chks.sh`) will run it. The reported runtime corresponds to the _Test Time w/Chk._ column of Table 2.

* run_tests_no_chks.sh runs the same tests without dynamic checks (`sh run_tests_no_chks.sh` will run it). The reported runtime corresponds to the
_Test Time No Chk_ column of Table 2.

## Type and Termination Checking for Type-Level Code

As described in the paper, we also perform type and termination checking for all type-level code. More specifically, we type check type-level code to ensure that it returns a type, and we perform termination checking according
to the algorithm described in Section 4. To perform this type and termination checking, navigate into the `db-types/` directory, and run the `check_type_code.sh` shell script:

```
cd ~/db-types/
sh check_type_code.sh
```

This will perform type and termination checking, first for all type-level code, then for all helper methods dispatched from type-level code. It does this for all comp types of libraries listed in Table 1.

## Notational Differences

There are slight differences of notation between the types described in the paper and types in our implementation.
We note these differences below:

* In the paper, type-level computations are delimited by angle brackets, i.e., << ... >>.
In our implementation, type-level computations are delimited by double backticks, i.e.,  \`\`...\`\`.

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
