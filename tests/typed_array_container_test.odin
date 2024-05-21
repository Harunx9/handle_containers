package tests

import "core:testing"

import "../"

Test_Container_Struct :: struct {
	a: int,
	b: int,
}

@(test)
when_container_is_empty_it_should_allow_insert_new_elements :: proc(t: ^testing.T) {
	container := handle_containers.create_typed_array_container(Test_Container_Struct)

	handle := handle_containers.insert_into_typed_array_container(
		&container,
		Test_Container_Struct{a = 1, b = 2},
	)

	testing.expect(t, handle.idx == 0, "Handle index should be 0")
	testing.expect(t, handle.gen == 1, "Hadnle generation should be 1")
}
