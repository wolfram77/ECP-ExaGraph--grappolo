#!/usr/bin/env bash
src="ECP-ExaGraph--grappolo"
out="$HOME/Logs/$src$1.log"
ulimit -s unlimited
printf "" > "$out"

# Download grappolo
if [[ "$DOWNLOAD" != "0" ]]; then
  rm -rf $src
  git clone https://github.com/wolfram77/$src
  cd $src
fi

# Convert graph to binary format, run grappolo, and clean up
runGrappolo() {
  stdbuf --output=L ./driverForGraphClustering -f 1 "$1" 2>&1 | tee -a "$out"
  stdbuf --output=L printf "\n\n"                             | tee -a "$out"
}

# Build and run grappolo
make -j32

# Run grappolo on all graphs
runAll() {
  # runGrappolo "$HOME/Data/web-Stanford.mtx"
  runGrappolo "$HOME/Data/indochina-2004.mtx"
  runGrappolo "$HOME/Data/uk-2002.mtx"
  runGrappolo "$HOME/Data/arabic-2005.mtx"
  runGrappolo "$HOME/Data/uk-2005.mtx"
  runGrappolo "$HOME/Data/webbase-2001.mtx"
  runGrappolo "$HOME/Data/it-2004.mtx"
  runGrappolo "$HOME/Data/sk-2005.mtx"
  runGrappolo "$HOME/Data/com-LiveJournal.mtx"
  runGrappolo "$HOME/Data/com-Orkut.mtx"
  runGrappolo "$HOME/Data/asia_osm.mtx"
  runGrappolo "$HOME/Data/europe_osm.mtx"
  runGrappolo "$HOME/Data/kmer_A2a.mtx"
  runGrappolo "$HOME/Data/kmer_V1r.mtx"
}

# Run grappolo 5 times
for i in {1..5}; do
  runAll
done

# Signal completion
curl -X POST "https://maker.ifttt.com/trigger/puzzlef/with/key/${IFTTT_KEY}?value1=$src$1"
