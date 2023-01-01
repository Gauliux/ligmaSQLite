
import utils
import streams

var CODEOFLASTRETURN: int8 = int8(true)
var ITEMS_INDEX: int8 = 0x00
var DEPTH_INDEX: array[0xFF'u, int8]
var LOAD_POS: int64 = 0x00

type Command = enum
    RCOL = 0x01, RDOC, DOCT

proc `!`(value: int8): char =
    return char(value)

proc `!`(value: Command): char =
    return char(value)

proc init_db(name: string = "new.nsql"): bool {.discardable.} = 
    let f = open(name, fmWrite)
    defer: f.close()

    #MS-DOS/UNIX moment
    #0x89 needs probably or other way
    f.writeLine("nosqlite" & !0x0D & !0x0A & !0x1A & !0x0A)
    f.writeLine(!0x01)

    return true

proc load(name: string): bool {.discardable.} =
    let f = newFileStream(name, fmRead)
    defer: f.close()

    #while not f.atEnd:
    #    var one_char = f.readInt32


    return true    

#[
proc get_load_pos(name: string): int64 {.discardable.} =
    let f = open(name, fmRead)
    defer: f.close()

    while(not f.endOfFile):
        var str: string = f.readLine()
        if(str[0] == !0x01):
            return f.getFilePos()

    return 0
]#

proc add(
        filename: string; 
        command: Command; 
        name: string = ""; 
        content: string = ""
        ): bool {.discardable.} =

    let f = open(filename, fmAppend)
    defer: f.close()

    case command
    of Command.RCOL:
        f.write(!0x00 & !Command.RCOL & !0x00 & !ITEMS_INDEX & name & "\n")
        inc(ITEMS_INDEX)
    of Command.RDOC:
        f.write(!0x00 & !Command.RDOC & !0x00 & !ITEMS_INDEX & name & "\n")
        f.write(!0x00 & !Command.DOCT & !0x00 & !ITEMS_INDEX & content & "\n")
        inc(ITEMS_INDEX)
    of Command.DOCT:
        f.write(!0x00 & !Command.DOCT & !0x00 & !ITEMS_INDEX & content & "\n")

    return true


var file: string = "new2.nsql"
file.init_db()
#LOAD_POS = file.get_load_pos()
#file.load()
file.add(command = Command.RCOL, name = "collection1")
file.add(command = Command.RDOC, name = "document1", content = "Here's some text")
file.add(command = Command.RDOC, name = "document2", content = "Here's more text")
file.add(command = Command.RDOC, name = "document3", content = "Damn too much text")