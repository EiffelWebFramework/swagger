note
	description: "Something you can place in a package."
	author: "Benoît Marchal"

deferred class
	PACKAGEABLE_I

feature -- Access

	name: like {STRING_ANCHOR}.string_anchor
		deferred
		end

	has_description: BOOLEAN
		deferred
		end

	description: like {STRING_ANCHOR}.string_anchor
		require
			has_description: has_description
		deferred
		end

invariant
	immutable: name.is_immutable and (has_description implies description.is_immutable)
	coherent_flag: has_description implies not description.is_empty

end
