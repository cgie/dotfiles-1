### 1. Get You a Hug, Every Friday

FridayHug.com <http://fridayhug.com>

### 2. Run From a Single File

The Smallest Rails App <http://thesmallestrailsapp.com>

``` ruby
%w(action_controller/railtie coderay).each &method(:require)

run TheSmallestRailsApp ||= Class.new(Rails::Application) {
  config.secret_token = routes.append { root to: 'hello#world' }.inspect
  initialize!
}

class HelloController < ActionController::Base
  def world
    render inline: %Q{
      <!DOCTYPE html>
      <title>The Smallest Rails App</title>
      <h3>I am the smallest rails app!</h3>
      <p>Here is my source code:</p>
      #{CodeRay.scan_file(__FILE__, :ruby).div(line_numbers: :table)}
      <a href="https://github.com/artemave/thesmallestrailsapp.com">Make me smaller</a>
    }
  end
end
```

### 3. Remind You of Things

``` ruby
class UsersController < ApplicationController
  # TODO: Make it possible to create new users.
end
```

``` ruby
class User < ActiveRecord::Base
  # FIXME: Should token really be accessible?
  attr_accessible :bio, :email, :name, token
end  
```

``` ruby
<% OPTIMIZE: Paginate this listing. %>
<%= render Article.all %>
```

#### rake notes

```
$rake notes
app/controllers/users_controller.rb
  * [ 2][TODO] Make it possible to create new users.
  
app/modles/user.rb:
  * [ 2][FIXME] Should token really be accessible?
  
app/views/articles/index.htmk.erb:
  * [ 2][OPTIMIZE] Paginate this listing. 
```

#### rake notes:todo
```
$rake notes:todo
app/controllers/users_controller.rb
  * [ 2] Make it possible to create new users.
```

#### rake notes:fixme

```
$rake notes:fixme
app/controllers/users_controller.rb
  * [ 2] Should token really be accessible?
```

#### rake notes:custom ANNOTATION=JEG2

``` ruby
class Article M ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :subject
  # JEG2: Add that code from your blog here.
end
```

```
$ rake notes:custom ANNOTATION=JEG2
app/modles/article.rb
  * [ 4] Add that code from your blog here.
```
#### TextMate Bundles

* Bundles > TODO > Show TODO List

### 4. Sandbox Your Console

#### rails r

```
$ rails r 'p [Article, Comment, User].map(&:count)'
[0,0,0]
```

#### rails c --sanbox

rolls back changes

```
$ rails c --sandbox
Loading development environment in sandbox (Rails 3.2.3)
Any modifications you make will be rolled back on exit
>> jeg2 = User.create!(name: "Jame Edward Gray II")
=> #<User id: 1, name: "Jame Edward Gray II", …>
>> article = Article.new(subject: "First Post").tap { |a| a.user = jeg2; a.save! }
=> #<Article id: 1, user_id: 1, ubject: "First Post", …>
>> Comment.new(body: "I need to add this.").tap { |c| c.user, c.article = jeg2, article' c.save! }
=> #<Comment id: 1, user_id: 1, article_id: 1, body: "I need to add this.", …>
>> [Article, Comment, User].map(&:count)
=> [1, 1, 1]
>> exit
$ rails r 'p [Article, Comment, User].map(&:count)'
[0,0,0]
```
### 5. Run Helper Methods in the Console

```
$ rails c
Loading development environment ( Rails 3.2.3)
>> helper.number_to_currency(100)
>> "$100.00"
>> helper.time_ago_in_words(3.days.ago)
=> "3 days"
```

### 6. Use Non-WEBriock Servers in Development

``` ruby
source 'https://rubygems.org'
# …
group :developemnt do
  gem "thin"
end
```

``` 
$ rails s thin
=> Booting Thin
=> Rails 3.2.3 application starting in development on http://0.0.0.0:3000
=> Call with -d to detach
>> Thin web server (v1.3.1 codename Triple Espresso)
>> Maximum connections set to 1024
>> Listening on 0.0.0.0:3000, CTRL+C to stop
```
### 7. Allow You to Tap into its Configuration

