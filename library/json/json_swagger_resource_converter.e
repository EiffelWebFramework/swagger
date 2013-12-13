note
	description: "JSON converter for swagger resource."
	author: "Olivier Ligot"

class
	JSON_SWAGGER_RESOURCE_CONVERTER

inherit
    JSON_CONVERTER

    SHARED_MESSENGER

create {SWAGGER_CONVERTERS_SET}
    make

feature {NONE} -- Initialization

    make (a_parent_set: like parent_set)
        do
            create object.make ("", "", create {ARRAY [PACKAGE]}.make_empty, "")
            create declarations.make_empty
            parent_set := a_parent_set
        	create helper
        ensure
        	parent_set_set: parent_set = a_parent_set
        end

feature -- Access

	declarations: SWAGGER_MODELS_FACTORY

    object: SWAGGER_RESOURCE

    value: detachable JSON_OBJECT

	model (a_name: STRING): detachable TYPEDEF_I
		do
			Result := declarations.item (a_name)
		end

feature -- Conversion

    from_json (j: attached like value): detachable like object
    	local
			l_swagger_apis: ARRAY [PACKAGE]
    	do
			if attached {JSON_OBJECT} j.item (K_models) as l_models then
	    		create declarations.make (parent_set.current_file, l_models)
	    	else
	    		create declarations.make_empty
	    	end
    		if attached helper.string_value (j.item (K_api_version)) as l_api_version and
        		attached helper.string_value (j.item (K_swagger_version)) as l_swagger_version and
        		attached {JSON_ARRAY} j.item (K_apis) as l_apis and
        		attached helper.string_value (j.item (K_resource_path)) as l_resource_path then
        		create l_swagger_apis.make_empty
        		across
        			l_apis.array_representation as c
        		loop
        			if attached {PACKAGE} json.object (c.item, "PACKAGE") as l_package then
        				l_swagger_apis.force (l_package, l_swagger_apis.upper + 1)
        			end
        		end
        		create Result.make (l_api_version, l_swagger_version, l_swagger_apis, l_resource_path)
        	end
    	end

    to_json (o: like object): like value
        do

        end

feature {NONE} -- Implementation

	parent_set: SWAGGER_CONVERTERS_SET

	K_api_version: STRING = "apiVersion"
	K_swagger_version: STRING = "swaggerVersion"
	K_apis: STRING = "apis"
	K_models: STRING = "models"
	K_resource_path: STRING = "resourcePath"

	helper: JSON_CONVERSION_HELPER

end
