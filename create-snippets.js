"use strict";

const fs = require("fs");
const _ = require("lodash");


const NATIVE_MODULES = Object.freeze([
  "isFinite",
  "isNaN",
  "valueOf"
]);

const templateES = _.template([
  "<snippet>",
  "  <content><![CDATA[",
  "import <%= imported %> from '<%= path %>';",
  "]]></content>",
  "  <tabTrigger>i_<%= name %></tabTrigger>",
  "  <scope>source.js</scope>",
  "  <description>ES <%= path %></description>",
  "</snippet>",
  ""
].join("\n"));

const templateCJS = _.template([
  "<snippet>",
  "  <content><![CDATA[",
  "const <%= imported %> = require('<%= path %>');",
  "]]></content>",
  "  <tabTrigger>r_<%= name %></tabTrigger>",
  "  <scope>source.js</scope>",
  "  <description>CJS <%= path %></description>",
  "</snippet>",
  ""
].join("\n"));

const getImportedName = (name) => _.includes(NATIVE_MODULES, name) ? `_${name}` : name;

const createSnippet = (templateFn, name) => templateFn({ name, imported: getImportedName(name), path: `lodash/${name}` });

const createLodashSnippet = (templateFn) => templateFn({ name: 'lodash', imported: 'lodash', path: 'lodash' });

const createSnippets = (templateFn, prefix, modules) => _(modules)
  .map(name => [name, createSnippet(templateFn, name)])
  .concat([["lodash", createLodashSnippet(templateFn)]])
  .forEach((args) => {
    const name = args[0];
    const snippet = args[1];

    fs.writeFileSync(`snippets/lodash-${prefix}-modules-${name}.sublime-snippet`, snippet, "utf8");
  });

// Read the modules from library
const modules = _.chain(fs.readdirSync("node_modules/lodash"))
  .filter(fileName => /\.js$/.test(fileName))
  .filter(fileName => fileName !== "index.js")
  .filter(fileName => fileName !== "lodash.js")
  .map(fileName => fileName.slice(0, fileName.length - 3))
  .value();

// Create snippets
createSnippets(templateES, "es", modules);
createSnippets(templateCJS, "cjs", modules);
