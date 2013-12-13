note
	description: "A package is a set of methods. Immutable."
	author: "Benoît Marchal"

class
	PACKAGE

inherit
	PACK [METHOD]
		rename make as pack_make end
	PACKAGEABLE_I

create
	make, make_with_description

feature {NONE} -- Initialization

	make (a_name: like name; a_content: like content)
		do
			pack_make (a_content)
			name := make_immutable_string (a_name)
			has_description := False
			create {IMMUTABLE_STRING_8}description.make_empty
		ensure then
			name_set: name.is_equal (a_name)
			content_set: content.is_equal (a_content)
			no_description: not has_description
		end

	make_with_description (a_name: like name; a_description: like description; a_content: like content)
		do
			pack_make (a_content)
			name := make_immutable_string (a_name)
			description := make_immutable_string (a_description)
			has_description := True
		ensure
			name_set: name.is_equal (a_name)
			description_set: description.is_equal (a_description)
			content_set: content.is_equal (a_content)
			has_description: has_description
		end

feature -- Access

	name: like {PACKAGEABLE_I}.name

	description: like {PACKAGEABLE_I}.description

	has_description: like {PACKAGEABLE_I}.has_description

        key: detachable STRING
                        -- Resource key

feature -- Status report

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
