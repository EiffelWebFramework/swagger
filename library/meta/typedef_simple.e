note
	description: "Simple or built-in (in JSON) types, immutable."
	author: "Benoît Marchal"

class
	TYPEDEF_SIMPLE

inherit
	TYPEDEF_I

inherit {NONE}
	STRING_ANCHOR
		undefine
			is_equal
		end

create {SHARED_SIMPLE_TYPEDEF}
	make, make_no_good

feature {NONE} -- Constructor

	make (a_name: READABLE_STRING)
		do
			name := make_immutable_string (a_name)
			is_no_good := False
		ensure
			name_set: name.is_equal (a_name)
			no_good_set: not is_no_good
		end

	make_no_good
		do
--			check false end
			create {IMMUTABLE_STRING_8}name.make_from_string ("IZNOGOUD")
			is_no_good := True
		ensure
			no_good_set: is_no_good
		end

feature -- Access

	name: like {TYPEDEF_I}.name

	is_no_good: BOOLEAN

	is_simple: BOOLEAN
		do
			Result := True
		end

	is_facet: BOOLEAN
		do
			Result := False
		end

	is_array: BOOLEAN
		do
			Result := False
		end

	is_record: BOOLEAN
		do
			Result := False
		end

	is_canonical: BOOLEAN
		do
			Result := True
		end

	has_array: BOOLEAN
		do
			Result := False
		end

invariant
	simple: is_simple

end
