
import strutils

proc get_first_32(name: string): int32 {.discardable.} =
    let f = open(name, fmRead)
    defer: f.close()

    while not f.endOfFile:
        echo "-----------------" & $f.getFilePos()
        var s = f.readLine()
        for i in s:
            echo int8(i).toHex() & " " & i

    return 0

#get_first_32("new2.nsql")