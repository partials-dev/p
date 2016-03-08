var gulp = require('gulp');
var wiredep = require('wiredep').stream;
var script = require('./script');

// Include Bower components in html
var bowerTask = function () {
  gulp.src('./src/index.html')
    .pipe(wiredep())
    .pipe(gulp.dest('./public/'));
};
gulp.task('bower', ['script'], bowerTask);

module.exports = 'bower';
