# config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins "*" # ou '*', se quiser liberar tudo (somente dev)

#     resource "*",
#       headers: :any,
#       methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
#   end
# end
