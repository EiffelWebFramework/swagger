note
	description: "Filter that validates the input parameters."
	author: "Olivier Ligot"

class
	REST_INPUT_PARAMETERS_VALIDATION_FILTER

inherit
	REST_NOT_SENT_FILTER
	SHARED_EJSON
	SHARED_SIMPLE_TYPEDEF

create
	make

feature {NONE} -- Initialization

	make (a_method: like method)
		do
			method := a_method
		ensure
			method_set: method = a_method
		end

feature -- Access

	method: METHOD
			-- Method

feature -- Basic operations

	execute (req: WSF_REQUEST; res: WSF_RESPONSE)
			-- Execute the filter
		local
			l_missing_fields, l_invalid_fields: DS_LINKED_LIST [STRING]
			l_parameter: PARAMETER
			l_name: STRING
			l_object: JSON_OBJECT
			l_errors: JSON_ARRAY
			h: HTTP_HEADER
		do
			create l_missing_fields.make_equal
			create l_invalid_fields.make_equal
			across
				method.parameters as l_parameters
			loop
				l_parameter := l_parameters.item
				l_name := l_parameter.name
				if l_parameter.is_required then
					if (l_parameter.origin.is_from_path or l_parameter.origin.is_from_query) and req.item (l_name) = Void then
						l_missing_fields.force_last (l_name)
					end
				end
				if attached {WSF_STRING} req.item (l_name) as p and then (l_parameter.type ~ Integer_def and not p.is_integer) then
					l_invalid_fields.force_last (l_name)
				end
			end
			if not l_missing_fields.is_empty or not l_invalid_fields.is_empty then
				create l_object.make
				l_object.put (create {JSON_STRING}.make_json ("Validation Failed"), "message")
				create l_errors.make_array
				add_error (l_missing_fields, "missing_fields", l_errors)
				add_error (l_invalid_fields, "invalid_fields", l_errors)
				l_object.put (l_errors, "errors")
				res.set_status_code ({HTTP_STATUS_CODE}.unprocessable_entity)
				create h.make
				h.put_content_type ({HTTP_MIME_TYPES}.application_json)
				h.put_current_date
				h.put_content_length (l_object.representation.count)
				res.put_header_text (h.string)
				res.put_string (l_object.representation)
			end
			execute_next (req, res)
		end

feature {NONE} -- Implementation

	add_error (some_fields: DS_LIST [STRING]; a_code: STRING; some_errors: JSON_ARRAY)
		local
			l_error: JSON_OBJECT
		do
			if not some_fields.is_empty then
				create l_error.make
				l_error.put (json.value (some_fields.to_array), "fields")
				l_error.put (create {JSON_STRING}.make_json (a_code), "code")
				l_error.put (create {JSON_STRING}.make_json ("..."), "message")
				some_errors.add (l_error)
			end
		end

end
