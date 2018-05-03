# frozen_string_literal: true

GrapeSwaggerRails.options.url      = "/swagger_doc.json"
GrapeSwaggerRails.options.app_url  = "http://0.0.0.0:3000/"

GrapeSwaggerRails.options.before_action do
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
end

GrapeSwaggerRails.options.app_name = "Stackoverflow"

GrapeSwaggerRails.options.doc_expansion = "list"
