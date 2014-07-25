note
	description: "JSON converter for parameter."
	author: "Olivier Ligot"

class
	JSON_PARAMETER_CONVERTER

inherit
    JSON_CONVERTER
    SHARED_SIMPLE_TYPEDEF

create {SWAGGER_CONVERTERS_SET}
    make

feature {NONE} -- Initialization

    make (a_parent_set: SWAGGER_CONVERTERS_SET)
    	local
    		l_type: SWAGGER_PARAMETER_TYPE
        do
        	create l_type.make_from_path
            create object.make ("name", String_def, l_type, Void, True)
        	create helper
        end

feature -- Access

    object: SWAGGER_PARAMETER

    value: detachable JSON_OBJECT

feature -- Conversion

    from_json (j: attached like value): detachable like object
    	local
    		l_required: BOOLEAN
    		l_default_value: detachable IMMUTABLE_STRING
    	do
    		if attached helper.string_value (j.item (K_name)) as l_name
    			and attached helper.string_value (j.item (K_dataype)) as l_dataype
    			and attached helper.string_value (j.item (K_paramtype)) as l_paramtype then
    			if attached helper.boolean_value (j.item (K_required)) as l_json_required then
    				l_required := l_json_required.item
    			end
    			if attached helper.string_value (j.item (K_defaultvalue)) as l_json_default_value then
    				create l_default_value.make_from_string (l_json_default_value)
    			end
    			if attached helper.string_value (j.item (K_description)) as l_description then
    				create Result.make_with_description (l_name, l_description,
    					create {TYPEDEF_SIMPLE}.make (l_dataype), create {SWAGGER_PARAMETER_TYPE}.make (l_paramtype),
    					l_default_value, l_required)
    			else
	    			create Result.make (l_name, create {TYPEDEF_SIMPLE}.make (l_dataype),
	    				create {SWAGGER_PARAMETER_TYPE}.make (l_paramtype), l_default_value, l_required)
    			end
    		end
    	end

    to_json (o: like object): like value
        do

        end

feature {NONE} -- Implementation

	K_name: STRING = "name"
	K_dataype: STRING = "dataType"
	K_paramtype: STRING = "paramType"
	K_required: STRING = "required"
	K_description: STRING = "description"
	K_defaultvalue: STRING = "defaultValue"

	helper: JSON_CONVERSION_HELPER

end
