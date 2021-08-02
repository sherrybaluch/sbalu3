use phonenumbers

populatePhonesa = function(area,start,stop) {
for(var i=start; i < stop; i++) {
var country = 1;
var num = (country * 1e10) + (area * 1e7) + i;
 db.phones.insert({
_id: num, components: {
country: country, area: area,
prefix: (i * 1e-4) << 0, number: i
},
display: "+" + country + " " + area + "-" + i
});
}
}

populatePhonesa(800, 5550000, 5650000) 

populatePhonesb = function(area,start,stop) {
for(var i=start; i < stop; i++) {
var country = 1 + ((Math.random() * 8) << 0);
var num = (country * 1e10) + (area * 1e7) + i;
db.phones.insert({
_id: num,
components: {
country: country,
area: area,
prefix: (i * 1e-4) << 0,
number: i
},
display: "+" + country + " " + area + "-" + i
});
}
}

populatePhonesb(855, 5550000, 5650000)

distinctDigits = function(phone){
var number = phone.components.number + '',
seen = [],
result = [],
i = number.length;
while(i--) {
seen[+number[i]] = 1;}
for (i=0; i<10; i++) {
if (seen[i]) {
result[result.length] = i;
}}
return result;
}


db.system.js.save({_id: 'distinctDigits', value: distinctDigits}) 


map = function() {
var digits = distinctDigits(this);
emit({digits : digits, country : this.components.country}, {count : 1});
}


reduce = function(key, values) {
var total = 0;
for(var i=0; i<values.length; i++) {
total += values[i].count;
}
return { count : total };
}


finalizeIt = function(key, reducedVal) {
	return {total: reducedVal.count};
}

results = db.runCommand({
mapReduce: 'phones',
map: map,
reduce: reduce,
finalize: finalizeIt,
out: 'phones.report'
})

db.phones.report.find({'_id.country' : 8})