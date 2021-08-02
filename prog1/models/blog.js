const mongoose = require('mongoose');

// Blog Schema
const blogSchema = mongoose.Schema({
	title:{
		type: String,
		required: true
	},
	slug:{
		type: String,
		default: true
	},
    body:{
        type: String,
        required: true
    },
    author:{
        type: String,
        required: false
    },
    comment:{
        type: String,
        required: true
    },
    category:{
        type: String,
        required: true
    },
    approved:{
        type: Boolean,
        required: false,
        default: false
    },
    created_at:{
        type: Date,
        required: false,
        default: Date.now()
    }

});

const Blog = module.exports = mongoose.model('Blog', blogSchema);

module.exports.getBlogs = (callback, limit) => {
    Blog.find(callback).limit(limit);
}

module.exports.getBlogById = (_id, callback) => {
	Blog.findById(_id, callback);
}

module.exports.updateBlog = (match_id, blog_info, options, callback) => {
	Blog.findOneAndUpdate({_id:match_id}, blog_info, options, callback);
};


module.exports.addBlog = (blog_info, callback) =>{
	Blog.create(blog_info, callback);

}

module.exports.removeBlog = (match_id, callback) => {
	Blog.deleteOne({_id:match_id}, callback);

};