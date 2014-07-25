note
	description: "Objects that provide information about an API exposed on a resource."
	author: "Olivier Ligot"

class
	SWAGGER_API_DECLARATION

create
	make

feature {NONE} -- Initialization

	make (an_api_version: like api_version; a_swagger_version: like swagger_version; some_apis: like apis; a_resource_path: like resource_path)
			-- Create an API declaration.
		do
			api_version := an_api_version
			swagger_version := a_swagger_version
			apis := some_apis
			resource_path := a_resource_path
		ensure
			api_version_set: api_version = an_api_version
			swagger_version_set: swagger_version = a_swagger_version
			apis_set: apis = some_apis
			resource_path_set: resource_path = a_resource_path
		end

feature -- Access

	api_version: READABLE_STRING
			-- Version of the application API

	swagger_version: READABLE_STRING
			-- Swagger Specification version being used

	apis: READABLE_INDEXABLE [SWAGGER_API]
			-- List of the APIs exposed on this resource

	resource_path: READABLE_STRING
			-- Relative path to the resource, from the basePath,
			-- which this API Specification describes

	name: STRING
			-- Singular resource name
		do
			Result := resource_path.substring (2, resource_path.count)
		end

	resource_name: STRING
			-- Plural resource name
		do
			create Result.make_from_string (name)
			Result.append_character ('s')
		end

end
