from protorpc.wsgi import service

import lab5

# Map the RPC service and path (/PostService)
app = service.service_mappings([('/Message_Services', lab5.Message_Services)])
