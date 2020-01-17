#!/bin/bash

for file in ./*.puml; do
  java -jar ~/Software/plantuml.jar -txt $file
done
for file in ./*.atxt; do
  ./surround_with_stars.pl $file
  rm $file
done
