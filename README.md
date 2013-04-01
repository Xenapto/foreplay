Foreplay
========

Foreplay: deploying Rails projects to Ubuntu using Foreman

### Using foreplay

    ENV=production rake foreplay:push

or

    ENV=production ROLE=web foreplay:push

You can set the environment variables `ENV` and `ROLE` elsewhere if you wish.
If `ROLE` is not defined then we deploy all roles.

### foreplay.yml

Format:

```YAML
defaults:       # global defaults for all environments
  name:         # app name (if omitted then Rails.application.class.parent_name.underscore is used)
  servers: [server1, server2, server3] # which servers to deploy the app on
  user:         # The username to connect with (must have SSH permissions)
  password:     # The password to use to connect (not necessary if you've set up SSH keys)
  keyfile:      # ...or a file containing a private key that allows the named user access to the server
  key:          # ...or a private key that allows the named user access to the server
  path:         # absolute path to deploy the app on each server. %s will be translated to the application name
  database:     # the database.yml elements to write to the config folder
  env:          # contents of the .env file
    key: value  # will go into the .env file as key=value
  foreman:      # contents of the .foreman file
    key: value  # will go into the .foreman file as key: value
production:     # deployment configuration for the production environment
  defaults:     # defaults for all roles in this environment (structure same as global defaults)
  role1:        # settings for the a particular role (e.g. web, worker, etc.) (structure same as global defaults)
```

### Environment

Settings for the `.env` files and `.foreman` files in specific sections will add to the defaults specified earlier. `.env` files will get a `RAILS_ENV=environment` entry (where `environment` is as specified in `foreplay.yml`). You can override this by adding a different `RAILS_ENV` setting to this configuration here.

The first instance of the first entry in `Procfile` that is instantiated by your Foreman concurrency settings will
be started on port 50100 or 51100 and the external port 80 will be mapped to this port by `iptables`. You cannot
configure the ports yourself. As an example, if your `Procfile` has a `web` entry on the first line and at
least one `web` instance is configured in the `.foreman` concurrency setting then the first instance of your `web`
process will be available to the outside world on port 80.

### Path

You can use `%u` in the path. This will be substituted with the `user` value. You can use `%a` in the path. This will be substituted with the app's `name`

Example:

    user: fred
    name: myapp
    path: /home/%u/apps/%a

Dependencies:

```ruby
gem 'net-ssh-shell'
```

You can constrain this to whatever group you use for initiating deployments, e.g.

```ruby
group :development do
  gem 'net-ssh-shell'
end
```
