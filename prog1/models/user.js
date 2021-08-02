const mongoose = require('mongoose');

// User Schema
const userSchema = mongoose.Schema({
	name:{
		type: String,
		required: true
	},
	email:{
		type: String,
		default: true
	}
});

const User = module.exports = mongoose.model('User', userSchema);

// Get All Users - find method
module.exports.getUsers = (callback, limit) => {
        User.find(callback).limit(limit);
}

// Get User - findById method
module.exports.getUserById = (_id, callback) => {
	User.findById(_id, callback);
}

// Add User - create method
module.exports.addUser = (user_info, callback) =>{
	User.create(user_info, callback);

};

// Update User - findOneAndUpdate method
module.exports.updateUser = (match_id, user_info, options, callback) => {
	User.findOneAndUpdate({_id:match_id}, user_info, options, callback);
};

// Delete User - deleteOne method
module.exports.removeUser = (match_id, callback) => {
	User.deleteOne({_id:match_id}, callback);

};
