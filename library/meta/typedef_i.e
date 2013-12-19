note
	description: "The definition of a type. Should be immutable."
	author: "Benoît Marchal"

deferred class
	TYPEDEF_I

inherit
	ANY
		redefine
			is_equal
		end

	HASHABLE
		undefine
			is_equal
		end

feature -- Access

	name: READABLE_STRING
		deferred
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := name.hash_code
		end

feature -- Status report

	is_no_good: BOOLEAN
		deferred
		end

	is_simple: BOOLEAN
		deferred
		end

	is_facet: BOOLEAN
		deferred
		end

	is_array: BOOLEAN
		deferred
		end

	is_record: BOOLEAN
		deferred
		end

	is_canonical: BOOLEAN
			-- this type define a strict "canonical" hierarchy
			-- (no graph, no duplicates, no element after the possible array)
		deferred
		end

	has_array: BOOLEAN
			-- not to be confused with is_array, see post-condition
		deferred
		ensure
			simples_has_no_array: is_simple or is_facet implies Result = False
			array_has_array: is_array implies Result = True
			record_may_have_array: is_record implies Result = across as_record as field some field.item.type.has_array end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is type equal to `other'?
		do
			Result := name.is_equal (other.name)
		end

feature -- Conversion

	as_simple: TYPEDEF_SIMPLE
		require
			simple: is_simple
		do
			check attached {TYPEDEF_SIMPLE} Current as a_simple then
				Result := a_simple
			end
		end

	as_string_facet: TYPEDEF_FACET [READABLE_STRING]
		require
			facet: is_facet
		do
			check attached {TYPEDEF_FACET [READABLE_STRING]} Current as a_facet then
				Result := a_facet
			end
		end

	as_integer_facet: TYPEDEF_FACET [INTEGER]
		require
			facet: is_facet
		do
			check attached {TYPEDEF_FACET [INTEGER]} Current as a_facet then
				Result := a_facet
			end
		end

	as_array: TYPEDEF_ARRAY
		require
			array: is_array
		do
			check attached {TYPEDEF_ARRAY} Current as an_array then
				Result := an_array
			end
		end

	as_record: TYPEDEF_RECORD
		require
			record: is_record
		do
			check attached {TYPEDEF_RECORD} Current as a_record then
				Result := a_record
			end
		end

invariant
--	immutable: name.is_immutable
	coherent: is_simple xor is_facet xor is_array xor is_record

end
