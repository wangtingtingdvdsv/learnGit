var gulp = require('gulp');
var fileinclude = require('gulp-file-include');
gulp.task('fileinclude', function() {
	gulp.src(['../index.html', '../home.html'])
		.pipe(fileinclude({
			prefix: '@@',
			basepath: '@file'
		}))
		.pipe(gulp.dest('./g'));
})
gulp.task('default', ['fileinclude']);