note
	description: "Loads the metadata from SWAGGER files."
	author: "Benoît Marchal"

class
	SWAGGER_FACTORY

inherit
	SHARED_MESSENGER
	SHARED_EJSON
	REFACTORING_HELPER
	KL_SHARED_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_file_name: STRING; a_converters_set: like converters_set)
		do
			file_name := a_file_name
			converters_set := a_converters_set
		ensure
			file_name_set: file_name = a_file_name
			converters_sets_set: converters_set = a_converters_set
		end

feature -- Access

	resources: detachable SWAGGER_RESOURCES
			-- Swagger resources

feature -- Basic operations

	read
			-- Read the Swagger resources definition.
		local
			l_reader: JSON_FILE_READER
			l_parser: JSON_PARSER
		do
			converters_set.base_directory := file_system.dirname (file_name)
			converters_set.current_file := file_name
			create l_reader
			if attached l_reader.read_json_from (file_name) as l_json then
				create l_parser.make_parser (l_json)
				if attached l_parser.parse as jv and l_parser.is_parsed then
					if attached {SWAGGER_RESOURCES} Json.object (jv, "SWAGGER_RESOURCES") as l_resources then
						resources := l_resources
					end
				else
					messenger.report_io_error (create {SWAGGER_LOCATOR}.make_with_file_only (file_name))
				end
			else
				messenger.report_io_error (create {SWAGGER_LOCATOR}.make_with_file_only (file_name))
			end
		end

feature {NONE} -- Implementation

	file_name: STRING
			-- Resources file name

	converters_set: SWAGGER_CONVERTERS_SET

end
