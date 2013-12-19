note
	description: "A package contains a set of methods."
	author: "Benoît Marchal"

class
	PACKAGE

inherit
	PACKAGEABLE_I

create
	make, make_with_description

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING; some_methods: ARRAY [METHOD])
		do
			name := a_name
			methods := some_methods
			has_description := False
			create {IMMUTABLE_STRING_8}description.make_empty
		ensure
			name_set: name.is_equal (a_name)
			methods_set: methods = some_methods
			no_description: not has_description
		end

	make_with_description (a_name: READABLE_STRING; a_description: READABLE_STRING; some_methods: ARRAY [METHOD])
		do
			name := a_name
			methods := some_methods
			description := a_description
			has_description := True
		ensure
			name_set: name.is_equal (a_name)
			description_set: description.is_equal (a_description)
			methods_set: methods = some_methods
			has_description: has_description
		end

feature -- Access

	name: READABLE_STRING

	description: READABLE_STRING

	methods: READABLE_INDEXABLE [METHOD]

	key: detachable STRING
			-- Resource key

feature -- Status report

	has_description: BOOLEAN

	first_level: BOOLEAN

feature -- Element Change		

	enable_first_level
		do
			first_level := true
		end

	set_key (a_key: STRING)
			-- Set `key' to `a_key'.
		do
			key := a_key
		ensure
			key_set: key = a_key
		end

end
