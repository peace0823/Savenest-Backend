const express = require('express')
const userController = require('../controllers/userControl')
const { signupValidation, loginValidation } = require('../validation/userValidation')

const router = express.Router()


router.post('/request-verification', userController.requestVerification)
router.post('/verify-email', userController.verifyEmail)
router.post('/resend-code', userController.resendCode)
router.post('/signup', signupValidation, userController.signup)
router.post('/login', loginValidation, userController.login)

// Forgot password
// router.post('/forgot-password',  userController.forgotPassword)

module.exports = router