routes = require("./routes")
config = require("./config")

express = require("express")
path = require("path")
app = express()
server = require("http").Server(app)
io = require("socket.io").listen(server)

app.configure ->
  app.set "port", process.env.PORT or 3000
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.set "title", config.title
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use require("stylus").middleware(__dirname + "/public")
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()

app.get "/", routes.slides

auth = express.basicAuth config.username, config.password
app.get "/rc", auth, routes.rc

server.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")

io.on "connection", (socket) ->
  socket.on "next", (data) ->
    socket.broadcast.emit("next", data)
  socket.on "prev", (data) ->
    socket.broadcast.emit("prev", data)
  socket.on "slide", (data) ->
    socket.broadcast.emit("slide", data)
  socket.on "index", (data) ->
    socket.broadcast.emit("index", data)
