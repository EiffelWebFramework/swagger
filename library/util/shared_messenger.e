note
	description: "Singleton pattern for messenger."
	author: "Beno�t Marchal"

class
	SHARED_MESSENGER

feature {NONE} -- Access

	messenger: MESSENGER
		once
			create Result.make
		end

end
