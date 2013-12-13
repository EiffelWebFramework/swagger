note
	description: "JSON converter for swagger resources."
	author: "Olivier Ligot"

class
	JSON_SWAGGER_RESOURCES_CONVERTER

inherit
    JSON_CONVERTER

	SHARED_MESSENGER
	KL_SHARED_FILE_SYSTEM

create {SWAGGER_CONVERTERS_SET}
    make

feature {NONE} -- Initialization

    make (a_parent_set: like parent_set)
        do
            create object.make ("", "", create {ARRAY [SWAGGER_RESOURCE]}.make_empty)
            parent_set := a_parent_set
        	create helper
        ensure
        	parent_set_set: parent_set = a_parent_set
        end

feature -- Access

    object: SWAGGER_RESOURCES

    value: detachable JSON_OBJECT

feature -- Conversion

    from_json (j: attached like value): detachable like object
    	local
			l_swagger_apis: ARRAY [SWAGGER_RESOURCE]
			l_old_filename: READABLE_STRING
			l_resource_file: STRING
			l_reader: JSON_FILE_READER
			l_parser: JSON_PARSER
        do
        	if attached helper.string_value (j.item (K_api_version)) as l_api_version and
        		attached helper.string_value (j.item (K_swagger_version)) as l_swagger_version and
        		attached {JSON_ARRAY} j.item (K_apis) as l_apis then
        		create l_swagger_apis.make_empty
        		across
        			l_apis.array_representation as c
        		loop
        			if attached {JSON_OBJECT} c.item as l_api then
        				if attached helper.string_value (l_api.item (K_path)) as l_path and attached helper.string_value (l_api.item (K_description)) as l_description then
        					l_resource_file := l_path.twin
        					if l_resource_file.starts_with ("/") then
        						l_resource_file.remove (1)
        					end
        					if file_system.is_relative_pathname (l_resource_file) then
								l_resource_file := file_system.pathname (parent_set.base_directory, l_resource_file)
								if file_system.extension (l_resource_file).is_empty then
									l_resource_file.append (".json")
								end
        					end
							create l_reader
							l_old_filename := parent_set.current_file
							parent_set.current_file := l_resource_file
        					if attached l_reader.read_json_from (l_resource_file) as l_json then
								create l_parser.make_parser (l_json)
								if attached l_parser.parse as jv and l_parser.is_parsed then
									if attached {SWAGGER_RESOURCE} json.object (jv, "SWAGGER_RESOURCE") as l_resource then
										l_swagger_apis.force (l_resource, l_swagger_apis.upper + 1)
									end
								else
									messenger.report_parsing_error (create {SWAGGER_LOCATOR}.make_with_file_only (l_resource_file),
																	l_parser)
								end
							else
								messenger.report_io_error (create {SWAGGER_LOCATOR}.make_with_file_only (l_resource_file))
							end
							parent_set.current_file := l_old_filename
        				end
        			end
        		end
        		create Result.make (l_api_version, l_swagger_version, l_swagger_apis)
        	end
    	end

    to_json (o: like object): like value
        do

        end

feature {NONE} -- Implementation

	parent_set: SWAGGER_CONVERTERS_SET

	K_api_version: STRING = "apiVersion"
	K_swagger_version: STRING = "swaggerVersion"
	K_apis: STRING = "apis"
	K_path: STRING = "path"
	K_description: STRING = "description"

	helper: JSON_CONVERSION_HELPER

end
