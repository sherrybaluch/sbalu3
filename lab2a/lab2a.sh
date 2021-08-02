#!/bin/bash


export RIAK_HOST=http://riak:8098

function pause(){
    echo ""
    read -p "Press enter to continue..."
    echo ""
}

cd ~/riak-1.2.1/dev
dev1/bin/riak start
dev2/bin/riak start
dev3/bin/riak start
dev4/bin/riak start
dev2/bin/riak-admin cluster join dev1@127.0.0.1
dev3/bin/riak-admin cluster join dev1@127.0.0.1
dev4/bin/riak-admin cluster join dev1@127.0.0.1
dev1/bin/riak-admin cluster plan
dev2/bin/riak-admin cluster commit
dev1/bin/riak-admin member-status

echo Add Movies

curl -v -X PUT $RIAK_HOST/riak/movies/ABeautifulMind \
-H "Content-Type: application/json" \
-d '{"releasedate" : "2001", "runningtime" : "2:15", "genre" : "drama"}'

curl -v -X PUT $RIAK_HOST/riak/movies/RayaAndTheLastDragon \
-H "Content-Type: application/json" \
-d '{"releasedate" : "2021", "runningtime" : "1:47", "genre" : "adventure"}'

curl -v -X PUT $RIAK_HOST/riak/movies/Frozen \
-H "Content-Type: application/json" \
-d '{"releasedate" : "2013", "runningtime" : "1:42", "genre" : "adventure"}'

curl -v -X PUT $RIAK_HOST/riak/movies/Frozen2 \
-H "Content-Type: application/json" \
-d '{"releasedate" : "2019", "runningtime" : "1:43", "genre" : "adventure"}'

curl -v -X PUT $RIAK_HOST/riak/movies/LiloAndStitch \
-H "Content-Type: application/json" \
-d '{"releasedate" : "2002", "runningtime" : "1:32", "genre" : "adventure"}'

curl -X PUT $RIAK_HOST/riak/movies/Moana \
-H "Content-Type: application/json" \
-d '{"releasedate" : 2016", "runningtime" : "1:47", "genre" : "adventure"}'

#DELETE one of the movie records.

curl -i -X DELETE $RIAK_HOST/riak/movies/LiloAndStitch

#Create branches and link movies to branches.

curl -X PUT $RIAK_HOST/riak/branches/East \
-H "Content-Type: application/json" \
-H "Link:</riak/movies/ABeautifulMind>; riaktag=\"holds\", </riak/movies/Moana>; riaktag=\"holds\", </riak/movies/RayaAndTheLastDragon>; riaktag=\"holds\"" \
-d '{"branch" : "East"}'

curl -X PUT $RIAK_HOST/riak/branches/West \
-H "Content-Type: application/json" \
-H "Link:</riak/movies/Frozen>; riaktag=\"holds\", </riak/movies/Moana>; riaktag=\"holds\"" \
-d '{"branch" : "West"}'

curl -X PUT $RIAK_HOST/riak/branches/South \
-H "Content-Type: application/json" \
-H "Link:</riak/movies/Frozen2>; riaktag=\"holds\"" \
-d '{"branch" : "South"}'

#Link image of movie

curl -X PUT $RIAK_HOST/riak/images/frozen.png \
-H "Content-type: image/png" \
--data-binary @frozen.png

# Create a link from Frozen to image
curl -X PUT $RIAK_HOST/riak/movies/Frozen \
-H "Content-Type: application/json" \
-H "Link: </riak/images/frozen.png>; riaktag=\"photo\""

#List all buckets

curl $RIAK_HOST/riak?buckets=true

#List all movies found in each branch

echo "\n\n***All movies at the East Branch***"

curl $RIAK_HOST/riak/branches/East/_,_,_

echo "\n\n***All movies at the West branch***"

curl $RIAK_HOST/riak/branches/West/_,_,_

echo "\n\n***All movies at the South branch***"

curl $RIAK_HOST/riak/branches/South/_,_,_

#List movie with the picture and its branch

pause

curl $RIAK_HOST/riak/branches/West/movies,_,_/_,photo,_

exit 0