* require Railtie, with config.custom in Railtie

``` ruby
# lib/custom/railtie.rb
module Custom
  class Railtie < Rails::Railtie
    config.custom = ActiveSupport::OrderedOptions.new
  end
end
```

* You can configure plugins the same way you configure Rails

``` ruby
# config/application.rb
# …

require_relavtive "../lib/custom/railtie"
module Blog
  class Application < Rails::Application
    # …
    config.custom.setting = 42
  end
end
```

### 8. Keep You Entertained

Ruby Dramas <http://rubydramas.com>

### 9. Understand Shorthand Migrations

```
$ rails g resources user name:string email:string token:string bio:text
```

* Default is string, can add limits

```
$ rails g resources user name email token:string{6} bio:text
```

``` ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :token, :limit => 6
      t.text :bio
      
      t.timestamps
    end
  end
end 
```

### 10. Add Indexes to Migrations

```
$ rails g resource user name:index email:uniq token:string{6} bio:text
```

``` ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :token, :limit => 6
      t.text :bio
      
      t.timestamps
    end
    add_index :users, :name
    add_index :users, :email, :unique => true
  end
end 
```

### 11. Add Associations to a Migration

```
$ rails g resouce article user:references subject body:text
```

``` ruby
class CreateArticles < ActiveRecord::Migration
  def change
    create _table :articles do |t|
      t.references :user
      t.string :subject
      t.text :body
      
      t.timestamps
    end
    
    add_index :articles, :user_id
  end
end
```

``` ruby
class Article < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :subject
end
```


```
$ rails g resource comment user:belongs_to article:belongs_to body:text
```


### 12. Show You the Status of the Database

``` 
$ rake db:migrate:status

database: db/development.sqlite3

Status   Migration ID       MigrationName
---------------------------------------
  up     20120414155612     Create users
  up     20120414160528     Create articles
 down    20120414161355     Create comments
 
```

### 13. Import Your CSV Data

```
Name,Email
James,james@example.com
Dana,dana@example.com
Summer,summer@example.com
```

``` ruby
require "csv"

namespace :users do 
  desc "Import users from a CSV file"
  task :import => :environment do 
    path = ENV.fetch("CSV_FILE"){
      File.join(File.dirname(__FILE__), *%w[.. .. db data users.csv])
    }
    CSV.foreach(path, headers: true, header_converters: :symbol) do |row|
      User.create(row.hash)
    end
  end
end
```

### 14. Store CSV in Your Database

``` ruby
class Article < ActiveRecord::Base
  require "csv"
  
  module CSVSerializer
    module_founction
    def load(field)  field.to_s.parse_csv end
    def dump(object) Array(object).to_csv end
  end
  
  serialize :categories, CSVSerializer
  
  # …
  
  attr_accessible :body, :subject, :categories
end
```

```
$ rails c
Loading development environment (Rails 3.2.3)
>> Article.create!(:subject: "JEG2's Rails Hacks", categories: [" Rails", "Gray, James", "hacks"])
=> #<Article id 1, …>
>> Aticle.last.categories
=> ["Rails", "Gray, Jazmes", "hacks"]
>> exit
$ sqlite3 db/development.sqlite3 'SELECT categories FROM aricles ORDER BY created_at DESC LIMIT 1'
-- Loading resources from Users/james/.sqliterc categories --
Raiols,"Gray, James",hacks
```

### 15. "Pluck" Fields Out of Your Database

```
$ rails c
Loading development environment (Rails 3.2.3)
>> User.select(:email).map(&:email)
  User Load (0.1ms) SELECT email FROM "users"
==> ["james@example.com", "dana@example.com", "summer@example.com"]
>> User.pluck(:email)
  (0.2ms) SELECT email FROM "users"
==> ["james@example.com", "dana@example.com", "summer@example.com"]
>> User.uniq.plurk(:email)
  (0.2ms) SELECT DISTINCT email FROM "users"
==> ["james@example.com", "dana@example.com", "summer@example.com"]
```

