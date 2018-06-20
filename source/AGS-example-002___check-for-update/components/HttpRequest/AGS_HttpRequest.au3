#cs --------------------------------------------------------------------------------------------------------
HttpRequest

Service helper to send HTTP requests GET or POST, with the Winhttprequest.5.1 COM object.
More information here : https://beamtic.com/http-requests-autoit

Component title   : HttpRequest
Component version : 1.0.0
AutoIt version    : 3.3.14.5
Author            : v20100v <7567933+v20100v@users.noreply.github.com>
Package           : AGS version 1.0.0
#ce --------------------------------------------------------------------------------------------------------

#include-once


Opt('MustDeclareVars', 1)


;===========================================================================================================
; Send HTTP request with GET method
;
; @param $url (string)    : URL want to open
; @param $data (string)   : Data to be posted by GET method (?param1=23&param2=ibicf)
; @param $proxy (string)  : Specify a proxy. By default we load proxy settings form configuration file
; @return $oHttp (object) : Instance of the Winhttprequest.5.1 object
;
; @example
; <code>
;   Local $response = HttpGET("http://www.google.com/", default, "http://myproxy.com:20100")
;   ConsoleWrite($response.Status & @CRLF)
;   ConsoleWrite($response.ResponseText)
; </code>
;===========================================================================================================
Func HttpGET($url, $data = "", $proxy = "")
	Local $oHttp = ObjCreate("WinHttp.WinHttpRequest.5.1")

	; Configure timeouts on $oHttp instance
	$oHttp = WinHttp_SetTimeouts_from_configuration_file($oHttp)

	; Configure proxy on $oHttp instance
	$oHttp = WinHttp_SetProxy_from_configuration_file($oHttp)

	; If we have $proxy arguments in this method it overrides proxy settings from configuration file
	If ($proxy <> "") Then
		$oHttp.SetProxy(2, $proxy)
	EndIf

	; Prepare url to send
	If ($data <> "") Then
		$url = $url & "?" & $data
	EndIf

	$oHttp.Open("GET", $url, False)
	If (@error) Then Return SetError(1, 0, 0)

	$oHttp.Send()
	If (@error) Then Return SetError(2, 0, 0)

	If ($oHttp.Status <> 200) Then
		Return SetError(3, $oHttp.Status, $oHttp.ResponseText)
	EndIf

	Return SetError(0, 0, $oHttp)
EndFunc


;===========================================================================================================
; Send HTTP request with POST method
;
; @param $url (string)    : URL want to open
; @param $data (string)   : Data to be posted by POST method
; @param $proxy (string)  : Specify a proxy. By default we load proxy settings form configuration file
; @return $oHttp (object) : Instance of the Winhttprequest.5.1 object
;===========================================================================================================
Func HttpPOST($url, $data = "", $proxy = "")
	Local $oHttp = ObjCreate("WinHttp.WinHttpRequest.5.1")

	; Configure timeouts on $oHttp instance
	$oHttp = WinHttp_SetTimeouts_from_configuration_file($oHttp)

	; Configure proxy on $oHttp instance
	$oHttp = WinHttp_SetProxy_from_configuration_file($oHttp)

	; If we pass $proxy arguments in this method it overrides proxy settings from configuration file
	If ($proxy <> "") Then
		$oHttp.SetProxy(2, $proxy)
	EndIf

	$oHttp.Open("POST", $url, False)
	If (@error) Then Return SetError(1, 0, 0)

	$oHttp.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	$oHttp.Send($data)
	If (@error) Then Return SetError(2, 0, 0)

	If ($oHttp.Status <> 200) Then
		Return SetError(3, $oHttp.Status, $oHttp.ResponseText)
	EndIf

	Return SetError(0, 0, $oHttp)
EndFunc


