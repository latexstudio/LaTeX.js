#!/usr/local/bin/lsc -cj

name: 'latex.js'
description: 'JavaScript LaTeX to HTML5 translator'
version: '0.10.0'

author:
    'name': 'Michael Brade'
    'email': 'brade@kde.org'

keywords:
    'pegjs'
    'latex'
    'parser'
    'html5'


main:
    'dist/latex-parser.js'

bin:
    'latex.js': './bin/latex.js'

files:
    'bin/latex.js'
    'dist/latex-parser.js'
    'dist/macros.js'
    'dist/symbols.js'
    'dist/html-generator.js'
    'dist/documentclasses/'
    'dist/css/'
    'dist/fonts/'
    'dist/js/'


scripts:
    clean: 'rimraf dist bin;'
    build: "
        npm run devbuild;
        uglifyjs dist/plugin-pegjs.js            -cm -o dist/plugin-pegjs.js;
        uglifyjs dist/latex-parser.js            -cm -o dist/latex-parser.js;
        uglifyjs dist/macros.js                  -cm -o dist/macros.js;
        uglifyjs dist/symbols.js                 -cm -o dist/symbols.js;
        uglifyjs dist/html-generator.js          -cm -o dist/html-generator.js;
        uglifyjs dist/documentclasses/base.js    -cm -o dist/documentclasses/base.js;
        uglifyjs dist/documentclasses/article.js -cm -o dist/documentclasses/article.js;
        uglifyjs dist/documentclasses/book.js    -cm -o dist/documentclasses/book.js;
        uglifyjs dist/documentclasses/report.js  -cm -o dist/documentclasses/report.js;

        mkdirp bin;
        lsc -bc --no-header -o bin src/latex.js.ls;
    "
    devbuild: "
        mkdirp dist/documentclasses;
        mkdirp dist/css;
        mkdirp dist/js;
        mkdirp dist/fonts;
        rsync -a src/css/ dist/css/;
        rsync -a src/fonts/ dist/fonts/;
        rsync -a src/js/ dist/js/;
        lsc -c -o dist src/plugin-pegjs.ls src/symbols.ls src/macros.ls src/html-generator.ls;
        lsc -c -o dist/documentclasses src/documentclasses/;
        pegjs -o dist/latex-parser.js --plugin ./dist/plugin-pegjs src/latex-parser.pegjs;
    "
    docs:  'npm run devbuild && webpack && uglifyjs -cm -o docs/js/playground.bundle.pack.js docs/js/playground.bundle.js;'
    pgcc:  "google-closure-compiler --compilation_level SIMPLE \
                                    --externs src/externs.js \
                                    --js_output_file docs/js/playground.bundle.pack.js docs/js/playground.bundle.js;"
    test:  'mocha test/tests.ls;'
    iron:  'iron-node node_modules/.bin/_mocha test/tests.ls;'
    cover: 'istanbul cover --dir test/coverage _mocha test/tests.ls;'

babel:
    plugins:
        '@babel/syntax-object-rest-spread'
        ...


dependencies:
    'he': '1.1.x'
    'katex': '0.9.0'
    'svg.js': '2.6.x'
    'svgdom': 'https://github.com/michael-brade/svgdom'

    'hypher': '0.x'
    'hyphenation.en-us': '*'
    'hyphenation.de': '*'

    'lodash': '4.x'
    'commander': '2.16.x'
    'stdin': '*'
    'fs-extra': '7.x'
    'js-beautify': '1.7.x'

    #'cheerio': '0.x'
    #'xmldom': '^0.1.19'

devDependencies:
    'livescript': 'https://github.com/gkz/LiveScript'

    ### building

    'pegjs': '0.10.x'
    'mkdirp': '0.5.x'
    'rimraf': '2.6.x'
    'uglify-js': '3.4.x'


    ### bundling

    'webpack': '4.x'
    'webpack-command': '0.x'
    'webpack-closure-compiler': '2.x'
    'babel-loader': '8.0.0-beta.3'
    'copy-webpack-plugin': '4.5.x'

    '@babel/core': '7.0.0-beta.55'
    '@babel/register': '7.0.0-beta.55'
    '@babel/plugin-syntax-object-rest-spread': '7.0.0-beta.55'


    ### testing

    'mocha': '5.x'
    'chai': '4.x'
    'chai-as-promised': '7.x'

    'puppeteer': '1.6.x'
    'pixelmatch': '4.0.x'

    'istanbul': '>= 0.4.x'


repository:
    type: 'git'
    url: 'git+https://github.com/michael-brade/LaTeX.js.git'

license: 'MIT'

bugs:
    url: 'https://github.com/michael-brade/LaTeX.js/issues'

homepage: 'https://github.com/michael-brade/LaTeX.js#readme'

engines:
    node: '>= 8.0'
