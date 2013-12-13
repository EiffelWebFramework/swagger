note
	description : "Restbucks example extended with Swagger support"
	author: "Olivier Ligot"

class
	RESTBUCKS

inherit
	WSF_FILTERED_SERVICE
	WSF_DEFAULT_SERVICE
	KL_SHARED_EXCEPTIONS
	KL_SHARED_FILE_SYSTEM
	SHARED_EJSON
	SHARED_MESSENGER

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			create error_handler.make_standard
			read_swagger
			create router.make (1)
			setup_services
			initialize_filter
			set_service_option ("port", port)
			io.put_string ("Server listening on port " + port.out)
			io.put_new_line
			make_and_launch
		end

	create_filter
			-- Create `filter'.
		do
			create {WSF_CORS_FILTER} filter
		end

	setup_filter
			-- Setup `filter'.
		local
			l_directory: KL_DIRECTORY
			l_api_handler: SWAGGER_API_HANDLER
			l_handler: WSF_URI_TEMPLATE_AGENT_HANDLER
			l_template: URI_TEMPLATE
			l_routing_filter: WSF_ROUTING_FILTER
			l_logging_filter: WSF_LOGGING_FILTER
		do
			create l_directory.make (Swagger_directory)
			create l_template.make ("/api/{resource}")
			create l_api_handler.make (l_directory, Swagger_resources, l_template)
			create l_handler.make (agent l_api_handler.execute)
			router.handle_with_request_methods ("/api", l_handler, router.methods_GET)
			router.handle_with_request_methods (l_template.template, l_handler, router.methods_GET)
			map_router
			create l_routing_filter.make (router)
			l_routing_filter.set_execute_default_action (agent execute_default)
			filter.set_next (l_routing_filter)

			create l_logging_filter
			l_routing_filter.set_next (l_logging_filter)
		end

	setup_services
			-- Setup the `services'.
		local
			l_order_handler: ORDER_HANDLER
		do
			create l_order_handler.make_with_router (router)
			create services.make_default
			services.force_last (agent l_order_handler.execute_post, "postOrder")
			services.force_last (agent l_order_handler.execute_get, "getOrder")
			services.force_last (agent l_order_handler.execute_put, "putOrder")
			services.force_last (agent l_order_handler.execute_delete, "deleteOrder")
		end

feature -- Basic operations

	execute_default (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_response: WSF_DEFAULT_ROUTER_RESPONSE
		do
			create l_response.make_with_router (req, router)
			l_response.set_documentation_included (True)
			l_response.set_suggestion_only_method (False)
			res.send (l_response)
		end

feature {NONE} -- Implementation

	port: INTEGER = 9090

	Swagger_directory: STRING = "swagger"

	Swagger_resources: STRING = "resources"

	error_handler: UT_ERROR_HANDLER

	services: DS_HASH_TABLE [PROCEDURE [ANY, TUPLE [req: WSF_REQUEST; res: WSF_RESPONSE]], STRING]

	resources: SWAGGER_RESOURCES
			-- Swagger resources

	read_swagger
			-- Read the Swagger definition.
		local
			l_converters_set: SWAGGER_CONVERTERS_SET
			l_reader: SWAGGER_FACTORY
		do
			create l_converters_set.make
			l_converters_set.add_converters_to (json)
			create l_reader.make (File_system.pathname (Swagger_directory, Swagger_resources + ".json"), l_converters_set)
			l_reader.read
			if messenger.has_errors then
				error_handler.report_error_message ("Errors while reading the Swagger definition: " + messenger.errors_representation)
			end
			if attached l_reader.resources as l_resources then
				resources := l_resources
			else
				Exceptions.die (1)
			end
		end

	router: WSF_ROUTER

	map_router
			-- Map the `router'.
		local
			l_method: METHOD
			l_filter: WSF_FILTER
			l_options_filter: WSF_CORS_OPTIONS_FILTER
			l_validation_filter: REST_INPUT_PARAMETERS_VALIDATION_FILTER
			l_agent_filter: WSF_AGENT_FILTER
			l_req_methods: WSF_REQUEST_METHODS
		do
			across
				resources.apis as l_apis
			loop
				across
					l_apis.item.apis as l_resource_apis
				loop
					across
						l_resource_apis.item as l_methods
					loop
						l_method := l_methods.item
						create l_options_filter.make (router)
						l_filter := l_options_filter
						create l_validation_filter.make (l_method)
						l_options_filter.set_next (l_validation_filter)
						create l_agent_filter.make (services.item (l_method.nickname))
						l_validation_filter.set_next (l_agent_filter)
						create l_req_methods
						l_req_methods.enable_custom (l_method.http_method)
						l_req_methods.enable_options
						router.handle_with_request_methods (l_method.path, create {WSF_URI_TEMPLATE_AGENT_HANDLER}.make (agent l_filter.execute), l_req_methods)
					end
				end
			end
		end

end