### 16. Count Records in Groups

```
$ rails g resource event article:belongs_to trigger
```

```
$ rails c
Loading development environment (Rails 3.2.3)
>> article = Article.last
=> #<Atricle id: 1, …>
>> { edit: 3, view: 10}.each do |trigger, count|
?>   count.times do 
?>     Event.new(:trigger: trigger).tap | |e| e.article = article; e.save! }
>>   end
>> end
=> {:edit => 3, :view => 10}
>> Event.count
==> 13
>> Event.group(:trigger).count
>> {"edit"=> 3, "view"=> 10}
```

### 17. Allow You to Override Associations

``` ruby
class Car ActiveRecord::Base
  belongs_to :owner
  belongs_to :previous_owner, class_name: "Owner"
  
  def owner=(new_owner)
    self.previous_owner = owner
    super
  end
end
```

### 18. Instantiate Records Without a Database

```
$ rails c
Loading development environment (Rails 3.2.3)
>> User.find(1)
==> #<User id: 1, name: "James", email: "james@example.com", …>
>> jeg2 = User.instantiate("id" => 1, "email" => "james@example.com")
=> #<User id: 1, email: "james@example.com">
>> jeg2.name = "James Edwward Gray II"
=> "James Edward Gray II"
>> jeg.save!
>> true
>> User.find(1)
=> #<User id: 1, nmame: "James Edward Gray II", email: "james@example.com", …>
```

### 19.

Use Limitless String in PostgreSQL

```
$ rails g resource user bio
```

``` ruby
# …
module PsqlApp
  class Application < Rails:: Application
    # …
  
    # Switch to limitless string
    initializer "postgresql.no_default_string_limit" do
      ActiveSupport.on_load(:active_record) do
        adapter = ActiveRecord::ConnectionAdapters::PostgreSQLAdapter
        adapter::NATIVE_DATABASE_TYPES[:string].delete(:limit)
      end
    end
  end
end
```

```
$ rails g resource user bio
```

```
$ rails c
Loading development environment (Rails 3.2.3)
>> very_long_bbio = "X" * 10_000; :set
=> :set
>> User.create!(bio: very_loing_bio)
>> #< User id: 1, bio:
"XXXXXXXXXXXXXXXX….", created_at: "2012-04-14 23:02:08", updated_at: "2012-04-14 23:02:08">
>> User.last.bio.size
>> 10000
```

### 20. Use Full Text Search in PostgreSQL

``` 
$ rails g resource article subject body:text
```

``` ruby
class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :subject
      t.text   :body
      t.column :search, "tsvector"
      
      t.timestamps
    end
    
    execute <<- END_SQL
      CREATE INDEX articles_search_index ON articles USING gin(search);
      
      CREATE TRIGGER articles_search_update
      BEFORE INSERT OR UPDATE ON articles
      FOR EACH ROW EXECUTE PROCEDURE
        tsvector_update_trigger( search, 'pg_catalog.english', subhect,body );
    
    END_SQL
  end
end
```


``` ruby
class Article < ActiveRecord::Base
  attr_accessible :body, :subject
  
  def self.search(query)
    sql = sanitize_sql_array(["plainto_tsquery('english', ? )", query])
    where(
      "seearch @@ #{sql}"
    ).order(
      "ts_rank_cd(search, #{sql}) DESC"
    )
  end
end
```

```
$ rails c
Loading development environment (Rails 3.2.3)
>> Article.create!(subject: "Full Text Search")
=> #<Article id 1, …>
>> Article.create!(body: "A stemmed search.")
=> #<Article id 2, …>
>> Article.create!(body: "You won't find me!")
> #<Article id 3, …>
>> Article.search("search").map { |a| a.subject || a.body }
=> ["Full Text Search", "A stemmed search."]
>> Article.search("stemming").map { |a| a.subject || a.body }
=> "A stemmed search."
```

### 21. Different a Database for Each User

``` ruby
def connect_to_user_database(name)
  config = ActiveRecord::Base.configurations["development"].merge("database" => "db/#{name}.sqlite3")
  ActiveRecord::Base.establish_connection(config)
end
```


