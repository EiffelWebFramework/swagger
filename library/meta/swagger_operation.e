note
	description: "Objects that describe a single operation on a path."
	author: "Benoît Marchal"

class
	SWAGGER_OPERATION

create
	make

feature {NONE} -- Initialization

	make (a_nickname: READABLE_STRING;
		  a_path: READABLE_STRING;
		  a_parameter_list: READABLE_INDEXABLE [SWAGGER_PARAMETER];
		  a_return: TYPEDEF_I;
		  a_method: READABLE_STRING)
			-- Create an operation.
		do
			nickname := a_nickname
			path := a_path
			parameters := a_parameter_list
			return := a_return
			method := a_method
		ensure
			nickname_set: nickname = a_nickname
			path_set: path = a_path
			parameters_set: parameters = a_parameter_list
			return_set: return = a_return
			method_set: method = a_method
		end

feature -- Access

	nickname: READABLE_STRING
			-- Unique id for the operation that can be used by tools
			-- reading the output for further and easier manipulation

	path: READABLE_STRING
			-- Relative path to the operation, from the basePath,
			-- which this operation describes

	parameters: READABLE_INDEXABLE [SWAGGER_PARAMETER]
			-- Inputs to the operation

	return: TYPEDEF_I
			-- Return type

	method: READABLE_STRING
			-- HTTP method required to invoke this operation

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
