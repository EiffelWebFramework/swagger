note
	description: "Just a bunch of utility stuff for strings (missing from built-in strings, really)."
	author: "Benoît Marchal"

deferred class
	STRING_ANCHOR

feature -- Immutability change

	make_immutable_string (a_string: like string_anchor): like string_anchor
		do
			if a_string.is_immutable then
				Result := a_string
			else
				create {IMMUTABLE_STRING_8}Result.make_from_string (a_string)
			end
		ensure
			immutable: Result.is_immutable
		end

feature -- Anchor

	string_anchor: READABLE_STRING_8
		do
			-- we return something just to please the void-safe compiler
			create {IMMUTABLE_STRING_8}Result.make_empty
		end

feature -- Path concatenation

	compute_absolute_path (base_path, relative_path: like string_anchor): like string_anchor
		local
			buffer: STRING
		do
			if relative_path.starts_with ("http://") then
				Result := make_immutable_string (relative_path)
			else
				if not base_path.is_empty then
			   		create buffer.make_from_string (base_path)
				else
					create buffer.make_from_string (localhost)
				end
			   	if buffer.ends_with ("/") and relative_path.starts_with ("/") then
			   		buffer.keep_head (buffer.count - 1)
			   	elseif not buffer.ends_with ("/") and not relative_path.starts_with ("/") then
			   		buffer.append_character ('/')
			   	end
		   		buffer.append (relative_path)
		   		create {IMMUTABLE_STRING_8}Result.make_from_string (buffer)
			end
		ensure
			coherent: Result.ends_with (relative_path)
			immutable: Result.is_immutable
		end

feature {NONE} -- Constant

	localhost: READABLE_STRING_8
		once
			create {IMMUTABLE_STRING_8}Result.make_from_string ("http://localhost/")
		ensure
			immutable: Result.is_immutable
		end

end
