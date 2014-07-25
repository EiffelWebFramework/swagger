note
	description: "Objects that serve as the root document for the API description."
	author: "Olivier Ligot"

class
	SWAGGER_RESOURCE_LISTING

create
	make

feature {NONE} -- Initialization

	make (an_api_version, a_swagger_version: READABLE_STRING; some_apis: READABLE_INDEXABLE [SWAGGER_API_DECLARATION])
			-- Create a resource listing
		do
			api_version := an_api_version
			swagger_version := a_swagger_version
			apis := some_apis
		ensure
			api_version_set: api_version = an_api_version
			swagger_version_set: swagger_version = a_swagger_version
			apis_set: apis = some_apis
		end

feature -- Access

	api_version: READABLE_STRING
			-- Version of the application API

	swagger_version: READABLE_STRING
			-- Swagger Specification version being used

	apis: READABLE_INDEXABLE [SWAGGER_API_DECLARATION]
			-- Resources to be described by this specification implementation

end
