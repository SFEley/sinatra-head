Sinatra::Head
=============
             
This is a simple asset and `<head>` tag manager for Sinatra projects.  It allows dynamically adding or 
changing stylesheets, javascript includes, or the page title at any level of Sinatra class inheritance 
or within an action.

Setting Up
----------
You should know this part:
    
    $ gem install sinatra-head

(Or `sudo gem install` if you're the last person on Earth who isn't using [RVM][1] yet.)

If you're developing a Sinatra ['classic'][2] application, then all you need to do is require the library:

    # blah_app.rb
    require 'sinatra'
    require 'sinatra/head'
    
    title << 'My Wonderful App'
    stylesheets << 'main.css'
      
    get '/blah' do
      title << 'Feeling blah'
      stylesheets << 'blah.css'
    end
    
Then, in your layout, just call the `head_tag` helper:

    # views/layout.haml
    %html
      =head_tag
      %body
        =yield

When called, you'll see a head that sets the charset to UTF-8, "**Feeling blah | My Wonderful App**" as the page title, and 
includes both */stylesheets/main.css* and *stylesheets/blah.css*.  You can override the default choices here with Sinatra settings.

If you're using the [Sinatra::Base][2] style, you also need to register the extension:

    # bleh_app.rb
    require 'sinatra/base'
    require 'sinatra/head'
    
    class BlehApp < Sinatra::Base
      register Sinatra::Head
      
      # Everything else is the same as the 'classic' example above.
    end
    
See the Sinatra documentation on [using extensions][3] for more detail and rationale.

Head element
------------
**Tag helpers:** `head_tag`

This extension is all about the head and the layout.  Accordingly, there's a convenient `head_tag` helper that puts together the four other elements described below:

    <head>
      <meta charset='UTF-8' />
      <title>All title elements | as appended using the 'title' call | in reverse order</title>
      <link rel='stylesheet' href='/stylesheets/first.css' />
      <!-- ...other stylesheets as declared in order... -->
      <script src="/javascript/first.js"></script>
      <!-- ...other javascripts as declared in order... -->
    </head>
    
If you want something more or something different, you can of course skip this and call the other _*\_tag_ methods any way you want.

*A note on style:* My markup flavor of choice is [HTML5][4]. HTML5 is backwards compatible with everything and does not require self-closing tags. However, some of you may be using XHTML, and I don't want to break your stuff over a minor religious difference. So the `meta` and `link` tags are self-closed, to keep your validators from complaining and because it doesn't really hurt anyone else.

Charset
-------
**Sinatra settings:** `:charset`  
**Tag helpers:** `charset_tag`

It's best practice for all Web pages to declare their encoding -- even if the server _should_ be doing it, even if you only use ASCII, etc. etc. **Sinatra::Head** makes an opinionated choice and sets this to **utf-8** for you, but you can override it if you want:

    set :charset, 'shift-jis'

You are of course responsible for making sure that the page output keeps any encoding promise you make.  If you're using Ruby 1.9, it's a good idea to set the `Encoding.default_internal` value to utf-8 as well.  Also note that using Sinatra's **content_type** helper will override this for any page by setting the HTTP headers directly, which take precedence over `<meta>` tags.

*A note on meta tags:* Someone is doubtless going to ask what happened to the _http-equiv_ or _content_ attributes. [This][5] is my short answer. If this fails to validate for any common use case, let me know.

Title
-----
**Sinatra settings:** `:title`, `:title_separator`  
**Data helpers:** `title`, `title=`, `title_string`  
**Tag helpers:** `title_tag`

Multi-part titles that describe the page, the category, and the site are standard practice for SEO and other reasons. **Sinatra::Head** manages this by setting up **title** as a Sinatra setting with an empty array and letting you add to it:

    title << 'Site'
    title << 'Page' # => 'Page | Site'

