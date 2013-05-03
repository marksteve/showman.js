config = require("../config")

fs = require("fs")
path = require("path")
async = require("async")
rs = require("robotskirt")

renderer = new rs.HtmlRenderer()
parser = new rs.Markdown(renderer)

getSlides = (cb) ->
  fs.readdir config.slidesPath, (err, filenames) ->
    filenames = filenames.filter (filename) ->
      return filename.indexOf('-notes') < 0
    cb(err, filenames)

renderSlide = (file, cb) ->
  fs.readFile file, (err, data) ->
    cb(err, parser.render(data))

exports.slides = (req, res) ->
  getSlides (err, filenames) ->
    files = filenames.map (filename) ->
      path.join(config.slidesPath, filename)
    async.map files, renderSlide, (err, slides) ->
      res.render "slides", {slides: slides}
    return

renderNote = (file, cb) ->
  fs.readFile file, (err, data) ->
    if err
      cb(null, 'No notes')
    else
      cb(err, data)
    return

exports.rc = (req, res) ->
  getSlides (err, filenames) ->
    files = filenames.map (filename) ->
      ext = path.extname(filename)
      path.join(config.slidesPath,
                path.basename(filename, ext) + '-notes' + ext)
    async.map files, renderNote, (err, notes) ->
      res.render "rc", {notes: notes}
