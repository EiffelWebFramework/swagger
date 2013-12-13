note
	description: "A field is one piece of data, it has a name and a type. Should be immutable."
	author: "Benoît Marchal"

class
	FIELD

inherit
	PACKAGEABLE_I

inherit {NONE}
	STRING_ANCHOR

create
	make, make_with_description

feature {NONE} -- Initialization

	make (a_name: like name; a_type: like type)
		require
			name_not_empty: not a_name.is_empty
		do
			name := make_immutable_string (a_name)
			type := a_type
			has_description := False
			create {IMMUTABLE_STRING_8}description.make_empty
		ensure
			name_set: name.is_equal (a_name)
			type_set: type = a_type
			description_flag_set: not has_description
			description_set: description.is_empty
		end

	make_with_description (a_name: like name; a_type: like type; a_description: like description)
		require
			name_not_empty: not a_name.is_empty
			description_not_empty: not a_description.is_empty
		do
			name := make_immutable_string (a_name)
			type := a_type
			has_description := True
			description := make_immutable_string (a_description)
		ensure
			name_set: name.is_equal (a_name)
			type_set: type = a_type
			description_flag_set: has_description
			description_set: description.is_equal (a_description)
		end

feature -- Access

	name: like {PACKAGEABLE_I}.name

	description: like {PACKAGEABLE_I}.description

	has_description: like {PACKAGEABLE_I}.has_description

	type: TYPEDEF_I

invariant
	name_not_empty: not name.is_empty

end
