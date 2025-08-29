require('dotenv').config()
const express = require('express')
const expressLayout = require('express-ejs-layouts')
const connectDB = require('./config/mongoose')
const session = require('express-session')
const userRoutes = require('./routes/userRoutes')
const authRoute = require('./routes/authRoute')
const app = express()

const PORT = process.env.PORT || 9700

// View engine, layout setup
app.set('view engine', 'ejs')
app.set('layout', './layouts/indexLayout')

// Mongoose call
connectDB()

// EXPRESS-ESSION
app.use(session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    rolling: true,
    name: 'connect.sid',
    cookie:{
        httpOnly: true,
        secure: false,
        maxAge: 60 * 60 * 1000 // 1 hour
    }
}))

// Middleware
app.use(expressLayout)
app.use(express.json())
app.use(express.static('public'))
app.use(express.urlencoded({ extended: true }))


// Routes
app.use('/', userRoutes)
app.use('/api/auth', authRoute)
// For unexisting route
app.use((req, res, next) => {
    res.status(404).render('404', { layout: "layouts/404Layout",  title: 'Page not Found' })
})

process.on('uncaughtException', (err) => {
    console.error('UNCAUGHT EXCEPTION! SHUTTING DOWN...', err)
    process.exit(1)
})

app.listen(PORT, () => {
    console.log(`Server running at PORT: ${PORT}✅`)
})

process.on('unhandledRejection', (err) => {
    console.error('Unhandled Rejection', err)
    process.exit(1)
})
