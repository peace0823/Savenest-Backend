const { validationResult } = require('express-validator')
const { AdminGetUserCommand, SignUpCommand, ConfirmSignUpCommand, AdminUpdateUserAttributesCommand, ListUsersCommand, AdminSetUserPasswordCommand, ResendConfirmationCodeCommand, AdminInitiateAuthCommand } = require('@aws-sdk/client-cognito-identity-provider')
const jwt = require('jsonwebtoken')
const client = require('../config/cognito')

//========= EMAIL CONFIRMATION / SEND VERIFICATION CODE ======================
exports.requestVerification = async(req, res) => {
    try{
        const { email } = req.body
        if(!email) {
            return res.status(400).json({ message: "Email Required" })
        }

        req.session.pendingEmail = email
        req.session.cookie.maxAge = 10 * 60 * 1000;

        try{
            const existingUser = new AdminGetUserCommand({
                UserPoolId: process.env.COGNITO_USER_POOL_ID,
                username: email,
            })
    
            await client.send(existingUser)
            
            return res.status(400).json({ message: 'Email already Registered' })
            
        } catch(err) {
            
            if(err.name !== 'UserNotFoundException') {
                console.error('Error checking user: ', err)
                return res.status(500).json({ message: 'Error checking user in Cognito' })
            }
        }

        // Trigger sign up to send verification code
      const signupcommand = new SignUpCommand({
           ClientId: process.env.COGNITO_CLIENT_ID,
           Username: email,
           Password: 'TemporaryPassw0rd!', // Since we only want verification step
           UserAttributes: [
               {Name: "email", value: email}
           ]
      })
   
      await client.send(signupcommand)
      res.status(200).json({ message: "Verification Code sent, Please check your email" })

    }catch(error){
        console.error('Request Verification error: ', error);
        res.status(500).json({ message: 'Server error' })
    }
}

// ==========VERIFY USER CODE FROM EMAIL ==============

exports.verifyEmail = async(req, res) => {
    try{
        const { code } = req.body

        // Check if session holds pending email
        if(!req.session.pendingEmail) {
            return res.status(400).json({ message: 'Session Expired, please, request verification again' })
        }
        const email = req.session.pendingEmail


        // Rate limiting setup
        const MAX_ATTEMPTS = 5;
        const LOCK_TIME = 10 * 60 * 1000; // 10 minutes in ms

        if (!req.session.failedAttempts) req.session.failedAttempts = 0;
        if (!req.session.lockUntil) req.session.lockUntil = null;

        // If locked, block request
        if (req.session.lockUntil && Date.now() < req.session.lockUntil) {
            const waitSeconds = Math.ceil((req.session.lockUntil - Date.now()) / 1000);
            return res.status(429).json({
                message: `Too many invalid attempts. Please wait ${waitSeconds} seconds before trying again.`
            });
        }

        // Reset lock if expired
        if (req.session.lockUntil && Date.now() >= req.session.lockUntil) {
            req.session.failedAttempts = 0;
            req.session.lockUntil = null;
        }

        // Handle empty code
        if (!code || code.trim() === "") {
            req.session.failedAttempts++;
            if (req.session.failedAttempts >= MAX_ATTEMPTS) {
                req.session.lockUntil = Date.now() + LOCK_TIME;
                return res.status(429).json({
                    message: "Too many invalid attempts. Locked for 10 minutes."
                });
            }
            return res.status(400).json({ message: "Verification code is required" });
        }

        // Confirm with cognito
        const confirmCommand = new ConfirmSignUpCommand({
            ClientId: process.env.COGNITO_CLIENT_ID,
            Username: email,
            ConfirmationCode: code
        })

        await client.send(confirmCommand)
        
        req.session.pendingEmail = email

        res.status(200).json({ message: 'Email Successfully verified' })

    }catch(error){
        console.error('Confirm verification error: ', error);

        req.session.failedAttempts++;
        if (req.session.failedAttempts >= 5) {
            req.session.lockUntil = Date.now() + (10 * 60 * 1000);
            return res.status(429).json({
                message: "Too many invalid attempts. Locked for 10 minutes."
            });
        }
        
        if(error.name === 'CodeMismatchException'){
            return res.status(400).json({ message: 'Invalid Verification code' })
        }

        if(error.name === 'ExpiredCodeException') {
            return res.status(400).json({ message: 'verification code expired' })
        }

        res.status(500).json({ message: 'server error' })
    }
}

