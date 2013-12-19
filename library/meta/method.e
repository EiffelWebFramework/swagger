note
	description: "A method is the description of something you can call. Immutable."
	author: "Benoît Marchal"

class
	METHOD

inherit
	PACKAGEABLE_I

create
	make

feature {NONE} -- Initialization

	make (a_nickname: READABLE_STRING;
		  a_path: READABLE_STRING;
		  a_parameter_list: READABLE_INDEXABLE [PARAMETER];
		  a_return: TYPEDEF_I;
		  a_http_method: READABLE_STRING)
		do
			nickname := a_nickname
			path := a_path
			create {IMMUTABLE_STRING_8}description.make_empty
			parameters := a_parameter_list
			return := a_return
			http_method := a_http_method
			has_description := False
		ensure
			nickname_set: nickname.is_equal (a_nickname)
			path_set: path.is_equal (a_path)
			description_set: not has_description
			parameters_set: parameters = a_parameter_list
			return_set: return = a_return
			http_method_set: http_method.is_equal (a_http_method)
		end

	make_with_description (a_nickname: READABLE_STRING;
						   a_path: READABLE_STRING;
						   a_description: READABLE_STRING;
						   a_parameter_list: READABLE_INDEXABLE [PARAMETER];
						   a_return: TYPEDEF_I;
						   a_http_method: READABLE_STRING)
		require
			description_not_empty: not a_description.is_empty
		do
			nickname := a_nickname
			path := a_path
			description := a_description
			parameters := a_parameter_list
			return := a_return
			http_method := a_http_method
			has_description := True
		ensure
			nickname_set: nickname.is_equal (a_nickname)
			path_set: path.is_equal (a_path)
			description_set: has_description and description.is_equal (a_description)
			parameters_set: parameters = a_parameter_list
			return_set: return = a_return
			http_method_set: http_method.is_equal (a_http_method)
		end

feature -- Access

	name: READABLE_STRING
		do
			Result := nickname
		end

	nickname: READABLE_STRING
			-- Nickname

	path: READABLE_STRING

	has_description: BOOLEAN

	description: READABLE_STRING

	parameters: READABLE_INDEXABLE [PARAMETER]

	return: TYPEDEF_I

	http_method: READABLE_STRING

feature -- Status report

	has_authorization_parameter: BOOLEAN
			-- Does this method have an Authorization parameter ?
		do
			across parameters as p
			loop
				if p.item.is_authorization then
					Result := True
				end
			end
		end

end
