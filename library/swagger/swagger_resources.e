note
	description: "Swagger resources."
	author: "Olivier Ligot"
	date: "$Date$"
	revision: "$Revision$"

class
	SWAGGER_RESOURCES

create
	make

feature {NONE} -- Initialization

	make (an_api_version: like api_version; a_swagger_version: like swagger_version; some_apis: like apis)
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

	swagger_version: READABLE_STRING

	apis: READABLE_INDEXABLE [SWAGGER_RESOURCE]

end