// =========RESEND VERIFICATION CODE =========
exports.resendCode = async(req, res) => {
    try{
        // Must have pending email from session
        if(!req.session.pendingEmail) {
            return res.status(400).json({ message: "Session expired, please restart verification again" })
        }

        const email = req.session.pendingEmail

        // Initializing session variables
        if (!req.session.failedAttempts) req.session.failedAttempts = 0;
        if (!req.session.lockUntil) req.session.lockUntil = null;

        const MAX_ATTEMPTS = 5;          // Maximum resend attempts
        const LOCK_TIME = 10 * 60 * 1000; // 10 minutes lock
        const now = Date.now();

        // Lockout check
        if (req.session.lockUntil && now < req.session.lockUntil) {
            const waitSeconds = Math.ceil((req.session.lockUntil - now) / 1000);
            return res.status(429).json({
                message: `Too many resend attempts. Please wait ${waitSeconds} seconds.`
            });
        }

        // Reset lock if expired
        if (req.session.lockUntil && now >= req.session.lockUntil) {
            req.session.failedAttempts = 0;
            req.session.lockUntil = null;
        }

        // ======== Throttle individual resends =======
        if (req.session.lastResend && now - req.session.lastResend < 60 * 1000) {
            return res.status(429).json({
                message: "Please wait at least 1 minute before requesting another code."
            });
        }

        // ========== Call Cognito to resend code ========
        const resendCommand = new ResendConfirmationCodeCommand({
            ClientId: process.env.COGNITO_CLIENT_ID,
            Username: email
        });

        await client.send(resendCommand);

        // =========== Update session counters ==========
        req.session.lastResend = now;
        req.session.failedAttempts++;

        if (req.session.failedAttempts >= MAX_ATTEMPTS) {
            req.session.lockUntil = now + LOCK_TIME;
            return res.status(429).json({
                message: `Too many resend attempts. Locked for ${LOCK_TIME / 60000} minutes.`
            });
        }

        res.status(200).json({
            message: "Verification code resent successfully",
            attemptsLeft: MAX_ATTEMPTS - req.session.failedAttempts
        })

    }catch(err){
        console.error("Resend code error:", err);

        if (err.name === "UserNotFoundException") {
            return res.status(400).json({ message: "User not found. Please sign up first." })
        }
        if (err.name === "LimitExceededException") {
            return res.status(429).json({ message: "Too many requests. Try again later." })
        }

        res.status(500).json({ message: "Server error" })
    }
}


