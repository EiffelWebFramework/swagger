note
	description: "Returns location information for SWAGGER."
	author: "Benoît Marchal"

deferred class
	SWAGGER_LOCATOR_I

inherit
	HASHABLE
		redefine
			is_equal
		end

feature -- Access

	uri: like {STRING_ANCHOR}.string_anchor
		deferred
		end

	json: like {STRING_ANCHOR}.string_anchor
		deferred
		end

	has_uri: BOOLEAN
		deferred
		end

	is_json_null: BOOLEAN
		deferred
		end

feature -- hash code

	hash_code: INTEGER
		do
			-- ensure it is positive
			Result := uri.hash_code.bit_xor (json.hash_code).hash_code
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := uri.is_equal (other.uri)
						 and json.is_equal (other.json)
						 and has_uri = has_uri
						 and is_json_null = is_json_null
		end

invariant
	immutable: uri.is_immutable and json.is_immutable

end
