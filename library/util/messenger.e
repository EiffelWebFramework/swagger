note
	description: "Record error and warning messages."
	author: "Benoît Marchal"

class
	MESSENGER

inherit
	REFACTORING_HELPER

create
	make

feature {NONE} -- Constructor

	make
		do
			create fields.make (3)
			fields.compare_objects
			create queries.make (3)
			queries.compare_objects
		end

feature -- Access

	has_errors: BOOLEAN
		do
			Result := fields.count /= 0 or queries.count /= 0
		end

feature -- Reporting (fields)

	report_field (a_locator: SWAGGER_LOCATOR_I; a_message: STRING)
		require
			message_not_empty: not a_message.is_empty
		local
			an_array: ARRAY [STRING]
		do
			if fields.has_key (a_locator) and then attached fields.at (a_locator) as the_messages then
				if not the_messages.has (a_message) then
					the_messages.force (a_message, the_messages.count + 1)
				end
			else
				create an_array.make_filled (a_message, 1, 1)
				an_array.compare_objects
				fields.force (an_array, a_locator)
			end
		end

	report_io_error (a_locator: SWAGGER_LOCATOR_I)
		require
			locator_has_uri: a_locator.has_uri
		do
			report_field (a_locator, "I/O failure")
		end

	report_parsing_error (a_locator: SWAGGER_LOCATOR_I; a_parser: JSON_PARSER)
		require
			locator_has_uri: a_locator.has_uri
			parser_has_errors: not a_parser.errors.is_empty
		local
			a_message: STRING
		do
			a_message := "Parsing error(s): "
			a_message.append (a_parser.current_errors)
			report_field (a_locator, a_message)
		end

	report_missing_field (a_locator: SWAGGER_LOCATOR_I; a_field_name: STRING)
		require
			field_name_not_empty: not a_field_name.is_empty
		local
			a_message: STRING
		do
			a_message := "Missing: %'"
			a_message.append (a_field_name)
			a_message.append_character ('%'')
			report_field (a_locator, a_message)
		end

	report_missing_reference (a_locator: SWAGGER_LOCATOR_I; a_reference: STRING; a_hint: BOOLEAN)
		require
			reference_not_empty: not a_reference.is_empty
		local
			a_message: STRING
		do
			a_message := "Undeclared reference: %'"
			a_message.append (a_reference)
			a_message.append_character ('%'')
			if a_hint then
				a_message.append (" (you may have used SWAGGER datatypes where JSON datatypes are expected, e.g. %'int%' instead of %'integer%')")
			end
			report_field (a_locator, a_message)
		end

	report_invalid_field (a_locator: SWAGGER_LOCATOR_I; a_field_name: STRING)
		require
			field_name_not_empty: not a_field_name.is_empty
		local
			a_message: STRING
		do
			a_message := "Invalid data: %'"
			a_message.append (a_field_name)
			a_message.append_character ('%'')
			report_field (a_locator, a_message)
		end

	report_expected_value (a_locator: SWAGGER_LOCATOR_I; an_expected, a_found: STRING)
		require
			expected_not_empty: not an_expected.is_empty
		local
			a_message: STRING
		do
			a_message := "Expected : %'"
			a_message.append (an_expected)
			a_message.append ("%' found %'")
			a_message.append (a_found)
			a_message.append ("%' instead")
			report_field (a_locator, a_message)
		end

	report_invalid_index (a_locator: SWAGGER_LOCATOR_I; an_index: INTEGER)
		local
			a_message: STRING
		do
			a_message := "No index: ["
			a_message.append_integer (an_index)
			a_message.append_character (']')
			report_field (a_locator, a_message)
		end

feature -- Removal

	wipe_out
		do
			fields.wipe_out
			queries.wipe_out
		end

feature -- Display

	errors_representation: STRING
		require
			has_errors: has_errors
		local
			a_buffer: STRING
			a_proper_length: INTEGER
		do
			create Result.make_empty
			a_proper_length := 45
			across fields as f
			loop
				if f.key.has_uri then
					Result.append (f.key.uri)
					Result.append (" - ")
				end
				if not f.key.is_json_null then
					a_buffer := f.key.json
					if a_buffer.count > a_proper_length then
						a_buffer.keep_head (a_proper_length - 3)
						a_buffer.append ("...")
					end
					Result.append (a_buffer)
				end
				if f.item.count = 1 then
					Result.append (": ")
					Result.append (f.item [1])
					Result.append ("%N")
				else
					Result.append (":%N")
					across f.item as m
					loop
						Result.append ("   ")
						Result.append (m.item)
						Result.append ("%N")
					end
				end
			end
			across queries as q
			loop
				a_buffer := q.key
				if a_buffer.count > a_proper_length then
					a_buffer.keep_head (a_proper_length - 3)
					a_buffer.append ("...")
				end
				Result.append (a_buffer)
				if q.item.count = 1 then
					Result.append (": ")
					Result.append (q.item [1])
					Result.append ("%N")
				else
					Result.append (":%N")
					across q.item as m
					loop
						Result.append ("   ")
						Result.append (m.item)
						Result.append ("%N")
					end
				end
			end
		end

feature -- Access

	http_status_code: INTEGER
		once
			Result := {HTTP_STATUS_CODE}.internal_server_error
		end

feature {NONE} -- Implementation

	fields: HASH_TABLE [ARRAY [STRING], SWAGGER_LOCATOR_I]
	queries: HASH_TABLE [ARRAY [STRING], STRING]

invariant
	report_field_errors: fields.count /= 0 implies has_errors
	report_query_errors: queries.count /= 0 implies has_errors
	object_comparison_fields: across fields as f all f.item.object_comparison end
	object_comparison_queries: across queries as q all q.item.object_comparison end

end
