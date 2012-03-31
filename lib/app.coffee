# Dependencies

## SendGrid Keys
user = process.env.SENDGRID_USER || "your_sendgrid_username"
key = process.env.SENDGRID_KEY || "your_sendgrid_password"
from = "MarkdownDemo@sendgrid.com"

## External
express = require 'express'
marked = require 'marked'
{SendGrid} = require('sendgrid-nodejs')

## Native
path = require 'path'
util = require 'util'

# Initialization
app = module.exports = express.createServer()
io = require('socket.io').listen(app)
mailer = new SendGrid(user, key)

# Paths
app.paths = {
  public: path.join(__dirname, '..', 'public'),
  root: path.join(__dirname, '..'),
  views: path.join(__dirname, '..', 'views')
}

# Package Info
package = require path.join(app.paths.root, 'package')
app.name = package.name
app.version = package.version

# Env and Port
app.env = process.env.NODE_ENV || 'development'
app.port = parseInt(process.env.PORT) || 3000

# Config
app.configure ->
  app.use express.static(app.paths.public)

# Markdown options
marked.setOptions({
  gfm: true,
  pedantic: false,
  sanitize: false
})

# Socket Setup
io.sockets.on 'connection', (socket) ->

  socket.on 'preview', (markdownText) ->
    if markdownText.length > 0
      markdownHTML = marked(markdownText)
      socket.emit 'render', markdownHTML
    else
      socket.emit 'render', '<em>You have not entered a message yet!</em>'

  socket.on 'send', (to, subject, body) ->
    if to.length > 0 && subject.length > 0 && body.length > 0
      mailer.send {
        to: to,
        from: from,
        subject: subject,
        html: marked(body)
      }, (success, jsonErrors) ->
        if success
          socket.emit('success', 'Your email has been successfully sent!')
        else
          util.debug jsonErrors
          socket.emit('error', 'Something went wrong while sending your email! Please check your credentials.')
    else
      socket.emit('error', "The 'To', 'Subject', and 'Message' fields are all required!")

# Listening Log
app.on 'listening', ->
  util.log "Lanched #{app.name} v#{app.version} in #{app.env.toUpperCase()} mode"
  util.log "Listening on 0.0.0.0:#{app.port}"
