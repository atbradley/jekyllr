jekyll.R
========
Provides two R functions intended for use from the RStudio console. Both expect two options to be set in R:

* `options('jekyll.root')`: a reference to the root of your Jekyll blog (the directory that contains `_posts`), and
* `options('jekyll.default.template')`: The name of the layout to use for posts. This can also be given as an 
argument to `jekyll.draft` or `jekyll.post`. If you don't provide it anywhere, it defaults to `post`.

`jekyll.draft(filename, title='', categories=c(), tags=c(), layout=FALSE)`  
`knit()`s the file at `filename`, prepends [YAML front-matter](http://jekyllrb.com/docs/frontmatter/) for the title, categories and tags (if present), and saves the output in your blog's `_drafts` directory with a filename based on the provided title.

Currently, `title`, `categories`, and `tags` must be provided in the function call, e.g.:
```
jekyll.draft('mypost.Rmarkdown', 'This is my post', c('R', 'statistics'), c('blogging', 'jekyll'))
```

`jekyll.post(filename, title='', categories=c(), tags=c(), layout=FALSE)`  
Same as `jekyll.draft()` but prepends the current date to the filename and places the output in your blog's `_posts` directory.

*Note that for this to work,* the markdown interpreter being used by your site must be configured to support Github Flavored Markdown. See [this blog post](http://simonvanderveldt.nl/jekyll-github-flavored-markdown-and-footnotes/) for details on how to do this with Kramdown and RedCarpet; `RDiscount` uses the necessary setting by default.