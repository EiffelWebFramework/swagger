note
	description: "A default SWAGGER_LOCATOR_I implementation."
	author: "Benoît Marchal"

class
	SWAGGER_LOCATOR

inherit
	SWAGGER_LOCATOR_I

create
	make_with_uri, make_with_file, make_with_json_only, make_with_file_only

feature {NONE} -- Constructor

	make_with_uri (an_uri: READABLE_STRING; a_value: JSON_VALUE)
		require
			uri_not_empty: not an_uri.is_empty
		do
			uri := an_uri
			json := a_value.representation
			is_json_null := attached {JSON_NULL} a_value
			has_uri := True
		ensure
			uri_set: uri.is_equal (an_uri)
			json_set: json.is_equal (a_value.representation)
			valid_uri: has_uri
			json_null_set: is_json_null = attached {JSON_NULL} a_value
		end

	make_with_json_only (a_value: JSON_VALUE)
		do
			uri := no_uri
			json := a_value.representation
			is_json_null := attached {JSON_NULL} a_value
			has_uri := False
		ensure
			json_set: json.is_equal (a_value.representation)
			json_null_set: is_json_null = attached {JSON_NULL} a_value
			invalid_uri: not has_uri
			json_null_set: is_json_null = attached {JSON_NULL} a_value
		end

	make_with_file (a_filename: READABLE_STRING; a_value: JSON_VALUE)
		require
			filename_not_empty: not a_filename.is_empty
		local
			an_uri: STRING
		do
			an_uri := "file:"
			an_uri.append (a_filename)
			make_with_uri (an_uri, a_value)
		ensure
			uri_set: uri.starts_with ("file:") and uri.ends_with (a_filename)
			json_set: json.is_equal (a_value.representation)
			valid_uri: has_uri
			json_null_set: is_json_null = attached {JSON_NULL} a_value
		end

	make_with_file_only (a_filename: READABLE_STRING)
		require
			filename_not_empty: not a_filename.is_empty
		do
			make_with_file (a_filename, create {JSON_NULL})
		ensure
			uri_set: uri.starts_with ("file:") and uri.ends_with (a_filename)
			valid_uri: has_uri
			json_null_set: is_json_null
		end

feature -- Access

	uri: READABLE_STRING
	json: READABLE_STRING
	has_uri: BOOLEAN
	is_json_null: BOOLEAN

feature {NONE} -- Constants

	no_uri: IMMUTABLE_STRING
		once
			-- see http://en.wikipedia.org/wiki/About_URI_scheme
			create Result.make_from_string ("about:invalid")
		end

end
