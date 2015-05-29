mkdir locations
while read line; do
  touch locations/${line}.txt
done < locations.txt
