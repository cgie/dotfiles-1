
# Getting Started with Chef Solo.

> author: Alexey Vasiliev

> twitter: @leopard_me

All example code you can find here: https://github.com/le0pard/chef-solo-example/tree/1.0

## What is Chef?

> Chef

Chef is an open-source systems integration framework built specifically for automating the cloud.

### Why you should use Chef?

- Efficiency: It’s more effective to use Chef, which will contain all your servers configuration in one place.
- Scalability: Do you need scale you app? Split your server into cloud (several servers) by using environments, roles and nodes.
- Reusing and Save money: No need 10 times install a same software for your application on server. Just create new node in Chef and after several minutes you will have configured instance.
- Documentation: You Chef is also documentation for your cloud, because Chef recipes contain all information about your environment.

> Automate All The Things

And of course main point is Automate All The Things!!!

### What doesn’t Chef do?

- “Magically” configure your server
- Blindly reuse cookbooks and recipes
- Monitor your servers or softwares
- Undoing concept

## Chef types and terminology

Exists two types of Chef: Chef Solo and Chef Server. Chef Solo is simple way to begin working with Chef what is why I will show how to use it in articles.

This is list of terminology, which I will use in my articles:

- `Node` - A host where the Chef client will run (web server, database server or another server). Chef Client always working on server, which it configure.
- `Chef Client` - a command line tool that configures servers.
- `Chef Solo` - a version of the Chef client that doesn’t rely to the server for configuration (like Chef server).
- `Recipes` - a single file of Ruby code that contains commands to run on a node (nginx ssl module, apache php module).
- `Resources` - a node’s resources include files, directories, users and services.
- `Cookbook` - a collection of Chef recipes (nginx cookbook, postgresql cookbook).
- `Role` - reusable configuration for multiple nodes (web role, database role, etc).
- `Attribute` - variables that are passed through Chef and used in recipes and templates (the version number of nginx to install).
- `Template` - a file with placeholders for attributes, used to create configuration files (simple Erb file).

## Initialize chef project

Let’s create our folder, which will contain all our Chef kitchen:

```
$ mkdir chef-solo-example
$ cd chef-solo-example
```

