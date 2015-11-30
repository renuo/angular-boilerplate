autoprefixer = require 'autoprefixer'
concat = require 'gulp-concat'
connect = require 'gulp-connect'
del = require 'del'
gulp = require 'gulp'
gutil = require 'gulp-util'
minifyCss = require 'gulp-minify-css'
postcss = require 'gulp-postcss'
protractor = require('gulp-protractor').protractor
sass = require 'gulp-sass'
sassLint = require 'gulp-sass-lint'
ts = require 'gulp-typescript'
tslint = require 'gulp-tslint'
uglify = require 'gulp-uglify'
usemin = require 'gulp-usemin'

helpers =
  do: (env, truthy, falsy = gutil.noop()) ->
    if gutil.env.type is env then truthy else falsy

paths =
  assets: ['./src/assets/{,*/}{,*/}*', '!./src/assets/bower_components', '!./src/assets/styles']
  dist: './dist/'
  finalDest: -> helpers.do 'production', paths.dist, paths.tmp
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
  .pipe helpers.do 'production', uglify()
  .pipe gulp.dest paths.finalDest
  .pipe connect.reload()

gulp.task 'sass', ->
  gulp.src paths.scss
  .pipe sass()
  .pipe postcss [autoprefixer(browsers: ['last 2 versions'])]
  .pipe helpers.do 'production', minifyCss()
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

gulp.task 'build', gulp.series 'clean', gulp.parallel 'usemin', 'ts', 'sass', 'copy'

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
  gulp.watch paths.scss, gulp.series 'sass'
  gulp.watch paths.html, gulp.series 'copy:html'
  gulp.watch paths.assets, gulp.series 'copy:assets'

gulp.task 'default', gulp.series 'connect', 'watch'
