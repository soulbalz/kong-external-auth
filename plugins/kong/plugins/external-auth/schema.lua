local typedefs = require "kong.db.schema.typedefs"


return {
  name = "external-auth",
  fields = {
    { consumer = typedefs.no_consumer },
    { run_on = typedefs.run_on_first },
    { protocols = typedefs.protocols_http },
    { 
      config = {
        type = "record",
        fields = {
          { auth_service_url = typedefs.url({ required = true }), },
          { path = typedefs.path({ required = true }), },
          { connect_timeout = { type = "number", default = 10000 } },
          { send_timeout = { type = "number", default = 60000 }, },
          { read_timeout = { type = "number", default = 60000 }, },
        },
      }, 
    },
  },
}