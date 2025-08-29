function authMiddleware(req, res, next) {
    const token = req.cookies.token
    if(!token) {
        return res.redirect('/login') //No token go back to login
    }
  
    try{
        const decoded = jwt.verify(token, process.env.JWT_SECRET)
        req.user = decoded
        next()
        
    }catch(err){
        if(err.name === 'TokenExpiredError') {
            return res.status(401).json({ error: 'Token Expired' })

        }else if(err.name === 'JsonWebTokenError'){
            return res.status(401).json({ error: 'Invalid Token' })

        }else {
            return res.status(401).json({ error: 'Authentication failed' })
        }
    }
}

module.exports = authMiddleware