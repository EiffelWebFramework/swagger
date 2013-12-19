note
	description: "Utility methods to manipulate a JSON_OBJECT conveniently."
	author: "Benoît Marchal"

class
	JSON_OBJECT_WRAPPER

feature {NONE} -- String access

	has_string (json: JSON_OBJECT; key: JSON_STRING): BOOLEAN
		do
			Result := json.has_key (key) and then attached {JSON_STRING} json.item (key)
		end

	string_item (json: JSON_OBJECT; key: JSON_STRING): READABLE_STRING
		require
			has_string: has_string (json, key)
		do
			Result := json_string_item (json, key).item
		end

	json_string_item (json: JSON_OBJECT; key: JSON_STRING): JSON_STRING
		require
			has_string: has_string (json, key)
		do
			check attached {JSON_STRING} json.item (key) as an_item then
				Result := an_item
			end
		end

feature {NONE} -- Array access

	has_array (json: JSON_OBJECT; key: JSON_STRING): BOOLEAN
		do
			Result := json.has_key (key) and then attached {JSON_ARRAY} json.item (key)
		end

	array_item (json: JSON_OBJECT; key: JSON_STRING): JSON_ARRAY
		require
			has_array: has_array (json, key)
		do
			check attached {JSON_ARRAY} json.item (key) as an_item then
				Result := an_item
			end
		end

feature {NONE} -- Object access

	has_object (json: JSON_OBJECT; key: JSON_STRING): BOOLEAN
		do
			Result := json.has_key (key) and then attached {JSON_OBJECT} json.item (key)
		end

	object_item (json: JSON_OBJECT; key: JSON_STRING): JSON_OBJECT
		require
			has_object: has_object (json, key)
		do
			check attached {JSON_OBJECT} json.item (key) as an_item then
				Result := an_item
			end
		end

end