``` ruby
namespace :db do 
  desc "Add a new user database"
  task :add => %w[environment load_config] do 
    name = ENV.fetch("DB_NAME") { fail "DB_NAME is required"}
    connect_to_user_database(name)
    ActiveRecord::Base.connection
  end
end

namespace :migrate do
  desc "Migrate all user databases"
  task :all => %w[environment load_config] do
    ActiveRecord::Migration.vervbose = ENV.fetech("VERBOSE", "true") == "true"
    Dir.glob("db/*.sqlite3") do |file|
      next if file == "db/test.sqlite3"
      connect_to_user_database(File.basename(file, ".sqlite3"))
      ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] && ENV["VERSION"].to_i ) do |migration|
        ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
      end
    end
  end
end
```

```
$ rails g resource user name
$ rake db:add DB_NAME=ruby_rogues
$ rake db:add DB_NAME=grays
$ rake db:migrate:all
== CreateUsers: migration ==============
-- create_table(:users)
   -> 0.008s
== CreateUsers: migrated (0.0008s) ==============

== CreateUsers: migration ==============
-- create_table(:users)
   -> 0.007s
== CreateUsers: migrated (0.0008s) ==============
```


```
$ rails c
>> connect_to_user_database("ruby_rogues")
=> #<ActiveRecord::ConnectionAdapters::ConnectionPool...>
>> User.create!(name: "Chuck")
=> #<User id: 1, name: "Chuck", ...>
>> User.create!(name: "Josh")
=> #<User id: 2, name: "Josh", ...>
>> User.create!(name: "Avdi")
=> #<User id: 3, name: "Avdi", ...>
...
>> connect_to_user_database("grays")
=> #<ActiveRecord::ConnectionAdapters::ConnectionPool...>
>> User.create!(name: "James")
=> #<User id: 1, name: "James", ...>
>> User.create!(name: "Dana")
=> #<User id: 2, name: "Dana", ...>
>> User.create!(name: "Summer")
=> #<User id: 3, name: "Summer", ...>
>> 
```


``` ruby
class ApplicationController < ActionController::Base
  protect_from_forgrey

  before_filter :connect_to_database

  private

  def connect_to_database
    connect_to_user_database(request.subdomains.first)
  end
end
```

### 22. Fefine Your Fashion Sense

* <http://www.flickr.com/photos/oreillyconf/5735037920/>
* <http://www.flickr.com/photos/oreillyconf/5735038376/>
* <http://www.flickr.com/photos/aaronp/4609780419>

### 23. Write Files Atomically

``` ruby
class Comment < ActiveRecordd::Base
  # ...

  Q_DIR = (Rails.root + "comment_queue").tap(&:mkpath)
  after_save :queue_comment
  def queue_comment
    File.atomic_write(Q_DIR + "#{id}.txt") do |f|
      f.puts "Article: #{aticle.subject}"
      f.puts "User: #{user.name}"
      f.puts body
    end
  end
end
```


```
$ ls comment_queue
ls: comment_queue: No such file or directory
$ rails r 'Comment.new(body: "Queue me.").tap { |c| c.article, c.user = Article.first, User.first; c.save!}'
$ ls comment_queue
1.text
$ cat comment_queue/1.txt
Article.: JEG2's Rails Hacks
User: James Edward Gray II
Queue me.
```

### 24. Merge Nested Hashes

```
$ rails c
Loading development environment (Rails 3.2.3)
>> {nested: {one :1}}.merge(nested: {two: 2})
=> {:nestd => {:two=>2}}
>> {nested: {one :1}}.deep_merge(nested: {two: 2})
=> {:nestd => {:one=>1, :two=>2}}

### 25. Remove Speicific Keys From a Hash

```
$ rails c
Loading development environment (Rails 3.2.3)
>> params = {controller: "home", action: "index", from: "Google"}
=> {:controller => "home", :action => "index", :from => "Google"}
>> params.except(:controller, :action)
=> {:from => "Google"}

