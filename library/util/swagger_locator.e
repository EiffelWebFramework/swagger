note
	description: "A default SWAGGER_LOCATOR_I implementation."
	author: "Benoît Marchal"

class
	SWAGGER_LOCATOR

inherit
	SWAGGER_LOCATOR_I

inherit {NONE}
	STRING_ANCHOR
		undefine is_equal end

create
	make_with_uri, make_with_file, make_with_json_only, make_with_file_only

feature {NONE} -- Constructor

	make_with_uri (an_uri: like uri; a_value: JSON_VALUE)
		require
			uri_not_empty: not an_uri.is_empty
		do
			uri := make_immutable_string (an_uri)
			json := make_immutable_string (a_value.representation)
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
			json := make_immutable_string (a_value.representation)
			is_json_null := attached {JSON_NULL} a_value
			has_uri := False
		ensure
			json_set: json.is_equal (a_value.representation)
			json_null_set: is_json_null = attached {JSON_NULL} a_value
			invalid_uri: not has_uri
			json_null_set: is_json_null = attached {JSON_NULL} a_value
		end

	make_with_file (a_filename: like string_anchor; a_value: JSON_VALUE)
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

	make_with_file_only (a_filename: like string_anchor)
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

	uri: like {SWAGGER_LOCATOR_I}.uri
	json: like {SWAGGER_LOCATOR_I}.json
	has_uri: like {SWAGGER_LOCATOR_I}.has_uri
	is_json_null: like {SWAGGER_LOCATOR_I}.is_json_null

feature {NONE} -- Constants

	no_uri: IMMUTABLE_STRING
		once
			-- see http://en.wikipedia.org/wiki/About_URI_scheme
			create Result.make_from_string ("about:invalid")
		end

end
