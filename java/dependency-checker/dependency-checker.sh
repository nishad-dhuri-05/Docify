#!/bin/bash
REPO=$1
path_to_directory="./$REPO"
cp LibraryAnalyzer.java ../repo
cd ../repo
javac LibraryAnalyzer.java

if [ $? -eq 0 ]; then
    echo "Compilation successful. Running LibraryAnalyzer..."
    
    # Run Java program with command line arguments
    # java LibraryAnalyzer $path_to_directory
    java LibraryAnalyzer $path_to_directory
    echo "requirement successfully generated, copying them to inside the repo"
    mkdir -p "./$REPO/docify-assets/"
    cp requirements.txt "./$REPO/docify-assets/"
else
    echo "Compilation failed. Exiting."
fi