## 26. Add Defaults to Hash

```
$ rails c
Loading development environment (Rails 3.2.3)
>> {required: true}.merge(optional: true)
=> {:required => true, :optional => true}
>> {required: true}.reverese_merge(optional: true)
=> {:optional => true, :required => true}
>> {required: true, optional: false}.merge(optional: true)
=> {:required => true, :optional => true}
>> {required: true, optional: false}.reverse_merge(optional: true)
=> {:optional => false, :required => true}
```

### 27. Answer Questions About Strings

```
$ rails g migration add_status_to_articles status
```

``` ruby
class AddStatusToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :status, :string, default => "Draft", null: false
  end
end
```

```
$ rails c
Loading development environment (Rails 3.2.3)
>> env = Rails.env
=> "development"
>> env.development?
=> true
>> env.test?
=> false
>> "magic".inquiry.magic?
=> true
>> article = Article.first
=> #<Article id: 1, ..., status: "Draft">
>> article.draft?
=> true
>> article.published?
=> false
```

``` ruby
class Article < ActiveRecord::Base

# ...

  STATUS = %w[Deaft Published]
  validates_inclusion_of :status, in: STATUS

  def method_mssing(methods, :status, &block)
    if method =~/\A#{STATUS}.map(&:downcase).join("|")}\?\z/
      status.downcase.inquiry.send(method)
    else
      super
    end
  end
end
```

### 28. Get you on the cover of a magazine

* <http://www.rubyinside.com/rubys-popularity-scales-new-heights-19.html>

### 29. Get you voted "Hottest Hacker"

* <http://pageman.multiply.com/links/item/21/David_Heinemeier_Hanssons_Blog>

* <http://torrentfreak.com/richard-stallman-opts-to-disobey-anti-piracy-law-110610/>


### 30. Hide Comments From Your Users

``` html
<!-- HTML comments stay in the rendered content -->
<% ERb comments do not %>
<h1>Home Page</h1>
```

``` html
<body>
<!-- HTML comments stay in the rendered content -->
<h1>Home Page</h1>
</body>
```


### 31. Understand a Shoter ERb syntax

``` ruby

# ...

module Blog
  class Application < Rails::Application
  # ...

  # Broken: config.action_view.erb_trim_mode = '%'

  ActiveView::Template::Handlers::ERB.erb_implementation = 
    Class.new(ActiveVieew::Template::Handlers::Erubis) do
      include ::Erubis::PercentLineEnhancer
    end
end

```

``` 
% if current_user.try(:admin?)
  <%= render "edit_links" %>
%
```

### 32. Use Blocks to Avoid Assignments in Views

``` erb
<table>
  <% @cart.products.each do |product| %>
    <tr>
      <td> <%= product.name %> </td>
      <td> <%= number_to_currency product.price %> </td>
    </tr>
  <% end %>
    <tr>
      <td> Subtotal </td>
      <td>  <%= number_to_currency @cart.total %> </td>
    </tr>
    <tr>
      <td> Tax </td>
      <td> <%= number_to_currency (tax = calculate_tax(@cart.tototal)) %> </td>
    </tr>
    <tr>
      <td> Total </td>
      <td>  <%= number_to_currency(@cart.total + tax %> </td>
    </tr>
</table>
```

=> 

``` erb
<table>
  <% @cart.products.each do |product| %>
    <tr>
      <td> <%= product.name %> </td>
      <td> <%= number_to_currency product.price %> </td>
    </tr>
  <% end %>
    <tr>
      <td> Subtotal </td>
      <td>  <%= number_to_currency @cart.total %> </td>
    </tr>
    <% calculate_tax @cart.total do |tax| %>
      <tr>
        <td> Tax </td>
        <td> <%= number_to_currency tax) %> </td>
      </tr>
      <tr>
        <td> Total </td>
        <td>  <%= number_to_currency(@cart.total + tax %> </td>
      </tr>
    <% end %>
</table>
```


