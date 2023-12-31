set :stage, :development

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
#role :app, %w{~~~REMOVED~~~}
#role :web, %w{~~~REMOVED~~~}
#role :db,  %w{~~~REMOVED~~~}
#server '~~~REMOVED~~~', :app, :web, :db, :primary => true

# Extendewww.example.comd Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '~~~REMOVED~~~', user: '~~~REMOVED~~~', roles: %w{web app} #, my_property: :my_value
#server '~~~REMOVED~~~', user: '~~~REMOVED~~~', roles: %w{db} #, my_property: :my_value