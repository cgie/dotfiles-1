# --------------------------------------------------------------------

= Github

https://github.com/peter-murach/github/blob/master/spec/github/pagination/iterator/number_spec.rb

https://github.com/peter-murach/github/blob/master/spec/github/page_links_spec.rb

https://github.com/peter-murach/github/blob/master/lib/github_api/response_wrapper.rb

# --------------------------------------------------------------------

= Kaminari

A Scope & Engine based, clean, powerful, customizable and sophisticated paginator for modern web app frameworks and ORMs


== Features

=== Clean
Does not globally pollute +Array+, +Hash+, +Object+ or <tt>AR::Base</tt>.

=== Easy to use
Just bundle the gem, then your models are ready to be paginated. No configuration required. Don't have to define anything in your models or helpers.

=== Simple scope-based API
Everything is method chainable with less "Hasheritis". You know, that's the Rails 3 way.
No special collection class or anything for the paginated values, instead using a general <tt>AR::Relation</tt> instance. So, of course you can chain any other conditions before or after the paginator scope.

=== Customizable engine-based I18n-aware helper
As the whole pagination helper is basically just a collection of links and non-links, Kaminari renders each of them through its own partial template inside the Engine. So, you can easily modify their behaviour, style or whatever by overriding partial templates.

=== ORM & template engine agnostic
Kaminari supports multiple ORMs (ActiveRecord, Mongoid, MongoMapper) multiple web frameworks (Rails, Sinatra), and multiple template engines (ERB, Haml).

=== Modern
The pagination helper outputs the HTML5 <nav> tag by default. Plus, the helper supports Rails 3 unobtrusive Ajax.


== Supported versions

* Ruby 1.8.7, 1.9.2, 1.9.3, 2.0 (trunk)

* Rails 3.0.x, 3.1, 3.2, 4.0 (edge)

* Haml 3+

* Mongoid 2+

* MongoMapper 0.9+

* DataMapper 1.1.0+

== Install

Put this line in your Gemfile:
  gem 'kaminari'

Then bundle:
  % bundle


== Usage

=== Query Basics

* the +page+ scope

  To fetch the 7th page of users (default +per_page+ is 25)
    User.page(7)

* the +per+ scope

  To show a lot more users per each page (change the +per_page+ value)
    User.page(7).per(50)
  Note that the +per+ scope is not directly defined on the models but is just a method defined on the page scope. This is absolutely reasonable because you will never actually use +per_page+ without specifying the +page+ number.
  
  If you would like to specify "no limit" while still using the +per+ scope, you can pass +nil+:
    User.count                 # => 1000
    User.page(1).per(nil).size # => 1000
    
* the +padding+ scope

  Occasionally you need to pad a number of records that is not a multiple of the page size.
    User.page(7).per(50).padding(3)
  Note that the +padding+ scope also is not directly defined on the models.

=== General configuration options

You can configure the following default values by overriding these values using <tt>Kaminari.configure</tt> method.
  default_per_page  # 25 by default
  max_per_page      # nil by default
  window            # 4 by default
  outer_window      # 0 by default
  left              # 0 by default
  right             # 0 by default
  page_method_name  # :page by default
  param_name        # :page by default

There's a handy generator that generates the default configuration file into config/initializers directory.
Run the following generator command, then edit the generated file.
  % rails g kaminari:config

* changing +page_method_name+

  You can change the method name +page+ to +bonzo+ or +plant+ or whatever you like, in order to play nice with existing +page+ method or association or scope or any other plugin that defines +page+ method on your models.


=== Configuring default +per_page+ value for each model

* +paginates_per+

  You can specify default +per_page+ value per each model using the following declarative DSL.
    class User < ActiveRecord::Base
      paginates_per 50
    end

=== Configuring max +per_page+ value for each model

* +max_paginates_per+

  You can specify max +per_page+ value per each model using the following declarative DSL.
  If the variable that specified via +per+ scope is more than this variable, +max_paginates_per+ is used instead of it. Default value is nil, which means you are not imposing any max +per_page+ value.
    class User < ActiveRecord::Base
      max_paginates_per 100
    end