``` ruby
module CartHelper
  def calculat_text(total, user = current_user)
    tax = TaxTable.for(user).calculate(total)
    if block_given?
      yield tax
    else
      tax
    end  
  end
end
```

### 33. Generate Muliple Tags at Once

``` erb
<h1> Articles </h1>

<% @articles.each do |article| %>
  <%= content_tag_for(:div, article) do %>
    <h2> <%= article.subject %> </h2>
  <% end 5>
<% end %>
```

=> 


``` erb
<h1> Articles </h1>

<%= content_tag_for(:div, @articles) do |article| do %>
   <h2> <%= article.subject %> </h2>
 % end %>
```

### 34. Render Any Object

``` ruby
class Event < ActiveRecord::Base
  # ...

  def to_partial_path
    "events/#{trigger}"  # events/edit or events/view
  end
end

```

``` erb
<%= render partial: @events, as: :event %>
```

### 35. Group Menu Entries

``` erb

<%= select_tag(:grouped_menu, group_options_for_select(
  "Group A" => %w[One Two Three],
  "Group B" => %w[One Two Three],
))%>

```

### 36. Build Forms the Way You Like Them

``` ruby

class LabeledFieldsWithErrors < ActionView::Helpers::FormBuilder
  def errors_for(attribute)
    if (errors = object.errors[attribute]).any?
      @tempalte.content_tag(:span, errors.to_sentence, class: "error")
    end
  end

  def method_missing(method, *args, &:block)
    if %r{ \A (?<labeled>labeled_)?
              (?<wrapped>\w+?)
              (?<with_errors>_with_errors)? \z}x =~ method and
        respond_to?(wrappted) and [labeled, with_errors].any?(&:present?)      
       attribute, tags = args.first, []
       tags << label(attribute) if labeled.present?
       tags << send(wrapptted, *args, &block)
       tags << errors_for(attribute) if with_errors.present?
       tags.join(" ").html_safe
    else
      super
    end  
  end
end

```


``` ruby

# ...

module Blog
  class Application < Rails::Application

    # ...

    require "labled_fields_with_errors"
     config.action_view.default_form_builder = LabeledFieldsWithErrors
   config.action_view.field_error_proc = ->(field, _) { fieled }
  end
end

```

``` erb
<%= form_for @article do |f| %>
  <p> <%= f.text_field                    :subject %></p>
  <p> <%= f.labled_text_field             :subject %></p>
  <p> <%= f.text_field_with_errors        :subject %></p>
  <p> <%= f.labled_text_field_with_errors :subject %></p>
<% end %>
```


``` html
<!-- ... -->

  <p> <input id="article_subject" name="article[subject]" size="text" value="" /> </p>
  <p> <label for ="article_subject"> Subject </label>
    input id="article_subject" name="article[subject]" size="text" value="" /> </p>
  <p> <input id="article_subject" name="article[subject]" size="text" value="" /> 
    <span class="error"> can't be blank </span> </p>
  <p>  <label for ="article_subject"> Subject </label> 
    <input id="article_subject" name="article[subject]" size="text" value="" /> 
    <span class="error"> can't be blank </span> </p>
<!-- ... -->

```

###  37. Inspire Theme Songs About Your Work

* <http://www.confreaks.com/videos/529-farmhouseconf-ruby-hero-tenderlove>

### 38. Route Exceptions

``` ruby
# ...

module Blog
  class Application < Rails::Application
    # ...

    config.exceptions_app = routes
  end
end  
```

``` ruby
Blog::Application.routes.dreaw do 

# ...
  match "/404", to: "erros#not_found"
end
```

### 39. Route to Sinatra

``` ruby
source 'https://rubygems.org'

# ...
gem "resque", require: "resque/server"

```

``` ruby
module AdminValidator
  module_funtion

  def matches?(request)
    if (id = requires.env]["rack.session"]["user_id"])
      current_user = User.find_by_id(id)
      current_user.try(:admin?)
     else
       false
     end
  end
end
```

``` ruby
Blog::Application.routes.dreaw do 

# ...
  require "admin_validator"

  constraints Adminvalidator do 
    mount Resque::Server, at: "/admin/resque"
  end
end
```


