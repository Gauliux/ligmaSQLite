
import strutils

var CODEOFLASTRETURN: int8 = int8(true)

proc init_db(name: string = "new.ndb"): bool {.discardable.} =
    let f = open(name, fmWrite)
    defer: f.close()

    f.writeLine("nosqlite")
    f.writeLine(char(0xFF))
    f.writeLine("config" & "/")
    f.writeLine(char(0x20) & char(0x01) & "Name")
    f.writeLine(char(0x20) & char(0x10) & name)
    f.writeLine(char(0x00))
    f.writeLine(char(0xFF))
    return true


proc get_doc(filename: string; root: string): bool {.discardable.} =
    let f = open(filename, fmRead)
    defer: f.close()

    return false

proc add_doc(filename: string; root: string; docName: string; docValue: string): bool {.discardable.} =

    var writepos: int64

    block findpos:
        let f = open(filename, fmRead)
        defer: f.close()

        var line: string
        var flag: char

        while(not f.endOfFile):
            line = f.readLine()
            echo $f.getFilePos() & "." & line
            if(line == root):
                while(not f.endOfFile):
                    line = f.readLine()
                    echo $f.getFilePos() & "." & line
                    if(char(0x00).in(line)):
                        writepos = f.getFilePos()
                        echo writepos
            
    
    block setdoc:
        let f = open(filename, fmReadWriteExisting)
        defer: f.close()

        f.setFilePos(writepos)
        f.write(char(0x01) & docName & "\n")
        f.writeLine(char(0x10) & docValue)
        f.writeLine(char(0x00))

    return false

var filename = "test.ndb"
init_db(filename)
add_doc(filename, "config/", "test", "balls")


echo "\t\nLAST RETURNED VALUE: " & $CODEOFLASTRETURN