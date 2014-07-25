note
	description: "Type of the parameter (that is, the location of the parameter in the request)."
	author: "Benoît Marchal"

class
	SWAGGER_PARAMETER_TYPE

create
	make,
	make_from_body,
	make_from_path,
	make_from_query,
	make_from_form

feature {NONE} -- Initialization

	make (a_name: STRING)
		require
			valid: valid (a_name)
		do
			origin := origins.item (a_name)
		end

	make_from_body
		do
			origin := 1
		ensure
			origin_set: origin = 1
		end

	make_from_path
		do
			origin := 2
		ensure
			origin_set: origin = 2
		end

	make_from_query
		do
			origin := 3
		ensure
			origin_set: origin = 3
		end

	make_from_header
		do
			origin := 4
		ensure
			origin_set: origin = 4
		end

	make_from_form
		do
			origin := 5
		ensure
			origin_set: origin = 5
		end

feature -- Access

	is_from_body: BOOLEAN
		do
			Result := origin = 1
		end

	is_from_path: BOOLEAN
		do
			Result := origin = 2
		end

	is_from_query: BOOLEAN
		do
			Result := origin = 3
		end

	is_from_header: BOOLEAN
		do
			Result := origin = 4
		end

	is_from_form: BOOLEAN
		do
			Result := origin = 5
		end

feature -- Status report

	valid (a_name: STRING): BOOLEAN
		do
			Result := origins.has (a_name)
		end

feature {NONE} -- Implementation

	origins: DS_HASH_TABLE [INTEGER, STRING]
		do
			create Result.make_default
			Result.force_last (1, "body")
			Result.force_last (2, "path")
			Result.force_last (3, "query")
			Result.force_last (4, "header")
			Result.force_last (5, "form")
		end

	origin: INTEGER

invariant
	origin_valid: origin > 0 and origin < 6

end
