gulp = require 'gulp'
usemin = require 'gulp-usemin'
tslint = require 'gulp-tslint'
sassLint = require 'gulp-sass-lint'
gutil = require 'gulp-util'
ts = require 'gulp-typescript'
concat = require 'gulp-concat'
connect = require 'gulp-connect'
protractor = require('gulp-protractor').protractor
del = require 'del'

paths =
  assets: ['./src/assets/{,*/}{,*/}*', '!./src/assets/bower_components', '!./src/assets/styles']
  dist: './dist/'
  finalDest: -> if gutil.env.type is 'production' then paths.dist else paths.tmp
  html: './src/app/{,*/}{,*/}{,*/}*.html'
  index: './src/index.html'
  scss: './src/assets/styles/{,*/}*.scss'
  src: './src/*'
  tmp: './tmp/'
  ts: ["./src/app/{,*/}{,*/}*.ts", "!./src/app/{,*/}{,*/}*_spec.ts"]
  tsConfig: require './tsconfig.json'

gulp.task 'copy:html', ->
  gulp.src paths.html
  .pipe gulp.dest "#{paths.finalDest()}app"
  .pipe connect.reload()

gulp.task 'copy:assets', ->
  gulp.src paths.assets
  .pipe gulp.dest "#{paths.finalDest()}assets"
  .pipe connect.reload()

gulp.task 'copy', gulp.parallel 'copy:assets', 'copy:html'

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

gulp.task 'lint:sass', ->
  gulp.src paths.scss
  .pipe sassLint()
  .pipe sassLint.format()

gulp.task 'lint:ts', ->
  gulp.src paths.ts
  .pipe tslint()
  .pipe tslint.report 'verbose', emitError: false

gulp.task 'clean', (cb) ->
  del paths.finalDest(), cb

gulp.task 'build', gulp.series 'clean', gulp.parallel 'usemin', 'ts', 'copy'

gulp.task 'test:e2e', gulp.series 'build', ->
  gulp.src "#{paths.tmp}e2e"
  .pipe protractor configFile: 'protractor.js', args: ['--baseUrl', 'http://127.0.0.1:8000']
  .on 'error', (e) -> throw e

gulp.task 'connect', gulp.series 'build', (cb) ->
  connect.server
    root: paths.tmp
    livereload: true
    host: 'sample-portal.dev'
  cb()

gulp.task 'watch', ->
  gulp.watch paths.index, gulp.series 'usemin'
  gulp.watch paths.ts, gulp.series 'ts'
  gulp.watch paths.html, gulp.series 'copy:html'
  gulp.watch paths.assets, gulp.series 'copy:assets'

gulp.task 'default', gulp.series 'connect', 'watch'
