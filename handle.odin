package handle_containers

Handle :: struct {
	idx: HandleId,
	gen: Generation,
}

Handle_Allocator :: struct {
	free:         [dynamic]HandleId,
	alive:        [dynamic]Handle_Info,
	current_size: u32,
}

create_handle_allocator :: proc(min_size := MIN_HANDLE_NUM) -> Handle_Allocator {
	return(
		Handle_Allocator {
			free = make([dynamic]HandleId, 0, min_size),
			alive = make([dynamic]Handle_Info, 0, min_size),
			current_size = 0,
		} \
	)
}

destroy_handle_allocator :: proc(allocator: Handle_Allocator) {
	delete(allocator.free)
	delete(allocator.alive)
}

alloc_handle :: proc(allocator: ^Handle_Allocator) -> Handle {
	idx, ok := pop_safe(&allocator.free)
	if ok {
		info := &allocator.alive[idx]
		if info == nil {
			panic("Handle Allocator is corrupted")
		}
		info.generation += 1
		info.is_alive = true
		return Handle{idx = idx, gen = info.generation}
	} else {
		allocator.current_size += 1
		append(&allocator.alive, Handle_Info{generation = 1, is_alive = true})
		return Handle{idx = allocator.current_size - 1, gen = 1}
	}
}

free_handle :: proc(allocator: ^Handle_Allocator, handle: Handle) -> bool {
	if is_handle_alive(allocator, handle) {
		info := &allocator.alive[handle.idx]
		info.is_alive = false

		append(&allocator.free, handle.idx)
		return true
	}

	return false
}

is_handle_alive :: proc(allocator: ^Handle_Allocator, handle: Handle) -> bool {
	info := &allocator.alive[handle.idx]
	if info == nil {
		return false
	}

	return info.generation == handle.gen && info.is_alive
}
