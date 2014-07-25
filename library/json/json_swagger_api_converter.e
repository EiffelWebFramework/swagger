note
	description: "JSON converter for API."
	author: "Olivier Ligot"

class
	JSON_SWAGGER_API_CONVERTER

inherit
    JSON_CONVERTER

    SHARED_SIMPLE_TYPEDEF

create {SWAGGER_CONVERTERS_SET}
    make

feature {NONE} -- Initialization

    make (a_parent_set: SWAGGER_CONVERTERS_SET)
        do
            create object.make ("", create {ARRAY [SWAGGER_OPERATION]}.make_empty)
        	create helper
        end

feature -- Access

    object: SWAGGER_API

    value: detachable JSON_OBJECT

feature -- Conversion

    from_json (j: attached like value): detachable like object
    	local
			l_swagger_apis: ARRAY [SWAGGER_OPERATION]
			l_swagger_parameters: ARRAY [SWAGGER_PARAMETER]
			l_method: SWAGGER_OPERATION
			l_return_type: TYPEDEF_I
        do
			if attached helper.string_value (j.item (K_path)) as l_path and
				attached {JSON_ARRAY} j.item (K_operations) as l_operations then
				create l_swagger_apis.make_empty
				across
					l_operations.array_representation as l_operations_cursor
				loop
					if attached {JSON_OBJECT} l_operations_cursor.item as l_operation then
						if attached helper.string_value (l_operation.item (K_nickname)) as l_nickname
							and attached helper.string_value (l_operation.item (K_http_method)) as l_http_method
							and attached {JSON_ARRAY} l_operation.item (K_parameters) as l_parameters then
							create l_swagger_parameters.make_empty
							across
								l_parameters.array_representation as l_parameters_cursor
							loop
								if attached {SWAGGER_PARAMETER} json.object (l_parameters_cursor.item, "SWAGGER_PARAMETER") as l_parameter then
									l_swagger_parameters.force (l_parameter, l_swagger_parameters.upper + 1)
								end
							end
							if attached helper.string_value (l_operation.item (K_response_class)) as l_type and then
								(attached resource_converter as l_resource_converter and not l_type.is_empty)
								and then attached l_resource_converter.model (l_type) as l_model then
								l_return_type := l_model
							else
								l_return_type := Null_def
							end
							create l_method.make (l_nickname, l_path, l_swagger_parameters, l_return_type, l_http_method)
							l_swagger_apis.force (l_method, l_swagger_apis.upper + 1)
						end
					end
				end
				if attached helper.string_value (j.item (K_description)) as l_description then
					create Result.make_with_description (l_path, l_description, l_swagger_apis)
				else
					create Result.make (l_path, l_swagger_apis)
				end

				if attached helper.boolean_value (j.item (K_first_level)) as l_first_level and then l_first_level.item then
					Result.enable_first_level
				end
                                if attached helper.string_value (j.item (K_key)) as l_key then
                                        Result.set_key (l_key)
                                end
			end
        end

    to_json (o: like object): like value
        do

        end

feature {NONE} -- Implementation

	resource_converter: detachable JSON_SWAGGER_API_DECLARATION_CONVERTER
		local
			l_api_declaration: SWAGGER_API_DECLARATION
		do
            create l_api_declaration.make ("", "", create {ARRAY [SWAGGER_API]}.make_empty, "")
            if attached {JSON_SWAGGER_API_DECLARATION_CONVERTER} Json.converter_for (l_api_declaration) as l_converter then
            	Result := l_converter
            end
		end

	K_path: STRING = "path"
	K_description: STRING = "description"
	K_operations: STRING = "operations"
	K_nickname: STRING = "nickname"
	K_parameters: STRING = "parameters"
	K_http_method: STRING = "httpMethod"
	K_response_class: STRING = "responseClass"
	K_first_level: STRING = "firstLevel"
	K_key: STRING = "key"

	helper: JSON_CONVERSION_HELPER

end
