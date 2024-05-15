package tests;
import "../"
import "core:testing"
import "core:fmt"

@(test)
when_create_new_handle_should_be_ok :: proc(t : ^testing.T){
    handle_allocator := handle_containers.create_handle_allocator();

    handle := handle_containers.alloc_handle(&handle_allocator);

    testing.expect(t, handle.idx == 0, "handle idx should be 0")
    testing.expect(t, handle.gen == 1, "handle gen should be 1")
}

@(test)
when_create_two_new_handle_should_be_ok :: proc(t : ^testing.T){
    handle_allocator := handle_containers.create_handle_allocator();

    handle_one := handle_containers.alloc_handle(&handle_allocator);
    handle_two := handle_containers.alloc_handle(&handle_allocator);

    testing.expect(t, handle_one.idx == 0, "handle one should be 0")
    testing.expect(t, handle_one.gen == 1, "handle one gen should be 1")
    testing.expect(t, handle_two.idx == 1, "handle two idx should be 1")
    testing.expect(t, handle_two.gen == 1, "handle two gen should be 1")
}

@(test)
new_handle_should_be_alive :: proc(t : ^testing.T){
    handle_allocator := handle_containers.create_handle_allocator();

    handle := handle_containers.alloc_handle(&handle_allocator);

    testing.expect(t, handle_containers.is_handle_alive(&handle_allocator, handle), "handle should be alive")
}

@(test)
when_free_handle_should_not_be_alive :: proc(t : ^testing.T){
    handle_allocator := handle_containers.create_handle_allocator();

    handle := handle_containers.alloc_handle(&handle_allocator);
    handle_containers.free_handle(&handle_allocator, handle);

    testing.expect(t, handle_containers.is_handle_alive(&handle_allocator, handle) == false, "handle should not be alive")
}

@(test)
when_free_handle_and_alloc_new_handle_should_reuse_old_handle :: proc(t : ^testing.T){
    handle_allocator := handle_containers.create_handle_allocator();

    handle_one := handle_containers.alloc_handle(&handle_allocator);
    handle_containers.free_handle(&handle_allocator, handle_one);
    handle_two := handle_containers.alloc_handle(&handle_allocator);

    testing.expect(t, handle_one.idx == handle_two.idx, "handle idx should be the same")
    testing.expect(t, handle_one.gen + 1 == handle_two.gen, "handle gen should be the same")
}

