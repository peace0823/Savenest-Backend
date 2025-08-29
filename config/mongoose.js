const mongoose = require('mongoose')
const MONGO_URL = process.env.MONGO_URI

const connectDB = async() => {
    try {
        await mongoose.connect(MONGO_URL)
        console.log("Connection to the DataBase is Successful✅")
    }catch(err) {
        console.error('Connection Failed❌: ', err)
        process.exit(1)
    }
}

module.exports = connectDB