note
	description: "Factory for the parameter origin."
	author: "Benoît Marchal"

class
	SHARED_PARAMETER_ORIGIN

feature -- Factory

	Originate_from_body: PARAMETER_ORIGIN
		once
			create Result.make_from_body
		end

	Originate_from_path: PARAMETER_ORIGIN
		once
			create Result.make_from_path
		end

	Originate_from_query: PARAMETER_ORIGIN
		once
			create Result.make_from_query
		end

end
