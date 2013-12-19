note
	description: "Simple types or built-in (in JSON) types."
	author: "Benoît Marchal"

class
	TYPEDEF_RECORD

inherit
	TYPEDEF_I

create
	make

feature {NONE} -- Initialization

	make (some_fields: READABLE_INDEXABLE [FIELD])
		require
			some_fields_not_void: some_fields /= Void
		do
			fields := some_fields
		ensure
			fields_set: fields = some_fields
		end

feature -- Access

	name: READABLE_STRING
		local
			a_buffer: STRING
		once ("OBJECT")
			a_buffer := "("
			across fields as c
			loop
				a_buffer.append (c.item.name)
				if not c.is_last then
					a_buffer.append (", ")
				end
			end
			a_buffer.append (")")
			Result := a_buffer
		end

    fields: READABLE_INDEXABLE [FIELD]

feature -- Status report

	is_no_good: BOOLEAN
		once ("OBJECT")
			Result := across fields as f some f.item.type.is_no_good end
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
			Result := False
		end

	is_record: BOOLEAN
		do
			Result := True
		end

	is_canonical: BOOLEAN
		local
			a_count: INTEGER
		once ("OBJECT")
			across fields
				as a_field
			from
				a_count := 0
			until
				-- optimisation: inutile de poursuivre le parcours
				a_count > 1
			loop
				-- we count the first array and any element after it
				if a_field.item.type.has_array or a_count >= 1 then
					a_count := a_count + 1
				end
			end
			-- we only accept one array, no element after it
			Result := not (a_count > 1)
		end

	has_array: BOOLEAN
		once ("OBJECT")
			Result := across fields as f some f.item.type.has_array end
		end

invariant
	record: is_record
	fields_not_void: fields /= Void

end