;===========================================================================================================
; URL encode
;
; @param $urlText (string)
; @return $urlEncoded (string)
;
; @example
; <code>
;	ConsoleWrite(URLEncode("123abc!@#$%^&*()_+ ") & @crlf)
;	ConsoleWrite(URLEncode("mére & père !!!") & @crlf)
; </code>
;===========================================================================================================
Func URLEncode($urlText)
	Local $urlEncoded = ""
	Local $acode

	For $i = 1 To StringLen($urlText)
		$acode = Asc(StringMid($urlText, $i, 1))
		Select
			Case ($acode >= 48 And $acode <= 57) Or _
					($acode >= 65 And $acode <= 90) Or _
					($acode >= 97 And $acode <= 122)
				$urlEncoded = $urlEncoded & StringMid($urlText, $i, 1)

			Case $acode = 32
				$urlEncoded = $urlEncoded & "+"

			Case Else
				$urlEncoded = $urlEncoded & "%" & Hex($acode, 2)
		EndSelect
	Next

	Return $urlEncoded
EndFunc


;===========================================================================================================
; URL decode
;
; @param $urlText (string)
; @return $urlDecoded (string)
;===========================================================================================================
Func URLDecode($urlText)
	$urlText = StringReplace($urlText, "+", " ")
	Local $matches = StringRegExp($urlText, "\%([abcdefABCDEF0-9]{2})", 3)
	If Not @error Then
		For $match In $matches
			$urlText = StringReplace($urlText, "%" & $match, BinaryToString('0x' & $match))
		Next
	EndIf
	Return $urlText
EndFunc


;===========================================================================================================
; SetTimeouts by parsing the configuration file './config/myApplication.ini'
;
; @param $oHttp (object)  : Instance of the Winhttprequest.5.1 object
; @return $oHttp (object) : Instance of the Winhttprequest.5.1 object
;
; $RESOLVE_TIMEOUT (int) : Time-out value applied when resolving a host name to an IP address (such as
;                         www.microsoft.com to 192.168.131.199), in milliseconds. The default value
;                         is zero, meaning no time-out (infinite).
; $CONNECT_TIMEOUT (int) : Time-out value applied when establishing a communication socket with the
;                         target server, in milliseconds. The default value is 60 seconds.
; $SEND_TIMEOUT (int)    : Time-out value applied when sending an individual packet of request data on
;                         the communication socket to the target server, in milliseconds. A large
;                         request sent to an HTTP server are normally be broken up into multiple
;                          packets; the send time-out applies to sending each packet individually.
;                         The default value is 30,000 (30 seconds).
; $RECEIVE_TIMEOUT (int) : Time-out value applied when receiving a packet of response data from the
;                         target server, in milliseconds. Large responses are be broken up into
;                          multiple packets; the receive time-out applies to fetching each packet
;                         of data off the socket. The default value is 30,000 (30 seconds).
;===========================================================================================================
Func WinHttp_SetTimeouts_from_configuration_file($oHttp)
	Local $RESOLVE_TIMEOUT = Int(IniRead($APP_CONFIGURATION_INI, "AGS_HTTP_REQUEST", "RESOLVE_TIMEOUT", 0))
	Local $CONNECT_TIMEOUT = Int(IniRead($APP_CONFIGURATION_INI, "AGS_HTTP_REQUEST", "CONNECT_TIMEOUT", 60000))
	Local $SEND_TIMEOUT = Int(IniRead($APP_CONFIGURATION_INI, "AGS_HTTP_REQUEST", "SEND_TIMEOUT", 30000))
	Local $RECEIVE_TIMEOUT = Int(IniRead($APP_CONFIGURATION_INI, "AGS_HTTP_REQUEST", "RECEIVE_TIMEOUT", 30000))

	$oHttp.SetTimeouts($RESOLVE_TIMEOUT, $CONNECT_TIMEOUT, $SEND_TIMEOUT, $RECEIVE_TIMEOUT)
	Return $oHttp
EndFunc


;===========================================================================================================
; Set proxy by parsing the configuration file './config/myApplication.ini'
;
; @param $oHttp (object)  : Instance of the Winhttprequest.5.1 object
; @return $oHttp (object) : Instance of the Winhttprequest.5.1 object
;===========================================================================================================
Func WinHttp_SetProxy_from_configuration_file($oHttp)
	Local $proxy = IniRead($APP_CONFIGURATION_INI, "AGS_HTTP_REQUEST", "PROXY", "")

	If ($proxy <> "") Then
		$oHttp.SetProxy(2, $proxy)
	EndIf
	Return $oHttp
EndFunc
