note
	description: "Swagger API documentation handler."
	author: "Olivier Ligot"

class
	SWAGGER_API_HANDLER

inherit
	KL_SHARED_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_directory: KL_DIRECTORY; some_resources: STRING; a_template: URI_TEMPLATE)
		require
			a_directory_not_void: a_directory /= Void
			a_directory_readable: a_directory.is_readable
			some_resources_not_void: some_resources /= Void
			a_template_not_void: a_template /= Void
			a_template_variables_not_empty: not a_template.variable_names.is_empty
		do
			directory := a_directory
			resources := some_resources
			template := a_template
		ensure
			directory_set: directory = a_directory
			resources_set: resources = some_resources
			template_set: template = a_template
		end

feature -- Access

	directory: KL_DIRECTORY
			-- Swagger base directory

	resources: STRING
			-- Swagger resources name

	template: URI_TEMPLATE
			-- URI template

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the handler
		local
			l_name: STRING
			l_response: WSF_FILE_RESPONSE
		do
			if attached req.string_item (template.variable_names.first) as l_resource then
				l_name := l_resource
			else
				create l_name.make_from_string (resources)
			end
			l_name.append_string (".json")
			create l_response.make (File_system.pathname (directory.name, l_name))

			-- Remove the Last-Modified header
			-- as it does not work quite well for the moment.
			l_response.header.remove_header_named ({HTTP_HEADER_NAMES}.header_last_modified)

			res.send (l_response)
		end

end
