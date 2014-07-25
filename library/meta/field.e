note
	description: "A field is one piece of data, it has a name and a type. Should be immutable."
	author: "Benoît Marchal"

class
	FIELD

create
	make, make_with_description

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING; a_type: TYPEDEF_I)
		require
			a_name_not_empty: not a_name.is_empty
		do
			name := a_name
			type := a_type
			has_description := False
			create {IMMUTABLE_STRING_8}description.make_empty
		ensure
			name_set: name.is_equal (a_name)
			type_set: type = a_type
			description_flag_set: not has_description
			description_set: description.is_empty
		end

	make_with_description (a_name: READABLE_STRING; a_type: TYPEDEF_I; a_description: READABLE_STRING)
		require
			a_name_not_empty: not a_name.is_empty
			a_description_not_empty: not a_description.is_empty
		do
			name := a_name
			type := a_type
			has_description := True
			description := a_description
		ensure
			name_set: name.is_equal (a_name)
			type_set: type = a_type
			description_flag_set: has_description
			description_set: description.is_equal (a_description)
		end

feature -- Access

	name: READABLE_STRING

	description: READABLE_STRING

	has_description: BOOLEAN

	type: TYPEDEF_I

invariant
	name_not_empty: not name.is_empty

end
