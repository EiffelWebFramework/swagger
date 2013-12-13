note
	description: "Filter that can only be executed when the response has not already been sent."
	author: "Olivier Ligot"

deferred class
	REST_NOT_SENT_FILTER

inherit
	REST_EXECUTABLE_FILTER

feature -- Status report

	is_executable (req: WSF_REQUEST; res: WSF_RESPONSE): BOOLEAN
			-- Can the filter be executed?
		do
			Result := not res.header_committed
		end

end
