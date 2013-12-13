note
	description: "Helper class to convert JSON values to basic Eiffel types."
	author: "Olivier Ligot"

class
	JSON_CONVERSION_HELPER

feature -- Access

	string_value (a_value: detachable JSON_VALUE): detachable STRING
			-- String value from `a_value'.
		do
			if attached {JSON_STRING} a_value as l_value then
        		Result := l_value.item
        	end
		end

	string_number_value (a_value: detachable JSON_VALUE): detachable STRING
			-- String value that represent a number from `a_value'.
		do
			if attached {JSON_NUMBER} a_value as l_value then
        		Result := l_value.item
        	end
		end

	integer_value (a_value: detachable JSON_VALUE): detachable DS_CELL [INTEGER]
			-- Integer value from `a_value'.
		do
			if attached string_number_value (a_value) as l_value and then l_value.is_integer then
				create Result.make (l_value.to_integer)
        	end
        end

	boolean_value (a_value: detachable JSON_VALUE): detachable DS_CELL [BOOLEAN]
			-- Boolean value from `a_value'.
		do
			if attached {JSON_BOOLEAN} a_value as l_value then
				create Result.make (l_value.item)
			end
		end

end
