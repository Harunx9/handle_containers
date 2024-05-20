package tests

import sut "../"
import "core:testing"

Test_Storage_Item :: struct {
	a: int,
	b: int,
}

@(test)
when_storage_is_empty_should_be_appendable :: proc(t: ^testing.T) {
	allocator := sut.create_typed_handle_allocator(Test_Storage_Item)
	storage := sut.create_typed_array_storage(Test_Storage_Item)

	handle := sut.alloc_typed_handle(&allocator)
	sut.insert_typed_data(&storage, handle, Test_Storage_Item{a = 1, b = 2})

	item := sut.get_typed_data(&storage, handle).?

	testing.expect(t, item.a == 1, "Expected a to be 1")
	testing.expect(t, item.b == 2, "Expected b to be 2")
}

@(test) 
when_storage_have_data_it_should_be_ptr_get :: proc(t: ^testing.T) {
	allocator := sut.create_typed_handle_allocator(Test_Storage_Item)
	storage := sut.create_typed_array_storage(Test_Storage_Item)

	handle := sut.alloc_typed_handle(&allocator)
	sut.insert_typed_data(&storage, handle, Test_Storage_Item{a = 1, b = 2})

	item := sut.get_typed_data_ptr(&storage, handle).?

	testing.expect(t, item.a == 1, "Expected a to be 1")
	testing.expect(t, item.b == 2, "Expected b to be 2")
}

@(test)
when_data_is_replaced_should_be_new_data :: proc(t: ^testing.T) {
	allocator := sut.create_typed_handle_allocator(Test_Storage_Item)
	storage := sut.create_typed_array_storage(Test_Storage_Item)

	handle := sut.alloc_typed_handle(&allocator)
	sut.insert_typed_data(&storage, handle, Test_Storage_Item{a = 1, b = 2})
	sut.replace_typed_data(&storage, handle, Test_Storage_Item{a = 3, b = 4})

	item := sut.get_typed_data_ptr(&storage, handle).?

	testing.expect(t, item.a == 3, "Expected a to be 1")
	testing.expect(t, item.b == 4, "Expected b to be 2")
}

