type PathType* = enum
    SET, REC, NOT

type Item* = ref object of RootObj
    pathtype*: PathType
    name*: string

type Storage* = seq[Item]

type ItemRec* = ref object of Item
    content*: string

type ItemSet* = ref object of Item
    content*: Storage

proc getItemRec*(item: Item): ItemRec =
    return cast[ItemRec](item)

proc getItemSet*(item: Item): ItemSet =
    return cast[ItemSet](item)

proc itemToString*(item: Item): string =
    case item.pathtype
    of PathType.REC:
        var a = item.getItemRec
        return "[ type: " & repr(a.pathtype) & " , name: " & a.name & " , value: " & a.content & " ]"
    of PathType.SET:
        var a = item.getItemSet
        return "[ type: " & repr(a.pathtype) & " , name: " & a.name & " , seqlen: " & $len(a.content) & " ]"
    of PathType.NOT:
        return "[ type: " & repr(item.pathtype) & " , name: " & item.name & " ]"

proc repeat*(s: string; n: uint): string =
    var buff: string = ""

    for i in 1..n: buff &= s

    return buff

type Stack*[T] = seq[T]
type Vec2* = (int,int)

proc isEmpty*(sequence: seq[auto]): bool =
    return (len(sequence) == 0)

proc last*(stack: seq[auto]): auto =
    return stack[len(stack)-1]

proc isLast*(value: auto; sequence: seq[auto]): bool =
    return (last(sequence) == value)

proc pop*(stack: ptr seq[auto]): auto =
    var res: auto = last(stack[])
    stack[].delete(len(stack[])-1)
    return res

proc push*(stack: ptr seq[auto], value: auto) =
    stack[].add(value)

proc to*(storage: Storage; name: string): ItemSet =
    for i, value in storage:
        if value.name == name and value.pathtype == PathType.SET:
            return value.getItemSet

proc two*(storage: Storage; name: string): ptr Storage =
    for i, value in storage:
        if value.name == name and value.pathtype == PathType.SET:
            return addr value.getItemSet.content
    return nil

proc three*(storage: Storage; name: string): ptr Item =
    for i, value in storage:
        if value.name == name:
            return unsafeAddr storage[storage.find(value)]
    return nil
