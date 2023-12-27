# MissTickles

[![Jekyll](https://img.shields.io/badge/jekyll-4.2.0-blue.svg)](https://jekyllrb.com/) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/misstickles/misstickles.github.io/Build%20and%20Deploy%20to%20Github%20Pages?style=flat)
[![Build and Deploy to Github Pages](https://github.com/misstickles/misstickles.github.io/actions/workflows/main.yml/badge.svg)](https://github.com/misstickles/misstickles.github.io/actions/workflows/main.yml)

## Theme

Based on [Yat](https://github.com/jeffreytse/jekyll-theme-yat) and modified by me.

## CV

Theme turned into Jekyll by me and based on a Bootstrap 4 theme by [Xiaoying Riley](https://twitter.com/3rdwave_themes). The original theme is available from <https://themes.3rdwavemedia.com/bootstrap-templates/resume/devresume-free-bootstrap-4-resume-cv-template-for-developers/>.

## Jekyll / Bundle Commands

### Scripts

Use scripts in `_scripts` to run locally.

Ie, `Rscript.exe ./_scripts/serveRmd.R` (Usually, `C:\Program Files\R\R-version\bin\Rscript.exe`).

Serves to <http://127.0.0.1:4321/>.

### Local Jekyll

Live reload

`bundle exec jekyll serve --livereload --incremental`

View info regarding jekyll pipeline

`bundle exec jekyll build --profile`

- <https://forestry.io/blog/how-i-reduced-my-jekyll-build-time-by-61/>

### Fix eventmachine

<https://robbinespu.gitlab.io/posts/jekyll-unable-load-eventmachine/>

```
Jekyll - Unable to load the EventMachine C extension
Posted on Oct 16, 2020
When I using --livereload parameter with Jekyll, I get nasty failure like below :

bundle exec jekyll serve --livereload --verbose -I
.
.
.
Writing Metadata: .jekyll-metadata
                    done in 3.442 seconds.
         Requiring: jekyll-watch
           Watcher: Ignoring (?-mix:^_config\.yml)
           Watcher: Ignoring (?-mix:^_site\/)
           Watcher: Ignoring (?-mix:^\.jekyll\-cache\/)
           Watcher: Ignoring (?-mix:^Gemfile)
           Watcher: Ignoring (?-mix:^Gemfile\.lock)
           Watcher: Ignoring (?-mix:^vendor\/cache\/)
 Auto-regeneration: enabled for 'D:/NOPE/robbinespu.gitlab.io'
Unable to load the EventMachine C extension; To use the pure-ruby reactor, require 'em/pure_ruby'
                    ------------------------------------------------
      Jekyll 4.1.1   Please append `--trace` to the `serve` command
                     for any additional information or backtrace.
                    ------------------------------------------------
After google-fu, the most solution given are to uninstall eventmachine-1.2.7-x64-mingw32 gems

$  gem uninstall eventmachine

Select gem to uninstall:
 1. eventmachine-1.2.7
 2. eventmachine-1.2.7-x64-mingw32
 3. All versions
> 2
Successfully uninstalled eventmachine-1.2.7-x64-mingw32
Then you can continue using --livereload parameter with Jekyll but if somehow in future you execute bundle install or bundle update, it will install eventmachine-1.2.7-x64-mingw32 gems again and you need to uninstall again. This is repeative..

The best solution and the proper step are:

run command gem uninstall eventmachine and choose to uninstall eventmachine-1.2.7-x64-mingw32 gems from your system
edit your Gemfile and add this line inside
gem 'eventmachine', '1.2.7', git: 'git@github.com:eventmachine/eventmachine', tag: 'v1.2.7'
execute bundle install
Clean up your jekyll build and cache with command bundle exec jekyll clean
Lastly now you can use --livereload parameter without getting any issue if you execute bundle install in future
This should work nicely!
```
