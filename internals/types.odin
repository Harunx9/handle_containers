package internals

MIN_ELEMENT_NUMBER: u32 = 1024

HandleId :: u32
Generation :: u32

Handle_Info :: struct{
    is_alive : bool,
    generation : Generation,
}
