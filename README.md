# showman

Simple presentation app built with [express](http://expressjs.com), [bespoke.js](http://markdalgleish.com/projects/bespoke.js/) and [socket.io](http://socket.io/)

## Install
```bash
git clone https://github.com/marksteve/showman.git
cd showman
npm install -g
```

## Usage
Configuration is defined in `config.json`:
```json
{
  "title": "Showman Demo",
  "slidesPath": "./demo",
  "assetsPath": "./assets",
  "username": "demo",
  "password": "demo"
}
```

Slides are written in Markdown. You can add notes by adding
another Markdown file with the same name suffixed with "-notes".
For example: Write your notes for `001.md` in `001-notes.md`.

Run the showman server from the directory where `config.json` is:
```bash
showman
```

Go to http://&lt;showman_server&gt;:3000/ for the slides and
http://&lt;showman_server&gt;:3000/rc for the control.

## Controls

* Tap &rarr; `showman.deck.next()`
* Swipe Left &rarr; `showman.deck.slide(currIndex + 1)`
* Swipe Right &rarr; `showman.deck.slide(currIndex - 1)`

## Example

https://github.com/marksteve/manilajs003-slides

## License
http://marksteve.mit-license.org/
