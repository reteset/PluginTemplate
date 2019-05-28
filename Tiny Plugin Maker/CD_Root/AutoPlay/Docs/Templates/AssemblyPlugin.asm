; DESCRIPTION : 	Assembly Plugin Tamplate For AutoPlay Media Studio 8.*.*.*
; AUTHOR : 			Serkan Onat (Reteset Software) htts://www.reteset.net
; DATE MODIFIED : 	28.05.2019 (dd.mm,yyyy)
; ARCHITECTURE : 	X86 32Bits
; COMPILATION : 	Requires FASM for windows (flat assembler #.#.# for Windows) at https://flatassembler.net/download.php 

; The Plugin SDK functions are rely on dynamic memory therefore ;host application is responsible with allocation of memory and freeing it
; We are only responsible with copying data to allocated memory , and if memory space is not enough then return required size so ;
; Host application can call specified function again with necessary memory space allocated , Do not attempt to write more data than allocated space
; This will cause undesired results

; NOTES : 
; Do not modify 'SDKVersion' and 'LuaVersion' variables unless you know what you are doing
; The 'PluginXML' variable must contain at least <ActionTemplates></ActionTemplates> even if you do not plan to add actions xml,
; AMS will pop an error about 'failed to load plugin xml'

; The 'PluginSrc' variable will contain your byte array of plain Lua script or byte array of lua compiled chunk 
; Plain text is not allowed because special characters in scripts will cause compilation erros in FASM
; All variables that contain a string have to be terminated with a(  ,\0  )  as shown in the value of 'LuaVersion'

; Help File support is not implemented 

format pe gui 4.0 dll

include '<-FASM-INC->\win32ax.inc'


entry DllMain

section '.data' data readable writeable

SDKVersion      = 2
LuaVersion      TCHAR 'Lua 5.1',0
PluginName      TCHAR '<-PLUGIN_NAME->',0
PluginVersion   TCHAR '<-PLUGIN_VERS->',0
AuthorInfo      TCHAR '<-PLUGIN_INFO->',0
PluginXML       TCHAR <-PLUGIN_XML->,0
PluginSrc       TCHAR <-PLUGIN_SOURCE->,0
HelpFile        TCHAR 'Help.chm',0
HelpTopic       TCHAR '.html',0


section '.code' code readable executable

proc DllMain hinstDLL,fdwReason,lpvReserved
	mov	eax,TRUE
	ret
endp

proc irPlg_GetPluginName
        push ebp
        mov  ebp, esp
        push ebx

        push PluginName
        invoke strlen
        mov ebx, eax
        mov eax, dword[ebp+12]
        cmp ebx, dword[eax]
        jg  @PN

        push dword[eax]
        push 0
        push dword[ebp+8]
        invoke memset

        push PluginName
        push dword[ebp+8]
        invoke strcpy
        mov ebx,  eax
        @PN:
        pop ebx
        leave
        ret
endp
proc irPlg_GetAuthorInfo
        push ebp
        mov  ebp, esp
        push ebx

        push AuthorInfo
        invoke strlen
        mov ebx, eax
        mov eax, dword[ebp+12]
        cmp ebx, dword[eax]
        jg  @AI

        push dword[eax]
        push 0
        push dword[ebp+8]
        invoke memset

        push AuthorInfo
        push dword[ebp+8]
        invoke strcpy
        mov ebx,  eax
        @AI:
        pop ebx
        leave
        ret
endp
proc irPlg_GetPluginVersion
        push ebp
        mov  ebp, esp
        push ebx

        push PluginVersion
        invoke strlen
        mov ebx, eax
        mov eax, dword[ebp+12]
        cmp ebx, dword[eax]
        jg  @PV

        push dword[eax]
        push 0
        push dword[ebp+8]
        invoke memset

        push PluginVersion
        push dword[ebp+8]
        invoke strcpy
        mov ebx,  eax
        @PV:
        pop ebx
        leave
        ret
endp
proc irPlg_GetLuaVersion
        push ebp
        mov  ebp, esp
        push ebx

        push LuaVersion
        invoke strlen
        mov ebx, eax
        mov eax, dword[ebp+12]
        cmp ebx, dword[eax]
        jg  @LV

        push dword[eax]
        push 0
        push dword[ebp+8]
        cinvoke memset

        push LuaVersion
        push dword[ebp+8]
        invoke strcpy
        mov ebx,  eax
        @LV:
        pop ebx
        leave
        ret
endp
proc irPlg_GetPluginActionXML
        push ebp
        mov  ebp, esp
        push ebx

        push PluginXML
        invoke strlen
        mov ebx, eax
        mov eax, dword[ebp+12]
        cmp ebx, dword[eax]
        jg  @AX

        push dword[eax]
        push 0
        push dword[ebp+8]
        invoke memset

        push PluginXML
        push dword[ebp+8]
        invoke strcpy
        mov ebx,eax
        @AX:
        pop ebx
        leave
        ret
endp
proc irPlg_ShowHelpForPlugin
        mov eax, 0
        ret
endp
proc irPlg_ShowHelpForAction
        mov eax, 0
        ret
endp
proc irPlg_ValidateLicense
        mov eax, 1
        ret
endp
proc irPlg_GetSDKVersion
        mov eax, SDKVersion
        ret
endp
proc irPlg_Action_RegisterActions
		push ebp
        mov  ebp, esp

        push ebx
        mov ebx, dword[ebp+8] ; LuaState pointer

        push PluginSrc
        invoke strlen


        push PluginName
        push eax
        push PluginSrc
        push ebx

        cinvoke luaL_loadbuffer; ,dword[ebp+8], PluginSrc, PluginSrcLength, "line"
        add  esp,4*4
        push 0
        push 0
        push 0
        push ebx
        cinvoke lua_pcall; ,dword[ebp+8], 0, 0, 0
        add  esp,4*4
        mov eax, 0
        pop ebx
        leave
        ret
endp

section '.idata' import data readable writeable

	library vcrt,'msvcrt.dll',\
			lua,'lua5.1.dll'

	import vcrt,\
		strlen,'strlen',\
		memset,'memset',\
		strcpy,'strcpy'

	import lua,\
		luaL_loadbuffer,'luaL_loadbuffer',\
		lua_error,'lua_error',\
		lua_pushstring,'lua_pushstring',\
		lua_pcall,'lua_pcall'



section '.edata' export data readable

export 'AssemblyPlugin.dll',\
		irPlg_GetPluginName,'irPlg_GetPluginName',\
        irPlg_GetAuthorInfo,'irPlg_GetAuthorInfo',\
        irPlg_GetPluginVersion,'irPlg_GetPluginVersion',\
        irPlg_GetLuaVersion,'irPlg_GetLuaVersion',\
        irPlg_ShowHelpForPlugin,'irPlg_ShowHelpForPlugin',\
        irPlg_ShowHelpForAction,'irPlg_ShowHelpForAction',\
        irPlg_GetPluginActionXML,'irPlg_GetPluginActionXML',\
        irPlg_Action_RegisterActions ,'irPlg_Action_RegisterActions',\
        irPlg_GetSDKVersion ,'irPlg_GetSDKVersion',\
        irPlg_ValidateLicense,'irPlg_ValidateLicense'

section '.reloc' fixups data readable discardable

