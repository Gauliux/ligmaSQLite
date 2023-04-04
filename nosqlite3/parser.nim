
import utils
import std/strutils

var root: Storage
root.add(ItemSet(pathtype: PathType.SET, name: "root", content: @[]))

type WayType = enum
    HARD = "HARD", CLEAR = "CLEAR"

type FormatType = enum
    ITEM = "ITEM", NIMSTR = "NIMST", JSON = "JSON"

type StateMachine = object
    way: WayType
    last: PathType
    value: string
    format: FormatType
    look: PathType

type RoutineType = enum
    SET = "SET", GET = "GET", UPD = "UPD", DEL = "DEL"

proc r_get(path: seq[string]; last: PathType; format: FormatType; look: PathType) =
    
    echo "get_pelmeni"

proc r_set(path: seq[string]; way: WayType; last: PathType; input: string) =
    var destination : ptr Item
    var counter: int
    for i, value in path:
        #echo $i & "..." & value
        if i == 0: 
            destination = root.three(value)
            continue
        if (destination[].getItemSet.content.three(value)) == nil:
            #echo "\t\t - NOT EXISTS"
            break
        else: 
            destination = destination[].getItemSet.content.three(value)
            inc(counter)
    #echo counter

    for i, value in path:
        #echo $i & "..." & value
        if i == 0: 
            destination = root.three(value)
            continue
        if i <= counter:
            destination = destination[].getItemSet.content.three(value)
        else:
            #echo "\t\t - NOT EXISTS, but just a moment..."
            if value.isLast(path) and last == PathType.REC:
                destination[].getItemSet.content.add(ItemRec(pathtype: PathType.REC, name: value, content: input))
                break
            destination[].getItemSet.content.add(ItemSet(pathtype: PathType.SET, name: value, content: @[]))
            destination = destination[].getItemSet.content.three(value)
    
    #echo "set_pelmeni"

proc r_upd(path: seq[string]; input: string) =
    var destination : ptr Item
    for i, value in path:
        if i == 0: 
            destination = root.three(value)
            continue
        if destination[].pathtype == PathType.SET:
            destination = destination[].getItemSet.content.three(value)
        if destination[].pathtype == PathType.REC:
            destination[].getItemRec.content = input
            break
    #echo "upd_pelmeni"

proc r_del(path: seq[string]; look: PathType) =
    var destination : ptr Item
    for i, value in path:
        if i == 0: 
            destination = root.three(value)
            continue
        if i >= path.len-2: break
        if destination[].pathtype == PathType.SET:
            destination = destination[].getItemSet.content.three(value)
        if destination[].pathtype == PathType.REC:
            break
    
    var stack: Stack[(int, PathType)]

    for i, value in destination[].getItemSet.content:
        stack.add((i, value.pathtype))

    case look:
    of PathType.SET, PathType.REC:
        for i in countdown(stack.len-1, 0):
            if stack[i][1] == look:
                destination[].getItemSet.content.del(stack[i][0])
    #HERE'S BUNCH OF BUGS
    #AND IT LOOKS LIKE A MESS >:/
    of PathType.NOT:
        destination[].getItemSet.content.del(destination[].getItemSet.content.find(destination[].getItemSet.content.three(path.last)[]))
    


proc exec(routine: RoutineType; path_names: seq[string]; ship: StateMachine) =
    case routine:
    of RoutineType.GET: r_get(path_names, ship.last, ship.format, ship.look)
    of RoutineType.SET: r_set(path_names, ship.way, ship.last, ship.value)
    of RoutineType.UPD: r_upd(path_names, ship.value)
    of RoutineType.DEL: r_del(path_names, ship.look)
    

proc pars(q: string) =
    var base = rsplit(q, "|")
    var routine = parseEnum[RoutineType](base[0])
    var path_names = rsplit(base[1], "/")
    var subs = rsplit(base[2], "->")
    var ship: StateMachine

    for i, value in subs:
        case value
        of "look":
            ship.look = parseEnum[PathType](subs[i+1])
            continue
        of "way":
            #if routine == RoutineType.SET
            ship.way = parseEnum[WayType](subs[i+1])
            continue
        of "last":
            ship.last = parseEnum[PathType](subs[i+1])
            continue
        of "value":
            ship.value = subs[i+1]
            continue
        of "format":
            ship.format = parseEnum[FormatType](subs[i+1])
            continue
    
    #echo routine
    #echo path_names
    #echo ship

    exec(routine, path_names, ship)


proc getPathTree(db: seq[Item], nesting: uint = 0; iteration: int = 0; stack: ptr Stack[Vec2] = nil) =

    var nest_level: uint = nesting
    #var recall: (uint,uint) = stack[len(stack)-1]
    var border: Vec2

    #if not stack[].isEmpty or stack != nil:
        #border = stack[].pop

    for i, value in db:

        if i >= iteration: 
            echo $nest_level & ":" & $i & " " & repeat("\t", nest_level) & "- " & value.name

            if value.pathtype == PathType.SET:
                if not value.getItemSet.content.isEmpty:
                    #echo "Nest!"
                    inc(nest_level)
                    getPathTree(value.getItemSet.content, nest_level)
                


pars("SET|root/rec1|last->REC->value->TEST")
echo "#############"
getPathTree(root)