=== Controllers

* the page parameter is in <tt>params[:page]</tt>

  Typically, your controller code will look like this:
    @users = User.order(:name).page params[:page]

=== Views

* the same old helper method

  Just call the +paginate+ helper:
    <%= paginate @users %>

  This will render several <tt>?page=N</tt> pagination links surrounded by an HTML5 <+nav+> tag.

=== Helpers

* the +paginate+ helper method

    <%= paginate @users %>
  This would output several pagination links such as <tt>« First ‹ Prev ... 2 3 4 5 6 7 8 9 10 ... Next › Last »</tt>

* specifying the "inner window" size (4 by default)

    <%= paginate @users, :window => 2 %>
  This would output something like <tt>... 5 6 7 8 9 ...</tt> when 7 is the current page.

* specifying the "outer window" size (0 by default)

    <%= paginate @users, :outer_window => 3 %>
  This would output something like <tt>1 2 3 4 ...(snip)... 17 18 19 20</tt> while having 20 pages in total.

* outer window can be separately specified by +left+, +right+ (0 by default)

    <%= paginate @users, :left => 1, :right => 3 %>
  This would output something like <tt>1 ...(snip)... 18 19 20</tt> while having 20 pages in total.

* changing the parameter name (:+param_name+) for the links

    <%= paginate @users, :param_name => :pagina %>
  This would modify the query parameter name on each links.

* extra parameters (:+params+) for the links

    <%= paginate @users, :params => {:controller => 'foo', :action => 'bar'} %>
  This would modify each link's +url_option+. :+controller+ and :+action+ might be the keys in common.

* Ajax links (crazy simple, but works perfectly!)

    <%= paginate @users, :remote => true %>
  This would add <tt>data-remote="true"</tt> to all the links inside.

* the +link_to_next_page+ and +link_to_previous_page+ helper method

    <%= link_to_next_page @items, 'Next Page' %>
  This simply renders a link to the next page. This would be helpful for creating a Twitter-like pagination feature.

* the +page_entries_info+ helper method

    <%= page_entries_info @users %>
  This renders a helpful message with numbers of displayed vs. total entries.

=== I18n and labels

The default labels for 'first', 'last', 'previous', '...' and 'next' are stored in the I18n yaml inside the engine, and rendered through I18n API. You can switch the label value per I18n.locale for your internationalized application.
Keys and the default values are the following. You can override them by adding to a YAML file in your <tt>Rails.root/config/locales</tt> directory.

  en:
    views:
      pagination:
        first: "&laquo; First"
        last: "Last &raquo;"
        previous: "&lsaquo; Prev"
        next: "Next &rsaquo;"
        truncate: "..."

=== Customizing the pagination helper

Kaminari includes a handy template generator.

* to edit your paginator

  Run the generator first,
    % rails g kaminari:views default

  then edit the partials in your app's <tt>app/views/kaminari/</tt> directory.

* for Haml users

  Haml templates generator is also available by adding the <tt>-e haml</tt> option (this is automatically invoked when the default template_engine is set to Haml).

    % rails g kaminari:views default -e haml

