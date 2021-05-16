# run using `Rscript.exe "./_scripts/serveRmd.R"
# https://www.rdocumentation.org/packages/servr/versions/0.22/topics/jekyll
servr::jekyll(
  input = "_R",
  output = "_posts",
  command = "bundle exec jeykll build",
  serve = TRUE
)