Next I will use [bundler](http://gembundler.com/) to get some useful gems:

```
$ cat Gemfile
```

```ruby
  source :rubygems

  gem 'knife-solo'
  gem 'librarian'
  gem 'ffi', '~> 1.2.0'
  gem 'vagrant', "~> 1.0.5"
  gem 'multi_json'
```

```
$ bundle
```

List of the required gems:

- `knife-solo` - knife is a powerful command-line interface (CLI) that comes with Chef. It is used to control Chef client. [knife-solo](http://matschaffer.github.io/knife-solo/)
- `librarian` - is a bundler for your Chef-based infrastructure repositories
- `vagrant` - create and configure lightweight, reproducible, and portable development environments. For this rubygems need installed VirtualBox. We will use vagrant to test our Chef Solo. [vagrant](http://www.vagrantup.com/)

Next you need to create a kitchen by knife:

```
$ knife solo init .
# for version < 0.1.0 you should use "knife kitchen ."
$ ls -la
total 48
drwxr-xr-x  14 leo  staff   476 Jan  4 19:01 .
drwxr-xr-x  69 leo  staff  2346 Jan  4 18:43 ..
drwxr-xr-x  13 leo  staff   442 Jan  4 18:57 .git
-rw-r--r--@  1 leo  staff    38 Jan  4 18:57 .gitignore
-rw-r--r--@  1 leo  staff     9 Jan  4 18:51 .rvmrc
-rw-r--r--@  1 leo  staff    98 Jan  4 18:53 Gemfile
-rw-r--r--   1 leo  staff  2033 Jan  4 18:53 Gemfile.lock
-rw-r--r--@  1 leo  staff    19 Jan  4 18:56 README.md
drwxr-xr-x   3 leo  staff   102 Jan  4 19:01 cookbooks
drwxr-xr-x   3 leo  staff   102 Jan  4 19:01 data_bags
drwxr-xr-x   3 leo  staff   102 Jan  4 19:01 nodes
drwxr-xr-x   3 leo  staff   102 Jan  4 19:01 roles
drwxr-xr-x   3 leo  staff   102 Jan  4 19:01 site-cookbooks
-rw-r--r--   1 leo  staff   319 Jan  4 19:01 solo.rb
```

Command `init` (“kitchen”) is used to create a new directory structure that fits with chef’s standard structure and can be used to build and store recipes.

Let’s look at the directory structure:

- `cookbooks` - directory for Chef cookbooks. This directory will be used for vendor cookbooks
- `data_bags` - directory for Chef Data Bags
- `nodes` - directory for Chef nodes
- `roles` - directory for Chef roles
- `site-cookbooks` - directory for your custom Chef cookbooks
- `solo.rb` - file used by Chef Solo with configuration settings

## Librarian

Now let’s create librarian Cheffile for manage the cookbooks:

```
$ librarian-chef init
  create  Cheffile
```

And add to Cheffile nginx cookbook. More cookbooks you can find at (http://community.opscode.com).

```
$ cat Cheffile
```

```ruby
  #!/usr/bin/env ruby
  #^syntax detection

  site 'http://community.opscode.com/api/v1'

  cookbook 'runit'
  cookbook 'nginx', :git => 'git://github.com/opscode-cookbooks/nginx.git'
```

```
$ librarian-chef install
```

Now in folder “cookbooks” you should find nginx cookbook and all it dependens:

```
$ ls -la cookbooks
total 0
drwxr-xr-x   6 leo  staff  204 Jan  4 19:24 .
drwxr-xr-x  18 leo  staff  612 Jan  4 19:24 ..
drwxr-xr-x  12 leo  staff  408 Jan  4 19:24 build-essential
drwxr-xr-x  16 leo  staff  544 Jan  4 19:24 nginx
drwxr-xr-x  11 leo  staff  374 Jan  4 19:24 ohai
drwxr-xr-x  13 leo  staff  442 Jan  4 19:24 runit
```

## First node

Next, create a node file. Chef node file always have name as server host. For create this file automatically and check, what Chef Solo installed on server you can use knife command “prepare”. This command installs Ruby, RubyGems and Chef on a given host. It’s structured to auto-detect the target OS and change the installation process accordingly:

```
$ knife solo prepare host_username@host
# for version < 0.1.0 you should use "knife prepare host_username@host"
```

This command apply the same parameters as ssh command. Fox example, executing with ssh key:

```
$ knife solo prepare -i key/ssh_key.pem host_username@host
```

Let’s for test call our node file “vagrant”:

```
$ cat nodes/vagrant.json
```

```json
{
  "nginx": {
    "version": "1.2.3",
    "default_site_enabled": true,
    "source": {
      "modules": ["http_gzip_static_module", "http_ssl_module"]
    }
  },
  "run_list": [
    "recipe[nginx::source]"
  ]
}
```

“run_list” is the main part of node, where you specify roles and/or recipes to add to the node. In our case I add recipe source from nginx cookbook. Also you can see nginx attributes (like version, modules, etc.). All cookbook can have directory “attributes” and this directory contain default attributes for cookbook recipes. But you can redefine this attributes in node file. We are ready to test our kitchen!

## Vagrant

For testing Chef Solo kitchen by vagrant we need download vagrant box. List of boxes you can find (http://www.vagrantbox.es).

```
$ vagrant box add precise64 http://dl.dropbox.com/u/1537815/precise64.box
$ vagrant init precise64
```

A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.

Next we should edit Vagrantfile for define chef solo:

```
$ cat Vagrantfile
```

```ruby
  # -*- mode: ruby -*-
  # vi: set ft=ruby :

  require 'rubygems'
  require 'bundler'

  Bundler.require
  require 'multi_json'

  Vagrant::Config.run do |config|
    # All Vagrant configuration is done here. The most common configuration
    # options are documented and commented below. For a complete reference,
    # please see the online documentation at vagrantup.com.

    # Every Vagrant virtual environment requires a box to build off of.
    config.vm.box = "precise64"
    
    # ...
    
    VAGRANT_JSON = MultiJson.load(Pathname(__FILE__).dirname.join('nodes', 'vagrant.json').read)

    config.vm.provision :chef_solo do |chef|
       chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
       chef.roles_path = "roles"
       chef.data_bags_path = "data_bags"
       chef.provisioning_path = "/tmp/vagrant-chef"

       # You may also specify custom JSON attributes:
       chef.json = VAGRANT_JSON
       VAGRANT_JSON['run_list'].each do |recipe|
        chef.add_recipe(recipe)
       end if VAGRANT_JSON['run_list']
    end
    
    #...
    
  end
```

As you can see “run_list” and json attributes from node “vagrant.json” automatically loaded from file. More information about using Chef Solo with Vagrant you can find by this [link](http://docs-v1.vagrantup.com/v1/docs/provisioners/chef_solo.html).

Next, we can try test Chef Solo with Vagrant:

```
$ vagrant up                                                                                                                                                                                              
[default] Importing base box 'precise64'...
[default] The guest additions on this VM do not match the install version of
VirtualBox! This may cause things such as forwarded ports, shared
folders, and more to not work properly. If any of those things fail on
this machine, please update the guest additions and repackage the
box.

Guest Additions Version: 4.1.18
VirtualBox Version: 4.2.6
[default] Matching MAC address for NAT networking...
[default] Clearing any previously set forwarded ports...
[default] Forwarding ports...
[default] -- 22 => 2222 (adapter 1)
[default] Creating shared folders metadata...
[default] Clearing any previously set network interfaces...
[default] Booting VM...
[default] Waiting for VM to boot. This can take a few minutes.
[default] VM booted and ready for use!
[default] Mounting shared folders...
[default] -- v-root: /vagrant
[default] -- v-csr-3: /tmp/vagrant-chef/chef-solo-3/roles
[default] -- v-csc-2: /tmp/vagrant-chef/chef-solo-2/cookbooks
[default] -- v-csc-1: /tmp/vagrant-chef/chef-solo-1/cookbooks
[default] -- v-csdb-4: /tmp/vagrant-chef/chef-solo-4/data_bags
[default] Running provisioner: Vagrant::Provisioners::ChefSolo...
[default] Generating chef JSON and uploading...
[default] Running chef-solo...
stdin: is not a tty
[Fri, 04 Jan 2013 18:31:24 +0000] INFO: *** Chef 0.10.10 ***
[Fri, 04 Jan 2013 18:31:24 +0000] INFO: Setting the run_list to ["recipe[nginx::source]"] from JSON
[Fri, 04 Jan 2013 18:31:24 +0000] INFO: Run List is [recipe[nginx::source]]
[Fri, 04 Jan 2013 18:31:24 +0000] INFO: Run List expands to [nginx::source]
[Fri, 04 Jan 2013 18:31:24 +0000] INFO: Starting Chef Run for precise64
[Fri, 04 Jan 2013 18:31:24 +0000] INFO: Running start handlers
[Fri, 04 Jan 2013 18:31:24 +0000] INFO: Start handlers complete.

...

[Fri, 04 Jan 2013 18:33:44 +0000] INFO: Chef Run complete in 139.63975 seconds
[Fri, 04 Jan 2013 18:33:44 +0000] INFO: Running report handlers
[Fri, 04 Jan 2013 18:33:44 +0000] INFO: Report handlers complete
```

Next, we can check what nginx successfully installed on vagrant image:

```
$ vagrant ssh
Welcome to Ubuntu 12.04.1 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Mon Aug 20 19:28:45 2012 from 10.0.2.2
vagrant@precise64:~$ ps ax | grep nginx
 6682 ?        Ss     0:00 runsv nginx
 9010 ?        S      0:00 nginx: master process /opt/nginx-1.2.3/sbin/nginx -c /etc/nginx/nginx.conf
 9011 ?        S      0:00 nginx: worker process                               
 9012 ?        S      0:00 nginx: worker process                               
 9132 pts/1    S+     0:00 grep --color=auto nginx
vagrant@precise64:~$ exit
logout
Connection to 127.0.0.1 closed.
```

Let’s check what nginx is running. Just add in “Vagrantfile” port forwarding:

```
config.vm.forward_port 80, 8085
```

Next, reload vagrant instance:

```
$ vagrant reload
```

And you should see in your browser:

> nginx

After change something in your kitchen, you should run command `vagrant provision`:

```
$ vagrant provision
```

And Chef Solo will be running again on vagrant server.

The main idea of Chef is idempotence: it can safely be run multiple times. Once you develop your configuration, your machines will apply the configuration and Chef will only make any changes to the system if the system state does not match the configured state. For example, first time chef will compile nginx from source and install it on server. On next run it just check, what nginx already compiled and running (if you will not change attributes).

## Cook real server

After fully testing the kitchen you can apply your node configuration on real server. You should rename “vagrant.json” on your server host and run commands:

```
$ knife solo cook host_username@host
# for version < 0.1.0 you should use "knife cook host_username@host"
```

Your server must have installed Chef client. If no, just before command “cook” run command “prepare”.

## Summary

In the current article we have learn usage Chef Solo and test our first kitchen. In the next article we will look at the cookbook structure and will write own cookbook.

All example code you can find here: https://github.com/le0pard/chef-solo-example/tree/1.0.

That’s all folks! Thank you for reading till the end.

> source: http://leopard.in.ua/2013/01/04/chef-solo-getting-started-part-1/

# Getting Started with Chef Solo. Part 2

All example code you can find here: https://github.com/le0pard/chef-solo-example/tree/2.0.

In the previous article we discussed how to use Chef Solo, learned about knife, librarian and vagrant tools, which help us to use and testing Chef Solo kitchen. In this article we will learn cookbook structure and will write own cookbook.

## Cookbook

Cookbook is a collection of Chef recipes. All cookbooks like a Chef are written on Ruby. You already have seen how we get nginx cookbook and use “source” recipe from it to install nginx on our server. Let’s look on the structure of this cookbook:

```
$ ls -la cookbooks/nginx
total 112
drwxr-xr-x  16 leo  staff    544 Jan  4 19:24 .
drwxr-xr-x   6 leo  staff    204 Jan  4 19:24 ..
drwxr-xr-x  15 leo  staff    510 Jan  4 19:24 .git
-rw-r--r--   1 leo  staff     28 Jan  4 19:24 .gitignore
-rw-r--r--   1 leo  staff   3526 Jan  4 19:24 CHANGELOG.md
-rw-r--r--   1 leo  staff  10811 Jan  4 19:24 CONTRIBUTING.md
-rw-r--r--   1 leo  staff     37 Jan  4 19:24 Gemfile
-rw-r--r--   1 leo  staff  10850 Jan  4 19:24 LICENSE
-rw-r--r--   1 leo  staff  14633 Jan  4 19:24 README.md
drwxr-xr-x   8 leo  staff    272 Jan  4 19:24 attributes
drwxr-xr-x   3 leo  staff    102 Jan  4 19:24 definitions
drwxr-xr-x   3 leo  staff    102 Jan  4 19:24 files
-rw-r--r--@  1 leo  staff   3283 Jan  4 19:24 metadata.rb
drwxr-xr-x  20 leo  staff    680 Jan  4 19:24 recipes
drwxr-xr-x   5 leo  staff    170 Jan  4 19:24 templates
drwxr-xr-x   3 leo  staff    102 Jan  4 19:24 test
```

Cookbook can have:

- `metadata.rb` - the file, which contains all information about cookbook (name, dependencies).

```ruby
name              "nginx"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs and configures nginx"
version           "1.1.2"

recipe "nginx", "Installs nginx package and sets up configuration with Debian apache style with sites-enabled/sites-available"
recipe "nginx::source", "Installs nginx from source and sets up configuration with Debian apache style with sites-enabled/sites-available"

%w{ ubuntu debian centos redhat amazon scientific oracle fedora }.each do |os|
 supports os
end

%w{ build-essential }.each do |cb|
 depends cb
end

depends 'ohai', '>= 1.1.2'

%w{ runit bluepill yum }.each do |cb|
 recommends cb
end
```

This is an important file, if you want distribute your cookbook.

- `attributes` - folder, which contain files with default attributes for recipes. In nginx cookbook you can find such default attributes:

```ruby
default['nginx']['version'] = "1.2.3"
default['nginx']['dir'] = "/etc/nginx"
default['nginx']['log_dir'] = "/var/log/nginx"
default['nginx']['binary'] = "/usr/sbin/nginx"
```

As you remember we can redefine all this attributes in node file.

- `definitions` - folder, which contain helpers from this cookbook. In nginx cookbook you can find this helper:

```ruby
define :nginx_site, :enable => true do
 if params[:enable]
   execute "nxensite #{params[:name]}" do
     command "/usr/sbin/nxensite #{params[:name]}"
     notifies :reload, "service[nginx]"
     not_if do ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{params[:name]}") end
   end
 else
   execute "nxdissite #{params[:name]}" do
     command "/usr/sbin/nxdissite #{params[:name]}"
     notifies :reload, "service[nginx]"
     only_if do ::File.symlink?("#{node['nginx']['dir']}/sites-enabled/#{params[:name]}") end
   end
 end
end
```

The helper `nginx_site` can enable/disable configuration from folder “site-available” and reload nginx. I will show how to use this helper.

- `files` - folder, which contain files and this files just need to copy on server in the right place (it can be ssl keys, static configs, etc.)
- `recipes` - folder, which contain all recipes of this cookbook. Each recipe is in a separate Ruby file:

```
$ ls -la cookbooks/nginx/recipes
total 152
drwxr-xr-x  20 leo  staff   680 Jan  4 19:24 .
drwxr-xr-x  16 leo  staff   544 Jan  4 19:24 ..
-rw-r--r--   1 leo  staff  1123 Jan  4 19:24 authorized_ips.rb
-rw-r--r--   1 leo  staff   792 Jan  4 19:24 commons.rb
-rw-r--r--   1 leo  staff  1114 Jan  4 19:24 commons_conf.rb
-rw-r--r--   1 leo  staff  1070 Jan  4 19:24 commons_dir.rb
-rw-r--r--   1 leo  staff   854 Jan  4 19:24 commons_script.rb
-rw-r--r--   1 leo  staff  1201 Jan  4 19:24 default.rb
-rw-r--r--   1 leo  staff  1551 Jan  4 19:24 http_echo_module.rb
-rw-r--r--   1 leo  staff  3412 Jan  4 19:24 http_geoip_module.rb
-rw-r--r--   1 leo  staff   814 Jan  4 19:24 http_gzip_static_module.rb
-rw-r--r--   1 leo  staff  1352 Jan  4 19:24 http_realip_module.rb
-rw-r--r--   1 leo  staff   797 Jan  4 19:24 http_ssl_module.rb
-rw-r--r--   1 leo  staff  1091 Jan  4 19:24 http_stub_status_module.rb
-rw-r--r--   1 leo  staff   738 Jan  4 19:24 ipv6.rb
-rw-r--r--   1 leo  staff  1704 Jan  4 19:24 naxsi_module.rb
-rw-r--r--   1 leo  staff  1059 Jan  4 19:24 ohai_plugin.rb
-rw-r--r--   1 leo  staff  2994 Jan  4 19:24 passenger.rb
-rw-r--r--   1 leo  staff  5218 Jan  4 19:24 source.rb
-rw-r--r--   1 leo  staff  1571 Jan  4 19:24 upload_progress_module.rb
```

As you remember we added to run_list:

```ruby
"run_list": [
  "recipe[nginx::source]"
]
```

This is run source.rb recipe from nginx cookbook. If you change by this:

```ruby
"run_list": [
  "recipe[nginx]"
]
```

This is run default recipe from nginx cookbook (file default.rb in recipes folder).

- `templates` - folder, which contain Erb templates of this cookbook (this is nginx configs)
- `test` - folder, which contain tests for this cookbook

## First cookbook

Let’s create our first cookbook. Our custom cookbooks should be in folder `site-cookbooks` (folder `cookbooks` using for vendor cookbooks and managed by librarian, so we add this folder in `gitignore`). If you look in `solo.rb`, you can see such settings:

```ruby
file_cache_path "/tmp/chef-solo"
cookbook_path [ "/tmp/chef-solo/site-cookbooks","/tmp/chef-solo/cookbooks" ]
```

This mean what Chef will search needed cookbook first in folder site-cookbooks and if no found will try to search in folder cookbooks. So if you create in site-cookbooks nginx cookbook, Chef will try use it first.

Let’s create a cookbook with name “tomatoes”:

```
$ mkdir site-cookbooks/tomatoes
$ mkdir site-cookbooks/tomatoes/recipes site-cookbooks/tomatoes/templates
$ mkdir site-cookbooks/tomatoes/templates/default
$ ls -la site-cookbooks/tomatoes
drwxr-xr-x  4 leo  staff  136 Jan  5 14:50 .
drwxr-xr-x  4 leo  staff  136 Jan  5 14:49 ..
drwxr-xr-x  2 leo  staff   68 Jan  5 14:50 recipes
drwxr-xr-x  3 leo  staff  102 Jan  5 14:50 templates
```

And create file `default.rb` in recipes folder with content:

```ruby
package "git"
```

Command `package` is used to manage packages in the server. This command will install on server git package. More info about this command you can read here: http://docs.opscode.com/chef/resources.html#package. Next, add to our `vagrant.json` node file in run list new recipe:

```ruby
"run_list": [
  "recipe[nginx::source]",
  "recipe[tomatoes]"
]
```

And test our kitchen again:

```
$ vagrant provision
[default] Running provisioner: Vagrant::Provisioners::ChefSolo...
[default] Generating chef JSON and uploading...
[default] Running chef-solo...
stdin: is not a tty
[Sat, 05 Jan 2013 13:07:34 +0000] INFO: *** Chef 0.10.10 ***
[Sat, 05 Jan 2013 13:07:34 +0000] INFO: Setting the run_list to ["recipe[nginx::source]", "recipe[tomatoes]"] from JSON
[Sat, 05 Jan 2013 13:07:34 +0000] INFO: Run List is [recipe[nginx::source], recipe[tomatoes]]
[Sat, 05 Jan 2013 13:07:34 +0000] INFO: Run List expands to [nginx::source, tomatoes]
[Sat, 05 Jan 2013 13:07:34 +0000] INFO: Starting Chef Run for precise64
[Sat, 05 Jan 2013 13:07:34 +0000] INFO: Running start handlers
[Sat, 05 Jan 2013 13:07:34 +0000] INFO: Start handlers complete.

...

[Sat, 05 Jan 2013 13:07:35 +0000] INFO: Processing package[git] action install (tomatoes::default line 1)
[Sat, 05 Jan 2013 13:07:50 +0000] INFO: package[git] installed version 1:1.7.9.5-1
[Sat, 05 Jan 2013 13:07:50 +0000] INFO: execute[nxensite default] sending reload action to service[nginx] (delayed)
[Sat, 05 Jan 2013 13:07:50 +0000] INFO: Processing service[nginx] action reload (nginx::source line 82)
[Sat, 05 Jan 2013 13:07:50 +0000] INFO: service[nginx] reloaded
[Sat, 05 Jan 2013 13:07:50 +0000] INFO: Chef Run complete in 16.410976 seconds
[Sat, 05 Jan 2013 13:07:50 +0000] INFO: Running report handlers
[Sat, 05 Jan 2013 13:07:50 +0000] INFO: Report handlers complete
```

As you can see git package installed on the server. Let’s check this:

```
$ vagrant ssh
Welcome to Ubuntu 12.04.1 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Sat Jan  5 13:09:24 2013 from 10.0.2.2
vagrant@precise64:~$ git --version
git version 1.7.9.5
vagrant@precise64:~$ exit
logout
Connection to 127.0.0.1 closed.
```

All works fine.

### Сonfigure nginx through our cookbook

Let’s configure nginx for our application. First of all add new attributes in vagrant node (file “nodes/vagrant.json”):

```json
{
  "app": {
    "name": "tomatoes",
    "web_dir": "/var/data/www/apps/tomatoes"
  },
  "user":{
    "name": "vagrant"
  },
  "nginx": {
    "version": "1.2.3",
    "default_site_enabled": true,
    "source": {
      "modules": ["http_gzip_static_module", "http_ssl_module"]
    }
  },
  "run_list": [
    "recipe[nginx::source]",
    "recipe[tomatoes]"
  ]
}
```

Next, create nginx template `tomatoes/templates/default/nginx.conf.erb`:

```erb
server {
    listen 80 default;
    
    access_log <%= node.app.web_dir %>/logs/nginx_access.log;
    error_log <%= node.app.web_dir %>/logs/nginx_error.log;
    keepalive_timeout 10; 
    root <%= node.app.web_dir %>/public;
}
```

And create file `index.html` in directory `tomatoes/files/default` (create this directory before) with content:

```html
<h1>Hello from Chef Solo</h1>
```

This we will use to check what nginx will show after setup of settings.

At last add this content to “tomatoes/recipes/default.rb”:

```ruby
directory node.app.web_dir do
  owner node.user.name
  mode "0755"
  recursive true
end

directory "#{node.app.web_dir}/public" do
  owner node.user.name
  mode "0755"
  recursive true
end

directory "#{node.app.web_dir}/logs" do
  owner node.user.name
  mode "0755"
  recursive true
end

template "#{node.nginx.dir}/sites-available/#{node.app.name}.conf" do
  source "nginx.conf.erb"
  mode "0644"
end

nginx_site "#{node.app.name}.conf"

cookbook_file "#{node.app.web_dir}/public/index.html" do
  source "index.html"
  mode 0755
  owner node.user.name
end
```

As you can see in recipe node attributes available for us in “node” variable. You can get this attributes in several ways:

```ruby
 node.app.web_dir
 node['app']['web_dir']
 node[:app][:web_dir]
```

This all ways will give you the same value from `app.web_dir` attribute.

As you can see in recipe code we created 3 directories, created new config for nginx, enabled this config by “nginx_site” helper (this helper automatically reload nginx) and put “index.html” into server directory. After launch command `vagrant provision` you should see this in your browser by url “http://localhost:8085/”:

> nginx

> Ruby Power!

As you can see in our recipe we created 3 directories by 3 command. Better DRY this code. But how to do this? Simple! This is all Ruby code, so you can use it to do your recipe more powerful (and beautiful, of course):

```ruby
package "git"

%w(public logs).each do |dir|
  directory "#{node.app.web_dir}/#{dir}" do
    owner node.user.name
    mode "0755"
    recursive true
  end
end

template "#{node.nginx.dir}/sites-available/#{node.app.name}.conf" do
  source "nginx.conf.erb"
  mode "0644"
end

nginx_site "#{node.app.name}.conf"

cookbook_file "#{node.app.web_dir}/public/index.html" do
  source "index.html"
  mode 0755
  owner node.user.name
end
```

We collect all subfolders in Ruby array and create its in one cycle.

## Summary

In the current article we have learn the Chef cookbook structure and write simple Chef cookbook. In the next article we will look at the usage of `roles` in your Chef kitchen.

All example code you can find here: https://github.com/le0pard/chef-solo-example/tree/2.0.

> source: http://leopard.in.ua/2013/01/05/chef-solo-getting-started-part-2/

# Getting Started with Chef Solo. Part 3

All example code you can find here: https://github.com/le0pard/chef-solo-example/tree/3.0.

In the previous article we learned Chef cookbook structure and wrote own Chef cookbook. In this article we will learn Chef role.

## Create your cloud

We learned how to successfully use the Chef to setup servers. In most cases you cloud contain several servers with the same configuration. For example, you can have several web servers and one load balancer, which balance on this web servers. Or you can have several database or queue servers with identical configuration. In this case, it is very hard way to clone each server by nodes, because you need copy all attributes from one node to another. Maintain a system with such nodes also will be hard: you will have to modify the “n” number of nodes to change some attribute value. In this case we need to use the DRY. What we can do? We can use role! 

A role provides a means of grouping similar features of similar nodes, providing a mechanism for easily composing sets of functionality.

In Chef kitchen we can create roles: web, database and queue roles. Nodes may use one or more roles with recipes. Let’s look at an example.

## Roles

Let’s create in our kitchen web role. Create in folder `roles` role `web.json`:

```json
{
  "name": "web",
  "chef_type": "role",
  "json_class": "Chef::Role",
  "description": "The base role for systems that serve HTTP traffic",
  "default_attributes": {
    "app": {
      "name": "tomatoes",
      "web_dir": "/var/data/www/apps/tomatoes"
    },
    "user":{
      "name": "vagrant"
    },
    "nginx": {
      "version": "1.2.6",
      "default_site_enabled": true,
      "source": {
        "url": "http://nginx.org/download/nginx-1.2.6.tar.gz",
        "modules": ["http_gzip_static_module", "http_ssl_module"]
      }
    }
  },
  "run_list": [
    "recipe[nginx::source]",
    "recipe[tomatoes]"
  ]
}
```

The role require such attributes:

- `chef_type` - should be `role`
- `json_class` - should be `Chef::Role`
- `name` - name of role, in our case `web`
- `run_list` - list of recipes, like in node. We just moved run_list from `vagrant.json` node to `web.json`

Also Chef role can have `default_attributes` and `override_attributes`. 

What’s the difference? 

`default_attributes` is an optional set of attributes that should be applied to all nodes with this role, assuming the node does not already have a value for that attribute. You can override this attributes values in node, which use this role. 

`override_attributes` an optional set of attributes that should be applied to all nodes with this role, regardless of whether a node already has a value for that attribute. Useful for setting site-wide values that will always be set, because even node attributes cannot override this attributes values. In our case I moved node attributes in `default_attributes` (and update nginx version).

Next, I edited the node for the usage web role:

```ruby
{
  "run_list": [
    "role[web]"
  ]
}
```

And do not forget to specify vagrant that we had Chef roles:

```ruby
VAGRANT_JSON = MultiJson.load(Pathname(__FILE__).dirname.join('nodes', 'vagrant.json').read)

config.vm.provision :chef_solo do |chef|
   chef.cookbooks_path = ["site-cookbooks", "cookbooks"]
   chef.roles_path = "roles"
   chef.data_bags_path = "data_bags"
   chef.provisioning_path = "/tmp/vagrant-chef"

   # You may also specify custom JSON attributes:
   chef.json = VAGRANT_JSON
   VAGRANT_JSON['run_list'].each do |recipe|
    chef.add_recipe(recipe)
   end if VAGRANT_JSON['run_list']
   
   Dir["#{Pathname(__FILE__).dirname.join('roles')}/*.json"].each do |role|
     chef.add_role(role)
   end
end
```

Now we can test Chef kitchen with web role:

```
$ vagrant provision
[default] Running provisioner: Vagrant::Provisioners::ChefSolo...
[default] Generating chef JSON and uploading...
[default] Running chef-solo...
stdin: is not a tty
[Mon, 07 Jan 2013 14:57:59 +0000] INFO: *** Chef 0.10.10 ***
[Mon, 07 Jan 2013 14:58:00 +0000] INFO: Setting the run_list to ["role[web]"] from JSON
[Mon, 07 Jan 2013 14:58:00 +0000] INFO: Run List is [role[web]]
[Mon, 07 Jan 2013 14:58:00 +0000] INFO: Run List expands to [nginx::source, tomatoes]
[Mon, 07 Jan 2013 14:58:00 +0000] INFO: Starting Chef Run for precise64

...

[Mon, 07 Jan 2013 14:58:04 +0000] INFO: Processing remote_file[http://nginx.org/download/nginx-1.2.6.tar.gz] action create (nginx::source line 58)

...

[Mon, 07 Jan 2013 14:58:12 +0000] INFO: Chef Run complete in 11.615968 seconds
[Mon, 07 Jan 2013 14:58:12 +0000] INFO: Running report handlers
[Mon, 07 Jan 2013 14:58:12 +0000] INFO: Report handlers complete
```

We should have see the same in your browser by this url “http://localhost:8085/”:

> nginx

But nginx successfully updated:

> nginx

Chef is very flexible, because your node can use several roles and/or a several recipes simultaneously. For example:

```ruby
{
  "run_list": [
    "role[web]",
    "role[db]",
    "recipe[monit]"
  ]
}
```

## Summary

In the current article we have learn the Chef roles. In the next article we will learn more about Chef cookbooks.

All example code you can find here: github.com/le0pard/chef-solo-example/tree/3.0.

> source: http://leopard.in.ua/2013/01/07/chef-solo-getting-started-part-3/

# Getting Started with Chef Solo. Part 4

All example code you can find here: github.com/le0pard/chef-solo-example/tree/4.0.

In the previous article we learned Chef roles. In this article we will learn more about knife and cookbooks.

```
WARNING: No knife configuration file found
```

Knife also used to communicate with Chef Server, but in our case we don’t have Chef Server. To fix this warning you should create `knife.rb` file (knife configuration file) and add this content:

```ruby
cookbook_path [ "/tmp/chef-solo/site-cookbooks","/tmp/chef-solo/cookbooks" ]
```

In this case knife will automatically found this configuration and will not show this warning.

## Node.js recipe

Let’s create node.js recipe in our tomatoes cookbook. Add this content in created file `tomatoes/recipes/node_js.rb`:

```ruby
case node['platform_family']
  when 'rhel','fedora'
    package "openssl-devel"
  when 'debian'
    package "libssl-dev"
end

nodejs_tar = "node-v#{node['nodejs']['version']}.tar.gz"
nodejs_tar_path = nodejs_tar
if node['nodejs']['version'].split('.')[1].to_i >= 5
  nodejs_tar_path = "v#{node['nodejs']['version']}/#{nodejs_tar_path}"
end
# Let the user override the source url in the attributes
nodejs_src_url = "#{node['nodejs']['src_url']}/#{nodejs_tar_path}"

remote_file "/usr/local/src/#{nodejs_tar}" do
  source nodejs_src_url
  checksum node['nodejs']['checksum']
  mode 0644
  action :create_if_missing
end

# --no-same-owner required overcome "Cannot change ownership" bug
# on NFS-mounted filesystem
execute "tar --no-same-owner -zxf #{nodejs_tar}" do
  cwd "/usr/local/src"
  creates "/usr/local/src/node-v#{node['nodejs']['version']}"
end

bash "compile node.js" do
  cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
  code <<-EOH
    PATH="/usr/local/bin:$PATH"
    ./configure --prefix=#{node['nodejs']['dir']} && \
    make
  EOH
  creates "/usr/local/src/node-v#{node['nodejs']['version']}/node"
end

execute "nodejs make install" do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "make install"
  cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
  not_if {File.exists?("#{node['nodejs']['dir']}/bin/node") && `#{node['nodejs']['dir']}/bin/node --version`.chomp == "v#{node['nodejs']['version']}" }
end
```

Next, we should add default attributes for this recipe. You should create file `tomatoes/attributes/node_js.rb` with content:

```ruby
default['nodejs']['version'] = '0.8.6'
default['nodejs']['checksum'] = 'dbd42800e69644beff5c2cf11a9d4cf6dfbd644a9a36ffdd5e8c6b8db9240854'
default['nodejs']['dir'] = '/usr/local'
default['nodejs']['src_url'] = "http://nodejs.org/dist"
```

And add this in role `web` run_list:

```ruby
"run_list": [
  "recipe[nginx::source]",
  "recipe[tomatoes]",
  "recipe[tomatoes::node_js]"
]
```

Now you can test this new recipe by `vagrant provision` command. After running this command, the server will node.js:

```
$ vagrant ssh
Welcome to Ubuntu 12.04.1 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Mon Aug 20 19:28:45 2012 from 10.0.2.2
vagrant@precise64:~$ node -v
v0.8.6
```

## Сorrect dependencies

This `node.js recipe` will fail on new server, because to install node.js on server should be installed g++ and gcc before running this recipe. For this exist `build-essential` cookbook with recipes. We should add this in top of our node.js recipe:

```ruby
include_recipe "build-essential"
```

This cookbook is automatically downloaded by nginx cookbook (it is added as dependency in `metadata.rb`).

Now we can use command `include_recipe` in `default.rb` recipe:

```ruby
include_recipe "tomatoes::node_js"
```

And rollback last run_list (without node_js recipe, default recipe from tomatoes cookbook automatically will execute node_js recipe):

```ruby
"run_list": [
  "recipe[nginx::source]",
  "recipe[tomatoes]"
]
```

You can also create `metadata.rb` file for your cookbook and add some info about this cookbook:

```ruby
name              "tomatoes"
maintainer        "Someone"
maintainer_email  "your_email@example.com"
license           "MIT"
description       "Installs and configures nginx, git and node.js"
version           "0.0.1"

recipe "tomatoes", "Installs nginx configuration, git and node.js"
recipe "tomatoes::node_js", "Installs only node.js"

depends "build-essential"
```

## Summary

In the current article we have learn more about Chef cookbooks. In the next article we will learn more about Ohai and how to write Ohai plugin.

All example code you can find here: github.com/le0pard/chef-solo-example/tree/4.0.

# Getting Started with Chef Solo. Part 5

Today we will continue talk about Chef Solo. All example code you can find here: github.com/le0pard/chef-solo-example/tree/5.0.

In the previous article we learned more about Chef cookbooks. In this article we will learn what is Ohai and how to write Ohai plugin.

## Ohai

Ohai detects data about your operating system. It can be used standalone, but its primary purpose is to provide node data to Chef.

When invoked, it collects detailed, extensible information about the machine it’s running on, including Chef configuration, hostname, FQDN, networking, memory, CPU, platform, and kernel data.

When Chef configures the node object during each Chef run, these attributes are used by the chef-client to ensure that certain properties remain unchanged. These properties are also referred to as automatic attributes. In our case (in Chef Solo), this attributes available in node object. For example:

```ruby
node['platform'] # The platform on which a node is running. This attribute helps determine which providers will be used.
node['platform_version']	# The version of the platform. This attribute helps determine which providers will be used.
node['hostname']	# The host name for the node.
```

## Ohai plugin

In our cookbook “tomatoes” we already have node.js recipe. Let’s create ohai plugin, which will provide for us information about already installed on system node.js. We will use this information to check if we need install node.js on server.

First of all create in “tomatoes” new recipe `ohai_plugin.rb` with content:

```ruby
template "#{node['ohai']['plugin_path']}/system_node_js.rb" do
  source "plugins/system_node_js.rb.erb"
  owner "root"
  group "root"
  mode 00755
  variables(
    :node_js_bin => "#{node['nodejs']['dir']}/bin/node"
  )
end

include_recipe "ohai"
```

This recipe will generate ohai plugin from template `system_node_js.rb`. Next we should create this template in folder `tomatoes/templates/default/plugins`:

```ruby
provides "system_node_js"
provides "system_node_js/version"

system_node_js Mash.new unless system_node_js
system_node_js[:version] = nil unless system_node_js[:version]

status, stdout, stderr = run_command(:no_status_check => true, :command => "<%= @node_js_bin %> --version")

system_node_js[:version] = stdout[1..-1] if 0 == status
```

In first two lines we set by method “provides” automatic attributes, which will provide for us this plugin.

Most of the information we want to lookup would be nested in some way, and ohai tends to do this by storing the data in a Mash. This can be done by creating a new mash and setting the attribute to it. We did this with “system_node_js”.

In the end of code, plugin set the version of node.js, if node.js installed on server. That’s it!

Next, let’s try this plugin by adding `default.rb` recipe this content:

```ruby
include_recipe "tomatoes::ohai_plugin"
# remove this in your prod recipe
puts "Node version: #{node.system_node_js.version}" if node['system_node_js']
```

Now test it by running the command `vagrant provision`. When you first start, you will not see anything, as the plugin will be delivered later chef-client launched. But the second time, you should see a similar picture in the log:

```
[Sat, 26 Jan 2013 18:42:16 +0000] INFO: ohai plugins will be at: /etc/chef/ohai_plugins
[Sat, 26 Jan 2013 18:42:16 +0000] INFO: Processing remote_directory[/etc/chef/ohai_plugins] action create (ohai::default line 27)
[Sat, 26 Jan 2013 18:42:16 +0000] INFO: Processing cookbook_file[/etc/chef/ohai_plugins/README] action create (dynamically defined)
[Sat, 26 Jan 2013 18:42:16 +0000] INFO: Processing ohai[custom_plugins] action reload (ohai::default line 42)
[Sat, 26 Jan 2013 18:42:16 +0000] INFO: ohai[custom_plugins] reloaded
Node version: 0.8.6
[Sat, 26 Jan 2013 18:42:17 +0000] INFO: Processing ohai[reload_nginx] action nothing (nginx::ohai_plugin line 22)
[Sat, 26 Jan 2013 18:42:17 +0000] INFO: Processing template[/etc/chef/ohai_plugins/nginx.rb] action create (nginx::ohai_plugin line 27)
[Sat, 26 Jan 2013 18:42:17 +0000] INFO: Processing remote_directory[/etc/chef/ohai_plugins] action nothing (ohai::default line 27)
[Sat, 26 Jan 2013 18:42:17 +0000] INFO: Processing ohai[custom_plugins] action nothing (ohai::default line 42)
```

In this case we can little change our node.js recipe:

```ruby
execute "nodejs make install" do
  environment({"PATH" => "/usr/local/bin:/usr/bin:/bin:$PATH"})
  command "make install"
  cwd "/usr/local/src/node-v#{node['nodejs']['version']}"
  not_if {node['system_node_js'] && node['system_node_js']['version'] == node['nodejs']['version'] }
end
```

Let’s try to change node.js version in role `web.json`:

```ruby
"nodejs": {
  "version": "0.8.18",
  "checksum": "e3bc9b64f60f76a32b7d9b35bf86b5d1b8166717"
}
```

And restart `vagrant provision`:

```
[Sat, 26 Jan 2013 19:09:32 +0000] INFO: Processing remote_file[/usr/local/src/node-v0.8.18.tar.gz] action create_if_missing (tomatoes::node_js line 16)
[Sat, 26 Jan 2013 19:10:17 +0000] INFO: remote_file[/usr/local/src/node-v0.8.18.tar.gz] updated
[Sat, 26 Jan 2013 19:10:17 +0000] INFO: remote_file[/usr/local/src/node-v0.8.18.tar.gz] mode changed to 644
[Sat, 26 Jan 2013 19:10:17 +0000] INFO: Processing execute[tar --no-same-owner -zxf node-v0.8.18.tar.gz] action run (tomatoes::node_js line 25)
[Sat, 26 Jan 2013 19:10:18 +0000] INFO: execute[tar --no-same-owner -zxf node-v0.8.18.tar.gz] ran successfully
[Sat, 26 Jan 2013 19:10:18 +0000] INFO: Processing bash[compile node.js] action run (tomatoes::node_js line 30)
[Sat, 26 Jan 2013 19:18:16 +0000] INFO: bash[compile node.js] ran successfully
[Sat, 26 Jan 2013 19:18:16 +0000] INFO: Processing execute[nodejs make install] action run (tomatoes::node_js line 40)
[Sat, 26 Jan 2013 19:18:19 +0000] INFO: execute[nodejs make install] ran successfully
```

And after some time, the server will have a new node.js:
```
$ vagrant ssh
Welcome to Ubuntu 12.04.1 LTS (GNU/Linux 3.2.0-23-generic x86_64)

 * Documentation:  https://help.ubuntu.com/
Welcome to your Vagrant-built virtual machine.
Last login: Sat Jan 26 19:19:00 2013 from 10.0.2.2
vagrant@precise64:~$ node -v
v0.8.18
```

And on next launch of chef solo you should see new version of node.js:

```
[Sat, 26 Jan 2013 19:20:22 +0000] INFO: Processing remote_directory[/etc/chef/ohai_plugins] action create (ohai::default line 27)
[Sat, 26 Jan 2013 19:20:22 +0000] INFO: Processing cookbook_file[/etc/chef/ohai_plugins/README] action create (dynamically defined)
[Sat, 26 Jan 2013 19:20:22 +0000] INFO: Processing ohai[custom_plugins] action reload (ohai::default line 42)
[Sat, 26 Jan 2013 19:20:22 +0000] INFO: ohai[custom_plugins] reloaded
Node version: 0.8.18
[Sat, 26 Jan 2013 19:20:23 +0000] INFO: Processing ohai[reload_nginx] action nothing (nginx::ohai_plugin line 22)
[Sat, 26 Jan 2013 19:20:23 +0000] INFO: Processing template[/etc/chef/ohai_plugins/nginx.rb] action create (nginx::ohai_plugin line 27)
```

## Summary

In the current article we have learn Ohai and how to write Ohai plugin.

All example code you can find here: github.com/le0pard/chef-solo-example/tree/5.0.

> source: http://leopard.in.ua/2013/01/26/chef-solo-getting-started-part-5/

-----