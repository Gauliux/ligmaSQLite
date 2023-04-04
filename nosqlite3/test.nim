
import utils
import std/strutils

var root: Storage
#[
root.add(ItemSet(pathtype: PathType.SET, name: "SET_01", content: @[]))
root.add(ItemRec(pathtype: PathType.REC, name: "REC", content: "Cringe"))
root[0].getItemSet.content.add(ItemSet(pathtype: PathType.SET, name: "SET_01_01", content: @[]))

root.two("SET_01")[].add(ItemRec(pathtype: PathType.REC, name: "REC1", content: "Cringe"))
root.two("SET_01")[].two("SET_01_01")[].add(ItemRec(pathtype: PathType.REC, name: "REC2", content: "Cringe"))
root.two("SET_01")[].two("SET_01_01")[].add(ItemRec(pathtype: PathType.REC, name: "REC3", content: "Cringe"))
root.two("SET_01")[].two("SET_01_01")[].add(ItemSet(pathtype: PathType.SET, name: "SET_01_01_01", content: @[]))
root.two("SET_01")[].two("SET_01_01")[].two("SET_01_01_01")[].add(ItemRec(pathtype: PathType.REC, name: "REC_LAST", content: "Cringe"))
]#

root.add(ItemSet(pathtype: PathType.SET, name: "root", content: @[]))
root.two("root")[].add(ItemRec(pathtype: PathType.REC, name: "REC1", content: "I"))
root.two("root")[].add(ItemRec(pathtype: PathType.REC, name: "REC2", content: "Love"))
root.two("root")[].add(ItemRec(pathtype: PathType.REC, name: "REC3", content: "Bananas"))

#[
iterator countup(a, b: int; ss: seq[string]): string =
    var res = a
    while res <= b:
        yield ss[res]
        inc(res)
]#

proc get(path: string): ptr Item =
    var path_names = rsplit(path, "/")
    var destination : ptr Item = root.three(path_names[0])
    for i, value in path_names:
        if i < 1: continue
        if destination[].pathtype == PathType.SET:
            destination = destination[].getItemSet.content.three(value)
        if destination[].pathtype == PathType.REC:
            break
    return destination

proc set(path: string, name: string = "") =
    var path_names = rsplit(path, "/")
    var destination : ptr Item = root.three(path_names[0])
    for i, value in path_names:
        if i < 1: continue
        if destination[].pathtype == PathType.SET:
            destination = destination[].getItemSet.content.three(value)
        if destination[].pathtype == PathType.REC:
            break
    #return destination

var a = get("root/REC1")[].getItemRec
echo a.itemToString

var b = get("root")[].getItemSet
echo b.itemToString

var c = root.three("ANAL")
echo repr(c)

#[
var path_names = rsplit("SET_01/SET_01_01/REC2", "/")
var destination : ptr Storage = addr root

destination = destination[].two(path_names[0])
echo repr(destination[].len)
destination = destination[].two(path_names[1])
echo repr(destination[].len)

#destination = destination[].two(path_names[2])
#echo repr(destination[])
]#

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
                else:
                    return

getPathTree(root)