// ======== SIGN UP =========
exports.signup = async (req, res) => { 
    try {
        const errors = validationResult(req)
        if(!errors.isEmpty()) {
            return res.status(400).json({ message: 'Validation Failed! Please check your inputs',
                errors: errors.array()
            })
        }

        const email = req.session.pendingEmail
        if(!email) {
            return res.status(400).json({ message: 'Session expired please start the verification process again' })
        }
        
        let { firstname, lastname, password, gender, phonenumber, referralCode } = req.body
        if(!firstname || !lastname || !password || !gender || !phonenumber) {
            return res.status(400).json({ message: 'All fields must be provided!' })
        }
        
        // Normalize inputs
        firstname = firstname.charAt(0).toUpperCase() + firstname.slice(1).toLowerCase();
        lastname = lastname.charAt(0).toUpperCase() + lastname.slice(1).toLowerCase();
        gender = gender.charAt(0).toUpperCase() + gender.slice(1).toLowerCase();
        

        // Check if phone Number is unique in cognito
        const listUsersCommand = new ListUsersCommand({
            UserPoolId: process.env.COGNITO_USER_POOL_ID,
            Filter: `phone_number = "${phonenumber}"`
        });

        const response = await client.send(listUsersCommand);
        if (response.Users && response.Users.length > 0) {
            return res.status(400).json({ message: "Phone number is already registered" });
        }

        // Create User in cognito
        const updateAttributecommand = new AdminUpdateUserAttributesCommand({
            UserPoolId: process.env.COGNITO_USER_POOL_ID,
            Username: email,
            UserAttributes: [
                { Name: 'email', value: email },
                { Name: 'given_name', value: firstname },
                { Name: 'family_name', value: lastname },
                { Name: 'gender', value: gender },
                { Name: 'phone_number', value: phonenumber },
                { Name: 'custom_referralCode', value: referralCode || '' }
            ]
        })

        await client.send(updateAttributecommand)

        // Set Permanent Password for immediate Login
        const setPasswordCommand = new AdminSetUserPasswordCommand({
            UserPoolId: process.env.COGNITO_USER_POOL_ID,
            Username: email,
            Password: password,
            Permanent: true
        })

        await client.send(setPasswordCommand)

        // Clear session
        req.session.pendingEmail = null
        
        // Generate JWT for immediate Login
        const token = jwt.sign(
            { email },
            process.env.JWT_SECRET,
            {expiresIn: '1h'}
        )

        res.cookie('token', token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === "production",
            sameSite: 'strict',
            maxAge: 60 * 60 * 1000
        })

        res.status(200).json({ message: 'Signup/Login Successful',
            user: {
                email,
                firstname: firstname,
                lastname: lastname,
                gender: gender,
                phonenumber,
                referralCode: referralCode || ""
            }
        })
    }catch(err){
        console.error('Signup error:', err)
        
        if(err.name === 'UsernameExistsException') {
            return res.status(500).json({ message: 'Email Already Exist' })
        }

        return res.status(500).json({ message: 'Server error' })
    }
}


// ======== USER LOGIN ===============
exports.login = async (req, res) => { 
    try {
        const errors = validationResult(req)
        if(!errors.isEmpty()) {
            return res.status(400).json({ message: 'Validation Failed! Please check your inputs',
                errors: errors.array()
            })
        }

        const { email, password } = req.body

        if(!email || !password) {
            return res.status(400).json({ message: "Email and password required!" })
        }

        // ======== Prepare Cognito Auth =========
        const authCommand = new AdminInitiateAuthCommand({
            UserPoolId: process.env.COGNITO_USER_POOL_ID,
            ClientId: process.env.COGNITO_CLIENT_ID,
            AuthFlow: "ADMIN_NO_SRP_AUTH", // direct email/password login
            AuthParameters: {
                USERNAME: email,
                PASSWORD: password
            }
        })

        await client.send(authCommand)

        // ====== Successful login =====
        const token = jwt.sign(
            { email },
            process.env.JWT_SECRET,
            { expiresIn: '1h' }
        )

        // Save JWT in cookie for session-based auth
        res.cookie('token', token, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'strict',
            maxAge: 60 * 60 * 1000 // 1 hour
        })

        res.status(200).json({
            message: "Login successful",
            email
        })
    }catch(err) {
        console.error("Login error:", err);

        // Cognito-specific errors
        if (err.name === "UserNotFoundException") {
            return res.status(400).json({ message: "User does not exist." });
        }
        if (err.name === "NotAuthorizedException") {
            return res.status(400).json({ message: "Incorrect email or password." });
        }
        if (err.name === "UserNotConfirmedException") {
            return res.status(400).json({ message: "Email not verified. Please verify first." });
        }

        res.status(500).json({ message: "Server error" })
    }
}