Note that the title chain unspools in LIFO order, not FIFO.  (I.e., it's a stack, not a queue.)

If you want to blow away this chain for a single action, we do have a `title=` helper for the purpose. You can also change the separator from ` | ` to anything you want with the `:title_separator` setting.

Stylesheets
-----------
**Sinatra settings:** `:stylesheets`, `:stylesheet_path`, `:stylesheet_splitter` 
**Data helpers:** `stylesheets`, `expand_stylesheet_path`  
**Tag helpers:** `stylesheet_tag`, `stylesheet_tags`

Like the _title_ setting, the _stylesheets_ setting begins life as an empty array.  Thus, you can add sheets to it at any time.  Simple filenames will have the *stylesheet_path* setting prepended for a consistent relative path (it defaults simply to _"stylesheets"_); hyperlinks beginning with `http:` or `https:` will not be touched.

    stylesheets << 'main.css'
    stylesheets << 'http://someothersite.org/popular_css_extension.css'
    
    get '/blah' do
      stylesheets << 'specific.css'
    end

If your stylesheet string contains a space, the second and any following words will be used for the _media_ attribute:

    stylesheets << 'no_effects.css print braille'
    # yields:
    <link rel='stylesheet' href='/stylesheets/no_effects.css' media='print, braille' />
    
If your stylesheet string contains a splitter, you can specify a splitter and use the second portion for the _media_ attribute:

    set :stylesheet_splitter, ' | '
    stylesheets << 'tablet.css | screen and (min-width:520px) and (max-width:959px)'
    # yields:
    <link rel='stylesheet' href='/stylesheets/tablet.css' media='screen and (min-width:520px) and (max-width:959px)' />
    
In your layout, you can call the `stylesheet_tag` helper for a single filename or URL you provide, or the `stylesheet_tags` helper which walks the array and creates a tag for each.  (In FIFO or queue order, unlike _title._)

Currently nothing is done for nicer asset packaging, fingerprinting, compressing, etc. There's [Rack][10] [middleware][9] for some of it, and future iterations may include these features. If you'd really really like to see them, [create an issue][7] and ask for them.

Javascripts
-----------
**Sinatra settings:** `:javascripts`, `:javascript_path`  
**Data helpers:** `javascripts`, `expand_javascript_path`  
**Tag helpers:** `javascript_tag`, `javascript_tags`

These helpers are functionally very similar to the _stylesheets_ ones, allowing the addition of relative filenames (which will be expanded with the *javascript_path* setting) or full URLs.  One wrinkle here is that you can _also_ include inline code:

    javascripts << 'main.js'
    javascripts << 'http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js'
    
    get '/blah' do
      javascripts << %q[
        window.onload = function(){
          some_silly_thing;
        };]
    end

Inline code is detected by the presence of a semicolon, and will be included as the body of the `<script>` tag rather than as the **src=** attribute.  (So if you have semicolons in your scripts' filenames or URLs...  _What were you thinking?_)

As noted above for stylesheets, right now there are no facilities to minify, compress, or recombobulate your Javascript. Also as noted, [feel free to ask][7] or contribute.

Credit, Support, and Contributions
----------------------------------
This extension is the fault of **Stephen Eley**. You can reach me at <sfeley@gmail.com>. If you like science fiction stories, I know a [good podcast][6] for them as well.

If you find bugs, please report them on the [Github issue tracker][7]. 

The documentation can of course be found on [RDoc.info][8].

Contributions are welcome. This was a quick start to get me some features I needed in a complex stack of Sinatra apps. There's a lot more that _can_ be done on this, but I'll keep sniffing the wind to find out what _should_ be done.

License
-------
This project is licensed under the **Don't Be a Dick License**, version 0.2, and is copyright 2010 by Stephen Eley. See the [LICENSE.markdown][11] file or the [DBAD License site][12] for elaboration on not being a dick.


[1]: http://rvm.beginrescueend.com
[2]: https://sinatra.lighthouseapp.com/projects/9779/tickets/240-sinatrabase-vs-sinatradefault-vs-sinatraapplication
[3]: http://www.sinatrarb.com/extensions-wild.html
[4]: http://diveintohtml5.org/semantics.html
[5]: http://diveintohtml5.org/semantics.html#encoding
[6]: http://escapepod.org
[7]: http://github.com/SFEley/sinatra-head/issues
[8]: http://rdoc.info/projects/SFEley/sinatra-head
[9]: http://coderack.org/users/chriskottom/middlewares/66-rackdomainsprinkler
[10]: http://rack.rubyforge.org/doc/Rack/Static.html
[11]: http://github.com/SFEley/sinatra-head/blob/master/LICENSE.markdown
[12]: http://dbad-license.org