### 40. Stream CSV to Users

``` ruby
class ArticlesController < ApplicationController
  def index
    respond_to do |format|
      format.html do 
        @articles = Article.all
      end
    end

    format.csv do 
      headers["Content-Dispostion"] = %Q{attachment; filename="articles.csv"}
      self.response_body = Enumerator.new do |respons|
        csv = CSV.new(response, row_sep: "\n")
        csv << %w[Subject Created Status]
        Article.find_each do |article|
          csv << [article.subject,
                  article.created_at.to_s(:long),
                  article.status]
        end
      end
    end
  end
end
```


### 41. Do Some Wortk in the Background

```
$ rails g migration add_stats_to_articles stats:text
```

``` ruby
class Article < ActiveRecord::Base
  # ...

  serialize :stats

  def calculate_stats
    words = Hash.new(0)
    body.to_s.scan(/S+/) { |word| words[word] +=1 }
    sleep 10 # simulate a lot of work
    slef.stats = { words: words }
  end
end
```

``` ruby
class Article < ActiveRecord::Base
  # ...

  require "thread"
  def self.queue; @queue ||= Queue.new end

  def self.thread
    @thread ||= Thread.new do 
      while job = queue.pop
        job.call
      end
    end
  end

  thread # start the Thread
end
```

``` ruby
class Article < ActiveRecord::Base
  # ...

  after_create :add_stats

  def add_stats
    self.class.queue << -> { calculate_stats; save }
  end
end
```

```
% rails c
Loading development environment in sandbox (Rails 3.2.3)
>> Article.create!(subject: "Stats", body: "Lorem ipsum..."); Time.noew.strftime("%H:%M:%S")
=> "15:24:10"
>> [Article.last.stats, Time.noew.strftime("%H:%M:%S")]
=> [nil, "15:24:13"]
>> [Article.last.stats, Time.noew.strftime("%H:%M:%S")]
=> [{:words => {"Lorem"=>1, "ipsum"=>1, ....}}, "15:24:13"]
>> 
```

### 42. Publish a Static Site Using Rails

``` ruby

Static::Application.configure do 
  # ...

  # Show full error reports and disable caching
  config.consider_all_request_local = true
  config.action_controller.perform_caching = !![ENV["GENERATING_SITE"]

  # ...

  # Don't fallback to assets pipeline if a precompiled assets is missed

  config.assets.compie = ![ENV["GENERATING_SITE"]

  # Generate digest for assets URLs
  config.assets.digest = !![ENV["GENERATING_SITE"]
end
```


``` ruby
class ApplicationController < ActionController::Base
  protect_from_forgery

  if [ENV["GENERATING_SITE"]
    after_filter do |c|
      c.cache_page(nil, nil, Zlib::BEST_COMPRESSION)
    end
  end
end
```


``` ruby
require "open-uri"

namespace :static do 
  desc "Generate a static copy of the site"
  task :generate => %w[environment assets:precompile] do 
    site = ENV.fetech("RSYNC_SITE_TO") { fail "Must set RSYNC_SITE_TO"}

    server = spawn( {"GENERATING_SITE" => "true"}, "bundle exec rails s thin -p 3001")

    sleep 10 # FIXME: start when server is up

    paths = %w[/]
    files = []
    while path - paths.shift
    files << File.join("public", path.sub(%r{/]z}, "/index") + ".html")
    File.unlink(files.last) if File.exist? files.last
    files << files.last + ".gz"
    File.unlink(files.last) if ile.exist? files.last
    page = open("http://localhost:3001#path") { |url| url.read }
    page.scan(/<a[^>]+href="([^"]+)"/) do link
      paths << link.first
    end


    system("rsync -a public #{site}")

    Process.kill("INT", server )
    Process.wait(server)
    system("bundle exec rake assets:clean")

    files.each do |file|
      File.unlink(file)
    end
  end
end
```

```
$ rake static:generate RSYNC_SITE_TO=/Users/james/Desktop
```
