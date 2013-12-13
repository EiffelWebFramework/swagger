note
	description: "A pack is an immutable set of SWAGGER metadata. Technically the main difference with an array is that it is immutable."
	author: "Benoît Marchal"

class
	PACK [T -> attached PACKAGEABLE_I]

inherit
	ITERABLE [T]

inherit {NONE}
	STRING_ANCHOR

create
	make

feature {NONE} -- Initialization

	make (a_content: ARRAY [T])
		do
			-- we make a copy so Current is immutable
			content := a_content.twin
		ensure
			content_set: content.is_equal (a_content)
		end

feature -- Access

	new_cursor: PACK_CURSOR [T]
		do
			create Result.make (Current)
		end

	at (i: INTEGER): T
		require
			valid: valid_index (i)
		do
			Result := content.at (i)
		end

	has (a_name: like {PACKAGEABLE_I}.name): BOOLEAN
		do
			Result := attached detachable_item (a_name)
		end

	item alias "[]" (a_name: like {PACKAGEABLE_I}.name): T
		require
			has (a_name)
		do
			check attached detachable_item (a_name) as an_item then
				Result := an_item
			end
		end

	detachable_item (a_name: like {PACKAGEABLE_I}.name): detachable T
		do
			-- not a very efficient implementation but I expect
			-- (1) lists will be short
			-- (2) there will be very few calls to this
			Result := default_value
			across content as c
			loop
				if c.item.name.is_equal (a_name) then
					Result := c.item
				end
			end
		end

	knows (a_packageable: T): BOOLEAN
		do
			if attached detachable_item (a_packageable.name) as an_item then
				Result := an_item.is_equal (a_packageable)
			else
				Result := False
			end
		end

feature -- Measurement

	count: INTEGER
		do
			Result := content.count
		ensure
			positive: Result >= 0
		end

feature -- Status report

	is_empty: BOOLEAN
		do
			Result := count <= 0
		end

	valid_index (i: INTEGER): BOOLEAN
		do
			Result := (i >= 1) and then (i <= count)
		end

feature {NONE} -- Implementation

	content: ARRAY [T]

	default_value: detachable T

end
