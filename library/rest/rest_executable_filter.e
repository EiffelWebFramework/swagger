note
	description: "Executable filter."
	author: "Olivier Ligot"

deferred class
	REST_EXECUTABLE_FILTER

inherit
	WSF_FILTER
		redefine
			execute,
			execute_next
		end

feature -- Status report

	is_executable (req: WSF_REQUEST; res: WSF_RESPONSE): BOOLEAN
			-- Can the filter be executed?
		deferred
		end

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the filter.
		require else
			executable: is_executable (req, res)
		deferred
		end

feature {REST_EXECUTABLE_FILTER} -- Implementation

	execute_next (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the `next' filter.
		do
			if attached {REST_EXECUTABLE_FILTER} next as n then
				if n.is_executable (req, res) then
					n.execute (req, res)
				else
					n.execute_next (req, res)
				end
			else
				Precursor (req, res)
			end
		end

end
