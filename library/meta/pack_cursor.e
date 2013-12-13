note
	description: "Cursor over the pack content."
	author: "Benoît Marchal"

class
	PACK_CURSOR [T -> attached PACKAGEABLE_I]

inherit
	ITERATION_CURSOR [T]

create
	make

feature {NONE} -- Constructor

	make (a_pack: like pack)
		do
			pack := a_pack
			index := 1
		ensure
			pack_set: pack = a_pack
			index_set: index = 1
		end

feature -- Access

	item: T
		do
			Result := pack.at (index)
		end

feature -- Status report	

	after: BOOLEAN
		do
			Result := index > pack.count
		end

	first: BOOLEAN
		do
			Result := index = 1
		end

	last: BOOLEAN
		do
			Result := index = pack.count
		end

feature -- Cursor movement

	forth
		do
			index := index + 1
		end

feature {NONE} -- Implementation

	pack: PACK [T]
	index: INTEGER

end
