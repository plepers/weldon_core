module.exports = (grunt) ->
  'use strict'

  # Underscore
  # ==========
  _ = grunt.util._

  # Package
  # =======
  pkg = require './package.json'

  # Configuration
  # =============
  grunt.initConfig

    # Cleanup
    # -------
    clean:
      build: 'build'
      temp: 'temp'
      bower: 'components'
      components: 'components'
      amd: 'temp/scripts-amd'
      post_build: "build/#{pkg.name}/"

    # Wrangling
    # ---------
    copy:
      options:
        excludeEmpty: true

      module:
        files: [
          dest: "temp/#{pkg.name}"
          cwd: 'temp/scripts-amd'
          expand: true
          src: [
            '**/*'
            '!vendor/**/*'
          ]
        ]

      release:
        src: "build/#{pkg.name}/main.js"
        dest:"build/#{pkg.name}.js"



    # Dependency management
    # ---------------------
    bower:
      install:
        options:
          targetDir: './libs'
          cleanup: true
          install: true

    bower_require:
      target:
        rjsConfig: 'src/config.js'
    # Compilation
    # -----------
    coffee:
      compile:
        options:
          bare: true

        files: [
          expand: true
          cwd: 'src/scripts'
          src: '**/*.coffee'
          dest: "temp/#{pkg.name}"
          ext: '.js'
        ]

    # Micro-templating language
    # -------------------------
    handlebars:
      compile:
        options:
          namespace: false
          amd: true

        files: [
          expand: true
          cwd: 'src/scripts'
          src: '**/*.hbs'
          dest: "temp/#{pkg.name}"
          ext: '.js'
        ]

    # Micro-templating language
    # -------------------------
    jade:
      compile:
        options:
          client: true
          namespace: false
          amd: true
          compileDebug: false

        files: [
          expand: true
          cwd: 'src/scripts'
          src: '**/*.jade'
          dest: "temp/#{pkg.name}"
          ext: '.js'
        ]

    # Stylesheet Compressor
    # ---------------------
    mincss:
      compress:
        files:
          'build/styles/main.css': 'build/styles/main.css'

    # Stylesheet Preprocessor
    # -----------------------
    stylus:
      compile:
        files:
          'temp/styles/main.css': 'src/styles/**/*.styl'

      build:
        files:
          'temp/styles/main.css': 'src/styles/**/*.styl'

        options:
          compress: true

    # Module conversion
    # -----------------
    urequire:
      convert:
        template: 'AMD'
        bundlePath: "temp/#{pkg.name}/"
        outputPath: 'temp/scripts-amd/'


    # Script lint
    # -----------
    coffeelint:
      gruntfile: 'Gruntfile.coffee'
      src: [
        'src/**/*.coffee'
        '!src/scripts/vendor/**/*'
      ]

    # Webserver
    # ---------
    connect:
      options:
        port: 3501
        hostname: 'localhost'
        middleware: (connect, options) -> [
          require('connect-url-rewrite') ['^([^.]+|.*\\?{1}.*)$ /']
          connect.static options.base
          connect.directory options.base
        ]

      build:
        options:
          keepalive: true
          base: 'build'

      temp:
        options:
          base: 'temp'

    # HTML Compressor
    # ---------------
    htmlmin:
      build:
        options:
          removeComments: true
          removeCommentsFromCDATA: true
          removeCDATASectionsFromCDATA: true
          collapseWhitespace: true
          collapseBooleanAttributes: true
          removeAttributeQuotes: true
          removeRedundantAttributes: true
          useShortDoctype: true
          removeEmptyAttributes: true
          removeOptionalTags: true

        files: [
          expand: true
          cwd: 'build'
          dest: 'build'
          src: '**/*.html'
        ]

    # Dependency tracing
    # ------------------
    # TODO: This should not be neccessary; uRequire should be able to do
    #   this.
    requirejs:
      compile:
        options:
          appDir: './temp'
          dir: 'build'
          baseUrl: './'
          mainConfigFile: 'src/config.js'

          modules : [
            {
              name : "#{pkg.name}/main"
              exclude: [
                'chaplin'
                'handlebars'
                'backbone'
                'jquery'
              ]
            }
          ]
          removeCombined : false
          optimize: 'none'

      css:
        options:
          out: 'build/styles/main.css'
          optimizeCss: 'standard.keepLines'
          cssImportIgnore: null
          cssIn: 'temp/styles/main.css'

    # Watch
    # -----
    watch:
      coffee:
        files: 'src/scripts/**/*.coffee'
        tasks: [ 'script', 'handlebars:compile', 'jade:compile' ]
        #tasks: 'script'
        options:
          interrupt: true

      components:
        files: 'src/components/**/*.js'
        tasks: 'copy:static'
        options:
          interrupt: true

      chaplin_dev:
        files: '../chaplin/build/amd/chaplin.js'
        tasks: 'copy:chaplin_dev'
        options:
          interrupt: true

      handlebars:
        files: 'src/**/*.hbs'
        tasks: 'handlebars:compile'
        options:
          interrupt: true

      jade:
        files: 'src/**/*.jade'
        tasks: 'jade:compile'
        options:
          interrupt: true

      stylus:
        files: 'src/styles/**/*.styl'
        tasks: 'stylus:compile'
        options:
          interrupt: true

  # Dependencies
  # ============
  for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks name

  # Tasks
  # =====

  # Lint
  # ----
  # Lints all applicable files.
  grunt.registerTask 'lint', [
    'coffeelint'
  ]

  # Prepare
  # -------
  # Cleans the project directory of built files and downloads / updates
  # bower-managed dependencies.
  grunt.registerTask 'prepare', [
    'clean'
    'bower:install'
  ]

  # Script
  # ------
  # Compiles all coffee-script into java-script converts them to the
  # appropriate module format (if neccessary).
  grunt.registerTask 'script', [
    'coffee:compile'
    'urequire:convert'
    'copy:module'
    'clean:amd'
  ]

  # Server
  # ------
  # Compiles a development build of the application; starts an HTTP server
  # on the output; and, initiates a watcher to re-compile automatically.
  grunt.registerTask 'server', [
    'copy:static'
    'script'
    'handlebars:compile'
    'jade:compile'
    'stylus:compile'
    'connect:temp'
    'watch'
  ]

  # Build
  # -----
  # Compiles a production build of the application.
  grunt.registerTask 'build', [
    'clean:build'
    'handlebars:compile'
    'jade:compile'
    'script'
    'stylus:build'
    'requirejs:compile'
    'copy:release'
    'clean:post_build'
#    'requirejs:css'
#    'mincss:compress'
#    'htmlmin'
  ]
