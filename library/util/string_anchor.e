note
	description: "Just a bunch of utility stuff for strings (missing from built-in strings, really)."
	author: "Benoît Marchal"

deferred class
	STRING_ANCHOR

feature -- Immutability change

	make_immutable_string (a_string: READABLE_STRING): READABLE_STRING
		do
			if a_string.is_immutable then
				Result := a_string
			else
				create {IMMUTABLE_STRING_8}Result.make_from_string (a_string)
			end
		ensure
			immutable: Result.is_immutable
		end

end
