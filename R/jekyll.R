library(knitr)

#' jekyll.draft
#' 
#' Create a draft in a Jekyll blog.
#' 
#' jekyll.draft `knit`s an RMarkdown file into standard Markdown and saves it
#' in your Jekyll _drafts directory with the appropriate frontmatter prepended.
#' 
#' Expects `options('jekyll.root')` to contain a reference to the root of your 
#' Jekyll blog (the directory that contains `_posts`); putting something like 
#' options(jekyll.root = '~/myblog') in your .Rprofile is probably the easiest
#' way to do this.
#' 
#' @param filename The path and name of the RMarkdown file to process.
#' @param title The post title
#' @param categories A string vector containing the categories this post will belong to
#' @param tags A vector of tags for this post
#' @param layout The layout to use for this post (defaults to getOption('jekyll.default.template') or 'post')
#' @export
#' @examples
#' jekyll.draft('my-post.Rmd', 'My draft', c('R', 'blogs'), c('cats', 'coffee'))
jekyll.draft = function(filename, title='', categories=c(), tags=c(), layout=F) {
  if ( !file.exists(filename) ) {
    cat('ERROR: File ', filename, ' does not exist.')
    return()
  }
  slug = .sluggify(title)
  
  dr = paste(Sys.getenv('HOME'), '/jekyll', sep='')
  dr = getOption('jekyll.root', default=dr)
  md.filename = paste(slug, '.markdown', sep="")
  
  outp.filename = file.path(dr, '_drafts', md.filename)
  if ( !file.exists(dirname(outp.filename)) ) {
    dir.create(dirname(outp.filename))
  }
  
  .jekyll.write(filename, outp.filename, title, categories, tags, layout)
}

#' jekyll.post
#' 
#' Create a post in a Jekyll blog.
#' 
#' jekyll.post `knit`s an RMarkdown file into standard Markdown and saves it
#' in your Jekyll _posts directory with the appropriate frontmatter prepended.
#' 
#' Expects `options('jekyll.root')` to contain a reference to the root of your 
#' Jekyll blog (the directory that contains `_posts`); putting something like 
#' options(jekyll.root = '~/myblog') in your .Rprofile is probably the easiest
#' way to do this.
#' 
#' @param filename The path and name of the RMarkdown file to process.
#' @param title The post title
#' @param categories A string vector containing the categories this post will belong to
#' @param tags A vector of tags for this post
#' @param layout The layout to use for this post (defaults to getOption('jekyll.default.template') or 'post')
#' @export
#' @examples
#' jekyll.draft('my-post.Rmd', 'My draft', c('R', 'blogs'), c('cats', 'coffee'))
jekyll.post = function(filename, title='', categories=c(), tags=c(), layout=F) {
  if ( !file.exists(filename) ) {
    cat('ERROR: File ', filename, ' does not exist.')
    return()
  }
  slug = .sluggify(title)
  
  dr = paste(Sys.getenv('HOME'), '/jekyll', sep='')
  dr = getOption('jekyll.root', default=dr)
  
  md.filename = paste(as.character(Sys.Date()), '-', slug, '.markdown', sep="")
  outp.filename = file.path(dr, '_posts', md.filename)
  .jekyll.write(filename, outp.filename, title, categories, tags)
}

#' @keywords internal
.sluggify = function(inpt) {
  outp = tolower(inpt)
  outp = gsub('[^\\w\\d]+', '-', outp, perl=T)
  gsub('^-|-$', '', outp, perl=T)
}

#' @keywords internal
.jekyll.write = function(filename, outp.filename, title='', categories=c(), tags=c(), layout=F) {
  if ( !interactive()  && ( nchar(title) == 0 ) ) return()
  if ( !nchar(title) ) {
    #TODO: ask for title.
  }
  
  if ( !layout ) layout = getOption('jekyll.default.template', 'post')
  #TODO: check for tags & categories; ask if not provided.
  
  tmp.dr = dirname(filename)
  tmp.fl = sub('.Rmarkdown$', '.markdown', basename(filename))
  tmp.fl = sub('.Rmd$', '.markdown', basename(tmp.fl))
  tmp.filepath = file.path(tmp.dr, tmp.fl)
  
  dr = paste(Sys.getenv('HOME'), '/jekyll', sep='')
  dr = getOption('jekyll.root', default=dr)
  frontmatter = c(paste('title:', title))
  frontmatter = c(frontmatter, paste('layout:', layout))
  
  if ( length(categories) ) {
    frontmatter = c(frontmatter, 'categories:')
    for ( cat in categories) {
      frontmatter = c(frontmatter, paste(' -', cat))
    }
  }
  
  if ( length(tags) ) {
    frontmatter = c(frontmatter, 'tags:')
    for ( tag in tags) {
      frontmatter = c(frontmatter, paste(' -', tag))
    }
  }
  
  cat('---', frontmatter, '---', sep="\n", file=outp.filename)
  
  knit(filename, tmp.filepath)
  file.append(outp.filename, tmp.filepath)
}
