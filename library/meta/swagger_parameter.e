note
	description: "Objects that describe a single parameter to be sent in an operation"
	author: "Benoît Marchal"

class
	SWAGGER_PARAMETER

create
	make,
	make_with_description

feature {NONE} -- Constructor

	make (a_name: READABLE_STRING;
		  a_type: TYPEDEF_I;
		  an_origin: SWAGGER_PARAMETER_TYPE;
		  a_default_value: detachable READABLE_STRING;
		  a_required_flag: BOOLEAN)
		require
			name_not_empty: not a_name.is_empty
		do
			name := a_name
			type := a_type
			param_type := an_origin
			default_value := a_default_value
			is_required := a_required_flag
		ensure
			name_set: name = a_name
			type_set: type = a_type
			origin_set: param_type = an_origin
			default_value_set: default_value = a_default_value
			required_set: is_required = a_required_flag
		end

	make_with_description (a_name: READABLE_STRING;
						   a_description: READABLE_STRING;
						   a_type: TYPEDEF_I;
						   an_origin: SWAGGER_PARAMETER_TYPE;
		  				   a_default_value: detachable READABLE_STRING;
						   a_required_flag: BOOLEAN)
		require
			name_not_empty: not a_name.is_empty
			description_not_empty: not a_description.is_empty
		do
			name := a_name
			type := a_type
			description := a_description
			param_type := an_origin
			default_value := a_default_value
			is_required := a_required_flag
		ensure
			name_set: name = a_name
			description_set: description = a_description
			type_set: type = a_type
			origin_set: param_type = an_origin
			default_value_set: default_value = a_default_value
			required_set: is_required = a_required_flag
		end

feature -- Access

	name: READABLE_STRING
			-- Unique name for the parameter

	description: detachable READABLE_STRING
			-- Brief description of this parameter

	type: TYPEDEF_I
			-- Data type of the parameter

	param_type: SWAGGER_PARAMETER_TYPE
			-- Type of the parameter
			-- (that is, the location of the parameter in the request)

	default_value: detachable READABLE_STRING
			-- Parameter default value

feature -- Status report

	is_required: BOOLEAN
			-- Is this parameter required ?

	is_authorization: BOOLEAN
			-- Is it the Authorization parameter ?
		do
			Result := name.is_equal ("Authorization") and param_type.is_from_header
		end

invariant
--	from_body_coherence: origin.is_from_body implies (type.is_record or type.is_array)
	from_header_path_query_coherence: (param_type.is_from_header or param_type.is_from_path or param_type.is_from_query) implies type.is_simple
	from_path_required: param_type.is_from_path implies is_required

end
