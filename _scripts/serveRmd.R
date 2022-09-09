# run using `Rscript.exe "./_scripts/serveRmd.R"
# https://www.rdocumentation.org/packages/servr/versions/0.22/topics/jekyll
servr::jekyll(
  input = c("_R", "_R/tidytuesday"),
  output = "_posts",
  command = "bundle exec jekyll build",
  serve = TRUE
)