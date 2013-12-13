note
	description: "Compile the models element in a SWAGGER declaration."
	author: "Benoit Marchal"

class
	SWAGGER_MODELS_FACTORY

inherit
    SHARED_MESSENGER
    SHARED_SIMPLE_TYPEDEF
    REFACTORING_HELPER

inherit {NONE}
    JSON_OBJECT_WRAPPER

create
	make, make_empty

feature {NONE} -- Constructor

	make (a_filename: like filename; the_models: JSON_OBJECT)
		do
			filename := a_filename
			models := the_models
			create declarations.make (10)
			compile
		ensure
			filename_set: filename = a_filename
			models_set: models = the_models
		end

	make_empty
		do
			create {IMMUTABLE_STRING}filename.make_empty
			create models.make
			create declarations.make (0)
		end

feature -- Access

	item (a_key: like {STRING_ANCHOR}.string_anchor): TYPEDEF_I
		do
			if attached declarations.item (a_key) as a_declaration then
				Result := a_declaration
			else
				Result := Nogood_def
			end
		end

feature {NONE} -- Implementation

	declarations: HASH_TABLE [TYPEDEF_I, like {STRING_ANCHOR}.string_anchor]
	level: INTEGER
	models: JSON_OBJECT
	filename: like {STRING_ANCHOR}.string_anchor

	compile
		do
			level := 1
			across models
				as m
			loop
				if not declarations.has (m.key.item) then
					declarations.force (compile_declaration (m.key), m.key.item)
				end
			end
			check level_ok: level = 1 end
		end

	is_type_array (a_definition: JSON_OBJECT): BOOLEAN
		do
			Result := has_string (a_definition, type)
						and then string_item (a_definition, type).is_case_insensitive_equal ("array")
		end

	is_type_record (a_definition: JSON_OBJECT): BOOLEAN
		do
			Result := has_object (a_definition, properties)
		end

	compile_array (a_definition: JSON_OBJECT): TYPEDEF_I
		require
			type_array: is_type_array (a_definition)
		local
			a_content: JSON_OBJECT
			a_type: TYPEDEF_I
		do
			if has_object (a_definition, items) then
				a_content := object_item (a_definition, items)
				if has_string (a_content, ref) then
					a_type := lookup_declaration (json_string_item (a_content, ref))
				else
					a_type := compile_type (a_content)
				end
				create {TYPEDEF_ARRAY}Result.make (a_type)
			else
				messenger.report_missing_field (create {SWAGGER_LOCATOR}.make_with_file (filename, a_definition),
												items.item)
				Result := Nogood_def
			end
		end

	compile_record (a_definition: JSON_OBJECT): TYPEDEF_I
		require
			type_record: is_type_record (a_definition)
		local
			a_type: TYPEDEF_I
			a_content: ARRAY [FIELD]
			a_field: FIELD
		do
			if has_object (a_definition, properties) then
				create a_content.make_empty
				across object_item (a_definition, properties)
					as p
				loop
					if attached {JSON_OBJECT} p.item as an_object then
						a_type := compile_type (an_object)
						if has_string (an_object, description) then
							create a_field.make_with_description (p.key.item,
							                                      a_type,
							                                      string_item (an_object, description))
						else
							create a_field.make (p.key.item, a_type)
						end
						a_content.force (a_field, a_content.count + 1)
					else
						messenger.report_invalid_field (create {SWAGGER_LOCATOR}.make_with_file (filename, p.item),
														type.item)
					end
				end

				create {TYPEDEF_RECORD} Result.make (a_content)
			else
				messenger.report_missing_field (create {SWAGGER_LOCATOR}.make_with_file (filename, a_definition),
												properties.item)
				Result := Nogood_def
			end
		end

	compile_type (a_definition: JSON_OBJECT): TYPEDEF_I
		do
			if has_string (a_definition, type) and then is_jsonschema_simple_type (string_item (a_definition, type)) then
				Result := jsonschema_to_simple_typedef (string_item (a_definition, type))
			elseif is_type_array (a_definition) then
				Result := compile_array (a_definition)
			elseif is_type_record (a_definition) then
				Result := compile_record (a_definition)
			elseif has_string (a_definition, type) then
				Result := lookup_declaration (string_item (a_definition, type))
			else
				messenger.report_missing_field (create {SWAGGER_LOCATOR}.make_with_file (filename, a_definition),
												type.item)
				Result := Nogood_def
			end
		end

	lookup_declaration (a_key: JSON_STRING): TYPEDEF_I
		do
			fixme ("Implement loops, i.e. we reference the type itself or one of its parents")
			if attached declarations.item (a_key.item) as a_declaration then
				Result := a_declaration
			else
				if level < 9 then
					Result := compile_declaration (a_key)
				else
					messenger.report_field (create {SWAGGER_LOCATOR}.make_with_file (filename, a_key),
											"Most likely a loop, proper loop detection not implemented (yet)")
					Result := Nogood_def
				end
			end
		end

	compile_declaration (a_key: JSON_STRING): TYPEDEF_I
		require
			-- this is a crude loop detection mecanism
			not_too_deep: level < 10
			not_compiled: not declarations.has (a_key.item)
		local
			a_declaration: JSON_OBJECT
		do
			level := level + 1
			if has_object (models, a_key) then
				a_declaration := object_item (models, a_key)
				if has_string (a_declaration, id) then
					if string_item (a_declaration, id).is_equal (a_key.item) then
						Result := compile_record (a_declaration)
					else
						messenger.report_expected_value (create {SWAGGER_LOCATOR}.make_with_file (filename, a_declaration),
														 a_key.item,
														 string_item (a_declaration, id))
						Result := Nogood_def
					end
				else
					messenger.report_missing_field (create {SWAGGER_LOCATOR}.make_with_file (filename, a_declaration),
												    id.item)
					Result := Nogood_def
				end
			else
				messenger.report_missing_reference (create {SWAGGER_LOCATOR}.make_with_file (filename, models),
													a_key.item,
													is_swagger_simple_type (a_key.item))
				Result := Nogood_def
			end
			level := level - 1
		end

feature {NONE} -- Constants

	description: JSON_STRING
		once
			create Result.make_json ("description")
		end

	id: JSON_STRING
		once
			create Result.make_json ("id")
		end
	properties: JSON_STRING
		once
			create Result.make_json ("properties")
		end
	type: JSON_STRING
		once
			create Result.make_json ("type")
		end
	items: JSON_STRING
		once
			create Result.make_json ("items")
		end
	ref: JSON_STRING
		once
			create Result.make_json ("$ref")
		end

end
