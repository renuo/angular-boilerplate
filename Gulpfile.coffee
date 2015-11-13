gulp = require 'gulp'
usemin = require 'gulp-usemin'
tslint = require 'gulp-tslint'
sassLint = require 'gulp-sass-lint'
gutil = require 'gulp-util'
ts = require 'gulp-typescript'
concat = require 'gulp-concat'
connect = require 'gulp-connect'
protractor = require('gulp-protractor').protractor;
del = require 'del'

paths =
  src: './src/*'
  ts: ["./src/app/{,*/}{,*/}*.ts", "!./src/app/{,*/}{,*/}*_spec.ts"]
  scss: './src/assets/styles/{,*/}*.scss'
  dist: './dist/'
  tmp: './tmp/'
  index: './src/index.html'
  finalDest: -> if gutil.env.type is 'production' then paths.dist else paths.tmp
  tsConfig: require './tsconfig.json'
  copy:
    html: './src/app/{,*/}{,*/}{,*/}*.html'
    assets: ['./src/assets/{,*/}{,*/}*', '!./src/assets/bower_components', '!./src/assets/styles']

gulp.task 'clean', ->
  del [paths.finalDest()]

gulp.task 'copy:html', ->
  gulp.src paths.copy.html
  .pipe gulp.dest "#{paths.finalDest()}app"
  .pipe connect.reload()

gulp.task 'copy:assets', ->
  gulp.src paths.copy.assets
  .pipe gulp.dest "#{paths.finalDest()}assets"
  .pipe connect.reload()

gulp.task 'copy', ['copy:assets', 'copy:html']

gulp.task 'usemin', ->
  gulp.src paths.index
  .pipe usemin()
  .pipe gulp.dest paths.finalDest
  .pipe connect.reload()

gulp.task 'ts', ->
  gulp.src paths.ts
  .pipe ts paths.tsConfig.compilerOptions
  .pipe concat 'sample.js'
  .pipe gulp.dest paths.finalDest
  .pipe connect.reload()

gulp.task 'sassLint', ->
  gulp.src paths.scss
  .pipe sassLint()
  .pipe sassLint.format()

gulp.task 'tslint', ->
  gulp.src paths.ts
  .pipe tslint()
  .pipe tslint.report 'verbose', emitError: false

gulp.task 'test:e2e', ['build'], ->
  gulp.src("#{paths.tmp}e2e")
  .pipe(protractor({
    configFile: 'protractor.js',
    args: ['--baseUrl', 'http://127.0.0.1:8000']
  }))
  .on('error', (e) -> throw e )

gulp.task 'connect', ->
  connect.server
    root: paths.tmp
    livereload: true
    host: 'sample-portal.dev'

gulp.task 'build', ['clean'], ->
  gulp.start ['usemin', 'ts', 'copy']

gulp.task 'default', -> console.log 'default'
