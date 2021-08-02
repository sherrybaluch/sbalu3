#!/usr/bin/env bash

#Add your curl statements here

HOST="http://couchdb:5984"

curl -X PUT $HOST/restaurants


curl -i -X POST "$HOST/restaurants/" -H "Content-Type: application/json" -d '{"_id":"mcdonalds", "name":"McDonalds", "food_type":["American"], "phonenumber":"8477419768", "website":"www.mcdonalds.com"}'

curl -i -X POST "$HOST/restaurants/" -H "Content-Type: application/json" -d '{"_id":"chinese_wok", "name":"Chinese Wok", "food_type":["Chinese"], "phonenumber":"8478883373", "website":"www.chinesewokelgin.com"}'

curl -i -X POST "$HOST/restaurants/" -H "Content-Type: application/json" -d '{"_id":"taco_bell", "name":"Taco Bell", "food_type":["Mexican"], "phonenumber":"8476088226", "website":"www.tacobell.com"}'


#DO NOT REMOVE
curl -Ssf -X PUT http://couchdb:5984/restaurants/_design/docs -H "Content-Type: application/json" -d '{"views": {"all": {"map": "function(doc) {emit(doc._id, {rev:doc._rev, name:doc.name, food_type:doc.food_type, phonenumber:doc.phonenumber, website:doc.website})}"}}}'
curl -Ssf -X GET http://couchdb:5984/restaurants/_design/docs/_view/all