use blogger

db.users.insert({
"_id":ObjectId("5bb26043708926e438db6cad"),
name:"Bruno Skvorc",
email:"bruno@email.com"
})

db.users.insert({
	"_id":ObjectId("5bb26043708926e438db6cae"),
	name:"Jack Franklin",
	email:"jack@email.com"
})

db.users.insert({
	"_id":ObjectId("5bb26043708926e438db6caf"),
	name:"Daniel Diaz",
	email:"daniel@email.com"
})

print("Displaying three users")
db.users.find().pretty()

print("Finding match for _id=5bb26043708926e438db6cad")
db.users.find({"_id":ObjectId("5bb26043708926e438db6cad")}).pretty()

db.blogs.insert({
title:"Symfony Flex: Paving the Path to a Faster, Better Symfony",
body:"Still Under Development Symfony Flex can be considered a Composer wrapper, in that it provides your Symfony project with additional options during installation and configuration.",
slug:"Symfony Flex is a modern replacement for the Symfony Installer.",
author:"Bruno Skvorc",
comments:[{
	user_id:"5bb26043708926e438db6cae",
	comment:"Best article I've ever read. Highly recommend. Great wordism.",
	approved:true,
	created_at:ISODate("2010-06-24")}],
category:[{name:"PHP"}]
})

db.blogs.insert({
	title:"Working with the File System in Deno",
	body:"In this article, we’ll build on our introduction to Deno by creating a command-line tool that can search for text within files and folders.",
	slug:"Create a command-line tool that can search for text within files and folders",
	author:"Jack Franklin",
	comments:[{
		user_id:"5bb26043708926e438db6caf",
		comment:"Great article!",
		approved:true,
		created_at:ISODate("2021-06-24")}],
	category:[{name:"Javascript"}]
})

db.blogs.insert({
	title:"Build a Photo-sharing App with Django",
	body:"Django is the most-used Python framework for web development. Its built-in features and robust structure make it an excellent option when building web applications.",
	slug:"Django is the most-used Python framework for web development.",
	author:"Danial Diaz",
	comments:[{
		user_id:"5bb26043708926e438db6cad",
		comment:"Great article!",
		approved:true,
		created_at:ISODate("2021-06-24")}],
	category:[{name:"Django"}]
})

print("Finding comments by User 5bb26043708926e438db6caf")
var search = {comments:{$elemMatch:{user_id:"5bb26043708926e438db6caf"}}}

db.blogs.find(search,{_id:0,title:1,slug:1}).pretty()

print("Finding blogs with the word Framework")
db.blogs.find({body:/Framework/i},{_id:0,title:1,slug:1}).pretty()