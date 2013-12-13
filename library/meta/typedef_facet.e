note
	description: "A facet is a restriction on a simple type. Immutable."
	author: "Benoît Marchal"

class
	TYPEDEF_FACET [T -> COMPARABLE]

inherit
	TYPEDEF_I
		undefine
			is_equal
		end

	REFACTORING_HELPER

create
	make_list, make_range

feature {NONE} -- Constructor

	make_list (an_ancestor: TYPEDEF_SIMPLE; a_list: like list)
		do
			ancestor := an_ancestor
			list := a_list.twin
			is_list := True
		ensure
			ancestor_set: ancestor = an_ancestor
			list_set: list.is_equal (a_list)
			is_list = True
		end

	make_range (an_ancestor: TYPEDEF_SIMPLE; a_from: T; a_to: T)
		do
			ancestor := an_ancestor
			create list.make_empty
			list.force (a_from, 1)
			list.force (a_to, 2)
			is_list := False
		ensure
			ancestor_set: ancestor = an_ancestor
			from_set: list [1] = a_from
			to_set: list [2] = a_to
		end

feature -- Access

	name: like {TYPEDEF_I}.name
		local
			a_buffer: STRING
		once ("OBJECT")
			create a_buffer.make_from_string (ancestor.name)
			a_buffer.append_character ('{')
			across list as i
			loop
				if i.cursor_index > 1 then
					if is_list then
						a_buffer.append_character (',')
					else
						a_buffer.append_character ('-')
					end
				end
				a_buffer.append (i.item.out)
			end
			a_buffer.append_character ('}')
			Result := ancestor.name
		end

	is_no_good: BOOLEAN
		do
			Result := ancestor.is_no_good
		end

	is_simple: BOOLEAN
		do
			Result := False
		end

	is_facet: BOOLEAN
		do
			Result := True
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

	is_list: BOOLEAN

	ancestor: TYPEDEF_SIMPLE

feature -- Comparison

	is_value_allowed (a_value: T): BOOLEAN
		do
			to_implement ("test acceptability of items")
		end

feature {NONE} -- Implementation

	list: ARRAY [T]

invariant
	facet: is_facet

end
