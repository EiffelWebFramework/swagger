note
	description: "Represents a set of JSON converters, including the ability to share information amongst them."
	author: "Benoit Marchal"

class
	SWAGGER_CONVERTERS_SET

create
	make

feature {NONE} -- Constructor

	make
		do
			create {IMMUTABLE_STRING}base_directory.make_empty
			create {IMMUTABLE_STRING}current_file.make_empty
			-- pour permettre de passer Current en param�tres, ces objets doivent �tre
			-- d�tachables... par facilit� j'ai d�fini des m�thodes pour permettre
			-- d'y acc�der comme s'ils �taient attach�s
			create package_implementation.make (Current)
			create parameter_implementation.make (Current)
			create resources_implementation.make (Current)
			create resource_implementation.make (Current)
		ensure
			package_set: attached package_implementation
			parameter_set: attached parameter_implementation
			resources_set: attached resources_implementation
			resource_set: attached resource_implementation
		end

feature -- Access

	base_directory: READABLE_STRING
		assign set_base_directory

	current_file: READABLE_STRING
		assign set_current_file

	package: JSON_SWAGGER_API_CONVERTER
		once ("OBJECT")
			check attached package_implementation as a_package then
				Result := a_package
			end
		end

	parameter: JSON_PARAMETER_CONVERTER
		once ("OBJECT")
			check attached parameter_implementation as a_parameter then
				Result := a_parameter
			end
		end

	resources: JSON_SWAGGER_RESOURCE_LISTING_CONVERTER
		once ("OBJECT")
			check attached resources_implementation as a_resources then
				Result := a_resources
			end
		end

	resource: JSON_SWAGGER_API_DECLARATION_CONVERTER
		once ("OBJECT")
			check attached resource_implementation as a_resource then
				Result := a_resource
			end
		end

feature -- Element change

	set_base_directory (a_base_directory: like base_directory)
		do
			base_directory := a_base_directory
		ensure
			base_directory_set: base_directory = a_base_directory
		end

	set_current_file (a_current_file: like current_file)
		do
			current_file := a_current_file
		ensure
			current_file_set: current_file = a_current_file
		end

feature -- Utility

	add_converters_to (a_json: EJSON)
		do
			-- le probl�me de cet EJSON partag� c'est que, in fine, il nous oblige
			-- � utiliser des "variables globales" pour des choses qui devraient
			-- �tre tr�s locales... comme ici le r�pertoire de base
			-- d'o� le besoin de cr�er ce converter set, etc.
			-- je trouvais la formule o� l'on utilisait un classe d�di�e pour faire
			-- ce d�codage �tait beaucoup plus propre et maintenable
			a_json.add_converter (resources)
			a_json.add_converter (resource)
			a_json.add_converter (package)
			a_json.add_converter (parameter)
		end

feature {NONE} -- Implementation

	package_implementation: detachable like package
	parameter_implementation: detachable like parameter
	resources_implementation: detachable like resources
	resource_implementation: detachable like resource

end
