note
	description: "Factory for the simple datatypes, there can only be one instance of this."
	author: "Benoît Marchal"

class
	SHARED_SIMPLE_TYPEDEF

inherit
	REFACTORING_HELPER

feature -- Declaration

	Byte_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("byte")
		end

	Boolean_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("boolean")
		end

	Integer_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("int")
		end

	Long_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("long")
		end

	Float_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("float")
		end

	Double_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("double")
		end

	Number_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("number")
		end

	String_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("string")
		end

	Date_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("Date")
		end

	Null_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make ("null")
		end

	Nogood_def: TYPEDEF_I
		once
			create {TYPEDEF_SIMPLE}Result.make_no_good
		end

feature -- Test

	is_swagger_simple_type (a_type: READABLE_STRING): BOOLEAN
		do
			Result := a_type.is_equal ("byte") or a_type.is_equal ("boolean")
						or a_type.is_equal ("int") or a_type.is_equal ("long")
						or a_type.is_equal ("float") or a_type.is_equal ("double")
						or a_type.is_equal ("string") or a_type.is_case_insensitive_equal ("Date")
						or a_type.is_equal ("void")
		ensure
			coherent: Result implies not swagger_to_simple_typedef (a_type).is_no_good
		end

	is_jsonschema_simple_type (a_type: READABLE_STRING): BOOLEAN
		do
			Result := a_type.is_equal ("boolean") or a_type.is_equal ("integer")
						or a_type.is_equal ("number") or a_type.is_equal ("null")
						or a_type.is_equal ("string")
		ensure
			coherent: Result implies not jsonschema_to_simple_typedef (a_type).is_no_good
		end

	is_numeric (a_type: TYPEDEF_I): BOOLEAN
		do
			Result := a_type = Byte_def or a_type = Integer_def
						or a_type = Long_def or a_type = Float_def
						or a_type = Double_def or a_type = Number_def
		end

feature -- Factory

	swagger_to_simple_typedef (a_type: READABLE_STRING): TYPEDEF_I
		do
			if a_type.is_equal ("byte") then
				Result := Byte_def
			elseif a_type.is_equal ("boolean") then
				Result := Boolean_def
			elseif a_type.is_equal ("int") then
				Result := Integer_def
			elseif a_type.is_equal ("long") then
				Result := Long_def
			elseif a_type.is_equal ("float") then
				Result := Float_def
			elseif a_type.is_equal ("double") then
				Result := Double_def
			elseif a_type.is_equal ("string") then
				Result := String_def
			elseif a_type.is_case_insensitive_equal ("Date") then
				Result := Date_def
			elseif a_type.is_equal ("void") then
				Result := Null_def
			else
				Result := Nogood_def
			end
		end

	jsonschema_to_simple_typedef (a_type: READABLE_STRING): TYPEDEF_I
		do
			if a_type.is_equal ("boolean") then
				Result := Boolean_def
			elseif a_type.is_equal ("integer") then
				Result := Integer_def
			elseif a_type.is_equal ("number") then
				Result := Number_def
			elseif a_type.is_equal ("null") then
				Result := Null_def
			elseif a_type.is_equal ("string") then
				Result := String_def
			else
				Result := Nogood_def
			end
		end

	plsql_to_simple_typedef (a_type: READABLE_STRING): TYPEDEF_I
		do
			if a_type.is_equal ("NUMBER") then
				Result := Number_def
			elseif a_type.is_equal ("DATE") then
				Result := Date_def
			elseif a_type.is_equal ("VARCHAR2") then
				Result := String_def
			else
				to_implement ("more PL/SQL to typedef conversion")
				-- FIXME not proper handling
				Result := Null_def
			end
		end

feature -- Formatting

	typedef_to_swagger (a_type: TYPEDEF_I): READABLE_STRING
		require
			isgood: not a_type.is_no_good
		do
			if a_type = Byte_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("byte")
			elseif a_type = Boolean_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("boolean")
			elseif a_type = Integer_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("int")
			elseif a_type = Long_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("long")
			elseif a_type= Float_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("float")
			elseif a_type = Double_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("double")
			elseif a_type = String_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("string")
			elseif a_type = Date_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("Date")
			elseif a_type = Null_def then
				create {IMMUTABLE_STRING_8}Result.make_from_string ("void")
			else
				create {IMMUTABLE_STRING_8}Result.make_empty
			end
		end

end
