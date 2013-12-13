note
	description: "Singleton pattern for messenger."
	author: "Benoît Marchal"

class
	SHARED_MESSENGER

feature {NONE} -- Access

	messenger: MESSENGER
		once
			create Result.make
		end

end
