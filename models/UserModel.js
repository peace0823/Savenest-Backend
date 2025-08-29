// const mongoose = require('mongoose')

// // Defines the structure of a document 
// // Creating a new instance of a schema
// const userData = new mongoose.Schema({
//     email: {
//         type: String,
//         required: true,
//         trim: true,
//         lowercase: true,
//         unique: true,
//         match: [/^\S+@\S+\.\S+$/, "Please enter a valid email"]
//     },
    
//     status: { type: String, enum: ['pending', 'active'], default: 'pending' },

//     // Verification Request
//     isVerified: { type: Boolean, default: false },
//     verificationCode: String,
//     verificationExpires: Date,

//     firstname: {
//         type: String,
//         trim: true,
//         required: true,
//         minlength: [3, 'Name should be atleast 3 characters'],
//         maxlength: [15, 'Name should not exceed 15 chars'],
//         match: [/^[A-Za-z]+$/, "'Firstname' field must only contain one or more uppercase or lowercase letter only"]
//     },

//     lastname: {
//         type: String,
//         trim: true,
//         required: true,
//         minlength: [3, 'lastname should be atleast 3 characters'],
//         maxlength: [15, 'lastname should not exceed 15 chars'],
//         match: [/^[A-Za-z]+$/, "'Lastname' field must only contain one or more uppercase or lowercase letter only"]
//     },

//     gender: {
//         type: String,
//         enum: ["Male", "Female", "Other"],
//         required: true
//     },

//     phoneNumber: {
//         type: String,
//         required: true,
//         unique: true,
//         match: [/^\d{10,15}$/, "Please enter a valid phone number"]
//     },

//     password: {
//         type: String,
//         trim: true,
//         minlength: [6, 'Password must not be below 6 characters'],
//         required: true
//     },

//     referralCode: {
        // type: String,
//         default: null
//     },

//     pin: {
//         type: String,
//         required: true,
//     },

//     // Password Reset
//     resetPasswordToken: String,
//     resetPasswordExpires: Date
// },
//     { timestamps: true }
// )

// module.exports = mongoose.model('User', userData)