* themes

  The generator has the ability to fetch several sample template themes from
  the external repository (https://github.com/amatsuda/kaminari_themes) in 
  addition to the bundled "default" one, which will help you creating a nice
  looking paginator.
    % rails g kaminari:views THEME

  To see the full list of avaliable themes, take a look at the themes repository,
  or just hit the generator without specifying +THEME+ argument.
    % rails g kaminari:views

* multiple themes

  To utilize multiple themes from within a single application, create a directory within the app/views/kaminari/ and move your custom template files into that directory.
    % rails g kaminari:views default (skip if you have existing kaminari views)
    % cd app/views/kaminari
    % mkdir my_custom_theme
    % cp _*.html.* my_custom_theme/

  Next, reference that directory when calling the +paginate+ method:

    <%= paginate @users, :theme => 'my_custom_theme' %>

  Customize away!

  Note: if the theme isn't present or none is specified, kaminari will default back to the views included within the gem.

=== Paginating a generic Array object

Kaminari provides an Array wrapper class that adapts a generic Array object to the <tt>paginate</tt> view helper.
However, the <tt>paginate</tt> helper doesn't automatically handle your Array object (this is intentional and by design).
<tt>Kaminari::paginate_array</tt> method converts your Array object into a paginatable Array that accepts <tt>page</tt> method.
  Kaminari.paginate_array(my_array_object).page(params[:page]).per(10)

You can specify the +total_count+ value through options Hash. This would be helpful when handling an Array-ish object that has a different +count+ value from actual +count+ such as RSolr search result or when you need to generate a custom pagination. For example:
  Kaminari.paginate_array([], total_count: 145).page(params[:page]).per(10)

== Creating friendly URLs and caching

Because of the +page+ parameter and Rails 3 routing, you can easily generate SEO and user-friendly URLs. For any resource you'd like to paginate, just add the following to your +routes.rb+:

    resources :my_resources do
      get 'page/:page', :action => :index, :on => :collection
    end

This will create URLs like <tt>/my_resources/page/33</tt> instead of <tt>/my_resources?page=33</tt>. This is now a friendly URL, but it also has other added benefits...

Because the +page+ parameter is now a URL segment, we can leverage on Rails page caching[http://guides.rubyonrails.org/caching_with_rails.html#page-caching]!

NOTE: In this example, I've pointed the route to my <tt>:index</tt> action. You may have defined a custom pagination action in your controller - you should point <tt>:action => :your_custom_action</tt> instead.


== Sinatra/Padrino support

Since version 0.13.0, kaminari started to support Sinatra or Sinatra-based frameworks experimentally.

To use kaminari and its helpers with these frameworks,

    require 'kaminari/sinatra'

or edit gemfile:

    gem 'kaminari', :require => 'kaminari/sinatra'

More features are coming, and again, this is still experimental. Please let us know if you found anything wrong with the Sinatra support.


== For more information

Check out Kaminari recipes on the GitHub Wiki for more advanced tips and techniques.
https://github.com/amatsuda/kaminari/wiki/Kaminari-recipes


== Build Status {<img src="https://secure.travis-ci.org/amatsuda/kaminari.png"/>}[http://travis-ci.org/amatsuda/kaminari]


== Questions, Feedback

Feel free to message me on Github (amatsuda) or Twitter (@a_matsuda)  ☇☇☇  :)


== Contributing to Kaminari

* Fork, fix, then send me a pull request.


== Copyright

Copyright (c) 2011 Akira Matsuda. See MIT-LICENSE for further details.


----------------------------------------------------------------------

# will_paginate

will_paginate is a pagination library that integrates with Ruby on Rails, Sinatra, Merb, DataMapper and Sequel.

Installation:

``` ruby
## Gemfile for Rails 3, Sinatra, and Merb
gem 'will_paginate', '~> 3.0'
```

See [installation instructions][install] on the wiki for more info.


## Basic will_paginate use

``` ruby
## perform a paginated query:
@posts = Post.paginate(:page => params[:page])

# or, use an explicit "per page" limit:
Post.paginate(:page => params[:page], :per_page => 30)

## render page links in the view:
<%= will_paginate @posts %>
```

And that's it! You're done. You just need to add some CSS styles to [make those pagination links prettier][css].

You can customize the default "per_page" value:

``` ruby
# for the Post model
class Post
  self.per_page = 10
end

# set per_page globally
WillPaginate.per_page = 10
```

New in Active Record 3:

``` ruby
# paginate in Active Record now returns a Relation
Post.where(:published => true).paginate(:page => params[:page]).order('id DESC')

# the new, shorter page() method
Post.page(params[:page]).order('created_at DESC')
```

See [the wiki][wiki] for more documentation. [Ask on the group][group] if you have usage questions. [Report bugs][issues] on GitHub.

Happy paginating.


[wiki]: https://github.com/mislav/will_paginate/wiki
[install]: https://github.com/mislav/will_paginate/wiki/Installation "will_paginate installation"
[group]: http://groups.google.com/group/will_paginate "will_paginate discussion and support group"
[issues]: https://github.com/mislav/will_paginate/issues
[css]: http://mislav.uniqpath.com/will_paginate/


----------

https://github.com/mislav/will_paginate/blob/master/lib/will_paginate/active_record.rb
https://github.com/mislav/will_paginate/blob/master/lib/will_paginate/array.rb
https://github.com/mislav/will_paginate/blob/master/lib/will_paginate/collection.rb

    # This is a magic wrapper for the original Array#replace method. It serves
    # for populating the paginated collection after initialization.
    #
    # Why magic? Because it tries to guess the total number of entries judging
    # by the size of given array. If it is shorter than +per_page+ limit, then we
    # know we're on the last page. This trick is very useful for avoiding
    # unnecessary hits to the database to do the counting after we fetched the
    # data for the current page.
    #
    # However, after using +replace+ you should always test the value of
    # +total_entries+ and set it to a proper value if it's +nil+. See the example
    # in +create+.
    def replace(array)
      result = super
      
      # The collection is shorter then page limit? Rejoice, because
      # then we know that we are on the last page!
      if total_entries.nil? and length < per_page and (current_page == 1 or length > 0)
        self.total_entries = offset + length
      end

      result
    end

----------------------------------------------------------------------


@products = Product.order("name").page(params[:page]).per(5)

https://github.com/amatsuda/kaminari/wiki/Kaminari-recipes

# AR::Base#all is not a scope!
User.all.page 2
#=> NoMethodError: undefined method `page' for #<Array:0x1017a9e80>

# How do I paginate an Array?

Kaminari provides an Array wrapper class that adapts a generic Array object to the paginate view helper.

Kaminari.paginate_array(my_array_object).page(params[:page]).per(10)

For more information on this, you may want to look at the "Paginating a generic Array object" section of https://github.com/amatsuda/kaminari/blob/master/README.rdoc

 Paginating a generic Array object

Kaminari provides an Array wrapper class that adapts a generic Array object to the paginate view helper. However, the paginate helper doesn’t automatically handle your Array object (this is intentional and by design). Kaminari::paginate_array method converts your Array object into a paginatable Array that accepts page method.

Kaminari.paginate_array(my_array_object).page(params[:page]).per(10)

You can specify the total_count value through options Hash. This would be helpful when handling an Array-ish object that has a different count value from actual count such as RSolr search result or when you need to generate a custom pagination. For example:

Kaminari.paginate_array([], total_count: 145).page(params[:page]).per(10)

Keep in mind though that it is fairly easy to paginate an array in Ruby without using Kaminari.

arr = (1..100).to_a
page, per_page = 1, 10
arr[((page - 1) * per_page)...(page * per_page)] #=> [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
page, per_page = 2, 10
arr[((page - 1) * per_page)...(page * per_page)] #=> [11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

Who needs a special gem or plugin just for doing this?

But I still want to paginate an Array by any means. How can I render the paginator?

Ok, you are using Ruby... something like this would do the work. Perhaps...

    @users = User.order(:created_at).page(params[:page]).all
    @users.instance_eval <<-EVAL
      def current_page
        #{params[:page] || 1}
      end
      def num_pages
        count
      end
      def limit_value                                                                               
        20
      end
EVAL

I'm not promising that this should work, but I'm just pointing out that you don't have to implement AbstractFactoryFactoryInterfaces to make it act like a paginatable collection.

# TODO: 
class Book < ActiveRecord::Base
  default_scope order('published_at')
end

----------------------------------------------------------------------

https://github.com/amatsuda/kaminari
https://github.com/mislav/will_paginate

----------------------------------------------------------------------
