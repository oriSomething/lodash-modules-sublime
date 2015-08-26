# Lodash modules snippets (for sublime text)

Import easily only the modules you need from [lodash](https://lodash.com/).
Supports [lodash 3.3.0v](https://lodash.com/).

## Examples

- CommonJS: typing `r_map` will resolve to `var map = require('lodash/collection/map');`
- ES2015: typing `i_map` will resolve to `import map from 'lodash/collection/map';`


## Installation

The recomand way is by using [Package Control](https://packagecontrol.io/):

1. open the command palette by typing `⌘+shift+p` on OS X or `ctrl+shift+p` on Windows/Linux
2. select `Package Control: Install Package`
3. type `Lodash modules snippets`


The other way is:

1. open the terminal on sublime's packages folder
2. type `git clone https://github.com/oriSomething/lodash-modules-sublime.git`


## Contributing

It seems like the best way to get a list of lodash's methods and collections
is by using `lodash-cli`, make sure you have [npm][npm] installed, then run
`npm install` in this directory.

That'll install `lodash-cli`; then you just need to run `./build-snippets.sh`
to update the snippets.
