const { body } = require('express-validator')

exports.signupValidation = [
    body('firstname')
        .notEmpty().withMessage("'Firstname' field should not be empty")
        .trim()
        .isLength({ min: 3, max: 15 }).withMessage("'Firstname' field should be between 3 - 15 characters")
        .matches(/^[A-Za-z]+$/).withMessage("'Firstname' field must only contain one or more uppercase or lowercase letter"),

    body('lastname')
        .notEmpty().withMessage("'Lastname' must not be empty")
        .trim()
        .isLength({ min: 3, max: 15 }).withMessage("'Lastname' field should be between 3 - 15 characters")
        .matches(/^[A-Za-z]+$/).withMessage("'Lastname' field must only contain one or more uppercase or lowercase letter"),

    body('gender')
        .notEmpty().withMessage('Gender is required')
        .trim()
        .isIn(["male", "female", "other"]).withMessage("Invalid gender"),
        

    body('phoneNumber')
        .notEmpty().withMessage('Phone number is required ')
        .trim()
        .matches(/^\d{10,15}$/).withMessage("Enter a valid phone number"),

    body('password')
        .notEmpty().withMessage('Password field should not be left empty')
        .trim()
        .isLength({ min: 6, max: 15}).withMessage('Password should not be below 6 characters'),

    body('confirmPassword')
        .custom((value, {req}) => {
            if(value !== req.body.password) {
                throw new Error("Passwords does not match")
            }
            return true
        }),

    body('referralCode')
        .optional()
        .isString().withMessage('Referral code must be a string')
]

exports.loginValidation = [
    body('username')
        .notEmpty().withMessage('Email is required')
        .trim()
        .isEmail().withMessage('Must be a valid email address'),

    body('password')
        .notEmpty().withMessage('Password field is required')
        .trim()
        .isLength({ min: 5, max: 15}).withMessage('Password should be between 3 - 15 characters')
]