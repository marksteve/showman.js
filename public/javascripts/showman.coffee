bespoke.plugins.center = (deck) ->
  deck.slides.forEach (slide) ->
    centerWrapper = document.createElement("div")
    centerWrapper.className = "bespoke-center-wrapper"
    children = [].slice.call(slide.childNodes, 0)
    children.forEach (child) ->
      slide.removeChild(child)
      centerWrapper.appendChild(child)
      return
    slide.appendChild(centerWrapper)
    centerWrapper.style.marginTop = ((slide.offsetHeight - centerWrapper.offsetHeight) / 2) + "px"

showman =
  slides: false
  rc: false
  socket: io.connect(location.origin)
  init: (page) ->
    showman.socket.on "connect", ->
      console.log("Connected", showman.socket.socket.sessionid)
    $(document).imagesLoaded ->
      $(".loading").remove()
      showman.index = 0
      switch page
        when "slides"
          showman.deck = bespoke.horizontal.from "article",
            bullets: true
            center: true
          showman.socket.on "next", (data) ->
            showman.deck.next()
          showman.socket.on "prev", (data) ->
            showman.deck.prev()
          showman.socket.on "slide", (data) ->
            showman.deck.slide(data)
          showman.deck.on "activate", (e) ->
            showman.socket.emit "index", e.index
        when "rc"
          showman.deck = bespoke.from "article",
            center: true
          Hammer(showman.deck.parent)
            .on "tap", (e) ->
              showman.socket.emit "next"
            .on "swipeleft", (e) ->
              if showman.index + 1 < showman.deck.slides.length then ++showman.index else showman.index
              showman.socket.emit "slide", showman.index
            .on "swiperight", (e) ->
              if showman.index - 1 >= 0 then --showman.index else showman.index
              showman.socket.emit "slide", showman.index
          showman.socket.on "index", (data) ->
            showman.index = data
            showman.deck.slide showman.index
      return
