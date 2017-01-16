Purpose
=======

Script everyday tasks like:
- Get Docker binaries
- Get Golang binaries
- Build Docker from source
- Build docker2cvmfs helper tool
- Check /var/lib/docker integrity
- Build graphdriver plugin

How to use
==========
To run a script you should:
1. Start the vagrant machine,
2. Enter the script directory
3. Run `main.sh` script

```
cd machine_tmp
vagrant up
vagrant ssh
cd /vagrant_data/roadmap/[some test case]
bash main.sh
```

Organization of files
=====================

"Business logic" is implemented in `exported.sh` which should be sourced. All
functions inside a `exported.sh` file should start with `f00_` prefix where 00
is number of current test case.
