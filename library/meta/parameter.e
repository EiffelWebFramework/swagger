note
	description: "A parameter (in a method call description). Immutable."
	author: "Benoît Marchal"

class
	PARAMETER

inherit
	FIELD
		rename make as field_make, make_with_description as field_make_with_description end

inherit {NONE}
	STRING_ANCHOR

create
	make, make_with_description

feature {NONE} -- Constructor

	make (a_name: like name;
		  a_type: like type;
		  an_origin: like origin;
		  a_default_value: like default_value;
		  a_required_flag, an_unbounded_flag: BOOLEAN)
		require
			name_not_empty: not a_name.is_empty
		do
			name := make_immutable_string (a_name)
			type := a_type
			has_description := False
			create {IMMUTABLE_STRING_8}description.make_empty
			origin := an_origin
			default_value := a_default_value
			is_required := a_required_flag
			is_unbounded := an_unbounded_flag
		ensure
			name_set: name.is_equal (a_name)
			description_set: not has_description
			type_set: type = a_type
			origin_set: origin = an_origin
			default_value_set: default_value = a_default_value
			required_set: is_required = a_required_flag
			unbounded_set: is_unbounded = an_unbounded_flag
		end

	make_with_description (a_name: like name;
						   a_description: like description;
						   a_type: like type;
						   an_origin: like origin;
		  				   a_default_value: like default_value;
						   a_required_flag, an_unbounded_flag: BOOLEAN)
		require
			name_not_empty: not a_name.is_empty
			description_not_empty: not a_description.is_empty
		do
			name := make_immutable_string (a_name)
			type := a_type
			has_description := True
			description := make_immutable_string (a_description)
			origin := an_origin
			default_value := a_default_value
			is_required := a_required_flag
			is_unbounded := an_unbounded_flag
		ensure
			name_set: name.is_equal (a_name)
			description_set: has_description and description.is_equal (a_description)
			type_set: type = a_type
			origin_set: origin = an_origin
			default_value_set: default_value = a_default_value
			required_set: is_required = a_required_flag
			unbounded_set: is_unbounded = an_unbounded_flag
		end

feature -- Access

	origin: PARAMETER_ORIGIN

	default_value: detachable READABLE_STRING

feature -- Status report

	is_required: BOOLEAN

	is_unbounded: BOOLEAN

	is_authorization: BOOLEAN
			-- Is it the Authorization parameter ?
		do
			Result := name.is_equal ("Authorization") and origin.is_from_header
		end

invariant
--	from_body_coherence: origin.is_from_body implies (type.is_record or type.is_array)
	from_header_path_query_coherence: (origin.is_from_header or origin.is_from_path or origin.is_from_query) implies type.is_simple
	from_path_required: origin.is_from_path implies is_required
	unbounded_possible: is_unbounded implies origin.is_from_query

end
