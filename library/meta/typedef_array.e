note
	description: "Array (collection in JSON) types, immutable."
	author: "Benoît Marchal"

class
	TYPEDEF_ARRAY

inherit
	TYPEDEF_I

inherit {NONE}
	STRING_ANCHOR
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Constructor

	make (an_item_type: TYPEDEF_I)
		do
			item_type := an_item_type
		ensure
			item_type_set: item_type = an_item_type
		end

feature -- Access

	name: like {TYPEDEF_I}.name
		local
			a_name: STRING
		once ("OBJECT")
			a_name := "ARRAY ["
			a_name.append (item_type.name)
			a_name.append_character (']')
			Result := make_immutable_string (a_name)
		end

	is_no_good: BOOLEAN
		do
			Result := item_type.is_no_good
		end

	is_simple: BOOLEAN
		do
			Result := False
		end

	is_facet: BOOLEAN
		do
			Result := False
		end

	is_array: BOOLEAN
		do
			Result := True
		end

	is_record: BOOLEAN
		do
			Result := False
		end

	is_canonical: BOOLEAN
		do
			Result := item_type.is_canonical
		end

	has_array: BOOLEAN
		do
			Result := True
		end

	item_type: TYPEDEF_I

invariant
	array: is_array

end
