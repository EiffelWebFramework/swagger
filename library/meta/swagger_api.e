note
	description: "Objects that describe one or more operations on a single path. "
	author: "Benoît Marchal"

class
	SWAGGER_API

create
	make,
	make_with_description

feature {NONE} -- Initialization

	make (a_path: READABLE_STRING; some_operations: ARRAY [SWAGGER_OPERATION])
			-- Create an API.
		do
			path := a_path
			operations := some_operations
		ensure
			path_set: path = a_path
			operations_set: operations = some_operations
		end

	make_with_description (a_path: READABLE_STRING; a_description: READABLE_STRING; some_operations: ARRAY [SWAGGER_OPERATION])
			-- Create an API with a description.
		do
			path := a_path
			operations := some_operations
			description := a_description
		ensure
			path_set: path = a_path
			description_set: description = a_description
			operations_set: operations = some_operations
		end

feature -- Access

	path: READABLE_STRING
			-- Relative path to the operation, from the basePath,
			-- which this operation describes

	description: detachable READABLE_STRING
			-- Short description of the resource

	operations: READABLE_INDEXABLE [SWAGGER_OPERATION]
			-- List of the API operations available on this path

	key: detachable STRING
			-- Resource key

feature -- Status report

	first_level: BOOLEAN
			-- Is this a first level API ?

feature -- Element Change		

	enable_first_level
			-- Set `first_level' to `true'.
		do
			first_level := true
		ensure
			first_level: first_level
		end

	set_key (a_key: STRING)
			-- Set `key' to `a_key'.
		do
			key := a_key
		ensure
			key_set: key = a_key
		end

end
