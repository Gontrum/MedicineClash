#!/bin/bash
cabal build
./dist-newstyle/build/x86_64-linux/ghc-8.10.2/MedicineClash-0.1.0.0/x/MakeDiagram/build/MakeDiagram/MakeDiagram -h 100 -o output.svg